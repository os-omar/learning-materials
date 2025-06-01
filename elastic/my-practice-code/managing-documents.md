// Create a new Index called `products` with change in settings.
// NOTE: for production use, it's recomemended to stick with the default settings. unless there is a neeed for it.
PUT /products
{
  "settings": {
    "number_of_shards": 2,
    "number_of_replicas": 2
  }
}

// Delete an Index called `pages`
DELETE /products


// Create a new Index called `products` with the default settings.
PUT /products


// Create a new document belongs to `products` index.
// if you don't specifiy the "_id", ElasticSearch will generate one for you. 
POST /products/_doc
{
  "name": "Coffee Maker",
  "price": 64,
  "in_stock": 10
}


// to specify the "_id" manually with value "100", you must use `PUT` operation.
PUT /products/_doc/100
{
  "name": "Toaster",
  "price": 49,
  "in_stock": 4
}

// Fetch a specific `product` document.
GET /products/_doc/100


// - update an existing field `in_stock`.
POST /products/_update/100
{
  "doc": {
    "in_stock": 5
  }
}

// - update the document with a new field `tags` array.
POST /products/_update/100
{
  "doc": {
    "tags": ["electronics"]
  }
}


// 22. Scripted updates lesson

// Write a script to decsrease the `in_stock` value by 1 ?
POST /products/_update/100
{
  "script": {
    "source": "ctx._source.in_stock--"
  }
}

// Write a script to change the `in_stock` value to 10 ?
POST /products/_update/100
{
  "script": {
    "source": "ctx._source.in_stock = 10"
  }
}


// Write a script to change the `in_stock` value to 4 using params ?
POST /products/_update/100
{
  "script": {
    "source": "ctx._source.in_stock -= params.quantity",
    "params": {
      "quantity": 4
    }
  }
}

// adding conditions and update `ctx.op` which stands for operation.
// 'noop' means no operations.
POST /products/_update/100
{
  "script": {
    "source": """
    if(ctx._source.in_stock == 0) {
      ctx.op = 'noop';
    }
    ctx._source.in_stock--;
    """
  }
}

// - 'delete' means delete the document.
// - deleting the product if there it's out of stock.
POST /products/_update/100
{
  "script": {
    "source": """
    if(ctx._source.in_stock == 0) {
      ctx.op = 'delete';
    }
    ctx._source.in_stock--;
    """
  }
}

// 23. Upserts lesson

GET /products/_doc/101

// - the script will be run of the product document `101` exist.
// - if not the upsert method will be run instead and create a new one.
// - NOTE: this example does not make sense, it's just to show how upsert works.
POST /products/_update/101
{
  "script": {
    "source": "ctx._source.in_stock++"
  },
  "upsert": {
    "name": "Blender",
    "price": 399,
    "in_stock": 5
  }
}

// 24. Repleacing documents lesson
// - `POST`: is used when we create a new document or updating speific fields in an existing document.
// - `PUT`: is used when replacing an entire document with a diffrernt once.

GET /products/_doc/100

PUT /products/_doc/100
{
  "name": "Toaster",
  "price": 79,
  "in_stock": 4
}


// 25. Deleting documents lesson
GET /products/_doc/101

DELETE /products/_doc/101

// 30. Optimistic concurrency control
GET /products/_doc/100

POST /products/_update/100?if_primary_term=1&if_seq_no=27
{
  "doc": {
    "in_stock": 123
  }
}

// 31. Update by Query
POST /products/_update_by_query
{
  // if there is a `version_conflicts` happened, then it will continue and not abort the update query.
  // the default behavior is to abort the update query and throw an error.
  "conflicts": "proceed", 
  "script": {
    "source": "ctx._source.in_stock--",
    "lang": "painless"
  },
  "query": {
    "match_all": {}
  }
}

// - check if `in_stock` value exist first
POST /products/_update_by_query
{
  "script": {
        "source": """
      if (ctx._source.containsKey('in_stock') && ctx._source.in_stock != null) {
        ctx._source.in_stock--;
      }
    """,
      "lang": "painless"
  },
  "query": {
    "match_all": {}
  }
}


// GET all products
GET /products/_search
{
  "query": {
    "match_all": {}
  }
}



// 32. Delete by Query
// DELETE ALL documents in `product` index.
POST /products/_delete_by_query
{
  "query": {
    "match_all": {}
  }
}


// 33. Batch processing
// using Postman make sure to set `Content-Type: application/x-ndjson`

// - "index" is like upsert if exist update OR create if it does not exist.
// - "create" create if it does not exist OR throw an error if exist.
// if you're running bulk actions with diffrent `_index` in each operation, you specify the _index with in the oberation.
POST /_bulk
{ "index": {"_index": "products", "_id": 200} }
{ "name": "Espresso Machine", "price": 199, "in_stock": 5 }
{ "create": { "_index": "products", "_id": 201 } }
{ "name": "Milk Frother", "price": 149, "in_stock": 14 }


// if all your bluk actions are with in the same `_index` you can specify it inside the api call.
POST /products/_bulk
{ "update": { "_id": 201 } }
{ "doc": { "price": 129 } }
{ "delete": { "_id": 200 } }

GET /_cat/shards
