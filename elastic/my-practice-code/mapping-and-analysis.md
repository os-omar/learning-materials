// 38. Using the Analyze API
POST /_analyze
{
  "text": "2 guys walk into     a house, but the thrid.... DUCKS! :-)",
  "analyzer": "standard"
}

//  "analyzer": "standard" is basically this:
POST /_analyze
{
  "text": "2 guys walk into     a house, but the thrid.... DUCKS! :-)",
  "char_filter": [],
  "tokenizer": "standard",
  "filter": ["lowercase"]
}

// 42. How the "keyword" data type works

// the text is left completely untouched when using the "analyzer": "keyword"
// the `keyword` analyzer is used only in
//    - searching for an exact match.
//    - filtering.
//    - sorting.
//    - aggregations
POST /_analyze
{
  "text": "2 guys walk into     a house, but the thrid.... DUCKS! :-)",
  "analyzer": "keyword"
}

// for email addresses makes sense to store them in "analyzer": "keyword"
// Basically structured data, which could be e-mail addresses, order statuses, product tags, etc.
POST /_analyze
{
  "text": "orhman@seekasia.com",
  "analyzer": "keyword"
}

// 43. Understanding type coercion

// - creating a new index called `coercion_test`
// - then storing a new document with `_id = 1`
PUT /coercion_test/_doc/1
{
  "price": 7.4
}

// - it works because the coercion mapper converted string into a float then store it.
// - it only works when the value can be converted from a string to a number.
PUT /coercion_test/_doc/2
{
  "price": "7.4"
}


/**
   "_source": {
    "price": "7.4"
  }
  - explaintion because the "_source" key contains the original value type that is been used when indexing the document.
  - you need to be careful when entreing your values if you don't want this faeture.
  - OR disable coercion mapping.
*/

GET /coercion_test/_doc/2

// - it fails because "7.4m" cannot be converted to a number
PUT /coercion_test/_doc/3
{
  "price": "7.4m"
}

// Clean-up: Delete the index as it's not used anymore.
DELETE /coercion_test


// 44. Understanding arrays

POST /_analyze
{
  "text": ["Strings are simply", "merged together."],
  "analyzer": "standard"
}

// - when using array, all values must have the type.
// - OR if the values can be coerced, assuming the coercion is enabled.
// - for simple data type can be coerced examples
//    - string to boolean "true" => true
//    - string to a number "9" => 9

// - However for onjects it will return an error. example array
// [{name:  "Omar"}, {name: "Lolya"}, false] => wrong throw an error.


// - Nested Arrays are allowed as well.
// - for that you need to use the `nested` data type when querying.
// - example: [1, [2, 3]] => it will be indexed like: [1, 2, 3]

// 45. Adding explicit mappings

PUT /reviews
{
  "mappings": {
    "properties": {
      "rating": { "type": "float" },
      "content": { "type": "text"},
      "product_id": { "type": "integer"},
      "auther": {
        "properties": {
          "first_name": { "type": "text" },
          "last_name": { "type": "text" },
          "email": { "type": "keyword" }
        }
      }
    }
  }
}

// adding the first document to index `reviews`
PUT /reviews/_doc/1
{
  "rating": 5.0,
  "content": "Outstanding course! Omar really taught me a lot about Elasticsearch!",
  "product_id": 123,
  "auther": {
    "first_name": "Omar",
    "last_name": "Salim",
    "email": "orhman@seekasia.com"
    // "email": {}, // will throw an error
    // "email": 1, // will pass because of coercion is enabled it will be indexed "1"
    // "email": true, // will pass because of coercion is enabled it will be indexed "true"
    
  }
}

GET /reviews/_doc/1

// 46. Retrieving mappings
GET /reviews/_mapping
GET /reviews/_mapping/field/content
GET /reviews/_mapping/field/auther.email

// 47. Using dot notation in field names

// - using  `"properties": {}` when mapping an object, it can look messy with very nested & complex object. 
PUT /reviews_dot_notation
{
  "mappings": {
    // the first one is fine, we must you it.
    "properties": {
      "rating": { "type": "float" },
      "content": { "type": "text"},
      "product_id": { "type": "integer"},
      // this format is a bit easier for human eye.
      "auther.first_name": { "type": "text" },
      "auther.last_name": { "type": "text" },
      "auther.email": { "type": "keyword" }
    }
  }
}

GET /reviews_dot_notation/_mapping

// 48. Adding mappings to existing indices
PUT /reviews/_mapping
{
  "properties": {
    "created_at": { "type": "date" }
  }
}

GET /reviews/_mapping

// 49. How dates work in Elasticsearch
// - the date has to be in type ISO 8601

PUT /reviews/_doc/2
{
  "rating": 4.5,
  "content": "Not bad. Not bad at all!",
  "product_id": 123,
  // the time will be assumed as midnight if it is not specified.
  // example of when we need only date but not time: when storing the birth date of a person.
  "created_at": "2015-03-27",
  "author": {
    "first_name": "Average",
    "last_name": "Joe",
    "email": "avgjoe@example.com"
  }
}

PUT /reviews/_doc/3
{
  "rating": 3.5,
  "content": "Could be better",
  "product_id": 123,
  // date and time are seperated by the letter `T`
  // `Z` means is in UTC timezone
  "created_at": "2015-04-15T13:07:41Z",
  "author": {
    "first_name": "Spencer",
    "last_name": "Pearson",
    "email": "spearson@example.com"
  }
}


PUT /reviews/_doc/4
{
  "rating": 5.0,
  "content": "Incredible!",
  "product_id": 123,
  // offset by 1 hour compared to UTC `Z`
  "created_at": "2015-01-28T09:21:51+01:00",
  "author": {
    "first_name": "Adam",
    "last_name": "Jones",
    "email": "adam.jones@example.com"
  }
}


PUT /reviews/_doc/5
{
  "rating": 4.5,
  "content": "Very useful",
  "product_id": 123,
  // Equivalent to 2015-07-04T12:01:24Z
  // a long number representing the number of miliseconds
  // DO NOT specifiy Unix timestamp it won't work.
  // he number of miliseconds = Unix timestamp * 1000
  "created_at": 1436011284000,
  "author": {
    "first_name": "Taylor",
    "last_name": "West",
    "email": "twest@example.com"
  }
}

GET /reviews/_search
{
  "query": {
    "match_all": {}
  }
}


// 50. How missing fields are handled
// - All fields in Elasticsearch are optional.
// - Adding a field mapping does not make a field required.
// - Searches automatically handle missing fields
//     - it only pick those records which have the field exist.


// 51. Overview of mapping parameters
// - `null` values are ignored in Elasticsearch.
// - The same applied for empty arrays `[]` or an array of null values [null, null].
// `null_value` 

POST /reviews/_update/1
{
  "doc": {
    "content": null // it will apply the change.
  }
}


// 52. Updating existing mappings

GET /reviews/_mapping

// it will throw an error you cannot update an existing type to `keyword`.
PUT /reviews/_mapping
{
  "properties": {
    "product_id": {
      "type": "keyword"
    }
  }
}

// - you can only add `ignore_above` to an existing mapping field.
// - `ignore_above` means: you can only index until 256 chars the rest will be ignored.
// - it will not be indexed nor be stored.
PUT /reviews/_mapping
{
  "properties": {
    "auther": {
      "properties": {
        "email": {
          "type": "keyword",
          "ignore_above": 256
        }
      }
    }
  }
}

// 53. Reindexing documents with the Reindex API

// first: create a new index called `reviews_new`
PUT /reviews_new
{
  "mappings": {
    "properties": {
      "auther": {
        "properties": {
          "email": {
            "type": "keyword",
            "ignore_above": 256
          },
          "first_name": {
            "type": "text"
          },
          "last_name": {
            "type": "text"
          }
        }
      },
      "author": {
        "properties": {
          "email": {
            "type": "text",
            "fields": {
              "keyword": {
                "type": "keyword",
                "ignore_above": 256
              }
            }
          },
          "first_name": {
            "type": "text",
            "fields": {
              "keyword": {
                "type": "keyword",
                "ignore_above": 256
              }
            }
          },
          "last_name": {
            "type": "text",
            "fields": {
              "keyword": {
                "type": "keyword",
                "ignore_above": 256
              }
            }
          }
        }
      },
      "content": {
        "type": "text"
      },
      "created_at": {
        "type": "date"
      },
      "product_id": {
        "type": "keyword"
      },
      "rating": {
        "type": "float"
      }
    }
  }
}

GET /reviews_new/_mapping

// second: use `_reindex` api to migrate documents from `reviews` to `reviews_new` index.
// - This is an out of the box solution as re-indexing is quite common in busniess needs
POST /_reindex
{
  "source": {
    "index": "reviews"
  },
  "dest": {
    "index": "reviews_new"
  }
}

// - Notice `product_id` is now an integer not a string.
// - Because the `product_id` field in `reviews` index is of type integer.
// - However for `keyword` type you expected to be a string what is the solution.
// - The solution is to run a script while using `_reindex` api.
GET /reviews_new/_search
{
  "query": {
    "match_all": {}
  }
}

// - re-indexing with a script this time.
// - the script changes the type of product_id from `integer` to `string` while re-indexing.
POST /_reindex
{
  "source": {
    "index": "reviews"
  },
  "dest": {
    "index": "reviews_new"
  },
  "script": {
    "source": """
      if(ctx._source.product_id != null) {
        ctx._source.product_id = ctx._source.product_id.toString();
      }
    """
  }
}

// - We can add `query` to `_reindex` api to specify what records we can to re-index.
// - For advance querying we can use `script` and `ctx.op` to specify what we need.
// - `query` is way faster and writing a script. you should always prefer it when ever possible.
// - We can specify what fields we can to include by adding source fileting `_source`
// - We can rename a field as well using `_source` inside `script`




// 54. Defining field aliases

// - Alternative of renaming a field an that requires re-indexing and migrating all docuements.

// - add new field called `comment of type `alias` that points to `content` field.
PUT /reviews/_mapping
{
  "properties": {
    "comment": {
      "type": "alias",
      "path": "content"
    }
  }
}


// - searching using `content`
GET /reviews/_search
{
  "query": {
    "match": {
      "content": "Could"
    }
  }
}

// - searching using `comment` alias.
// - returns the same results as the above query.
GET /reviews/_search
{
  "query": {
    "match": {
      "comment": "Could"
    }
  }
}

// 55. Multi-field mappings
// - a field that been maaped as both "text" & "keyword"

// - “text” fields are used for performing full-text searches that do not require exact matches
// - we cannot run aggregations on “text” fields. Instead, we need to use the “keyword” data type.




// Creating a new index `multi_field_test.
// - It has `description` only indexed as `text`.
// - and has `ingredients` indexed as `text` & `keyword`.
//     - `text` as we want to be able to search for them and deos not have to me the exat match.
//     - `keyword` used for aggregation e.g: how many recipes that has `sugar` as an ingredient in it.
PUT /multi_field_test
{
  "mappings": {
    "properties": {
      "description": {
        "type": "text"
      },
      "ingredients": {
        "type": "text",
        "fields": {
          "keyword": {
            "type": "keyword"
          }
        }
      }
    }
  }
}


POST /multi_field_test/_doc
{
  "description": "To Make this spaghetti carbonara, you first need to ....",
  "ingredients": ["Spaghetti", "Bacon", "Eggs"]
}

GET /multi_field_test/_search
{
  "query": {
    "match_all": {}
  }
}

GET /multi_field_test/_search
{
  "query": {
    "match": {
      "ingredients": "spaghetti"
    }
  }
}

GET /multi_field_test/_search
{
  "query": {
    // `term query require to provide the exact match.
    "term": {
      "ingredients.keyword": "Spaghetti"
    }
  }
}

DELETE /multi_field_test

// Create an index `multi_field_test_2` with the default mapping.
POST /multi_field_test_2/_doc
{
  "description": "To Make this spaghetti carbonara 2, you first need to ....",
  "ingredients": ["Spaghetti", "Bacon", "Eggs", "Milk"]
}

// when you don't specify mapping all text will be both mapped to `text` and `keyword`
GET multi_field_test_2/_mapping

DELETE /multi_field_test_2


// 56. Index templates
// -  An index template is a way to automatically apply settings and field mappings whenever a new index is created 
// - provided that its name matches one of the defined patterns.

// Use Cases
// - system logs, where is prefered to be devided into indices based on year, month or even days.
// - System logs should follow the same pattern, and for efficiency and speed in searching it's recommended to devide the logs into multiple indices. It does better job than sharing?
// - Example naming convension:
//   - Yearly indices: `access-logs-<year>`
//   - Monthly indices: `access-logs-<year>-<month>`
//   - Daily indices: `access-logs-<year>-<month>-<day>`

// Create a new `_index_template` named `access-logs`
// Note: The same format can be used for updating an existing template `access-logs`
// PUT HTTP means: replacing a resource.
PUT /_index_template/access-logs
{
  "index_patterns": ["access-logs-*"],
  "template": {
    "settings": {
      "number_of_shards": 2,
      "index.mapping.coerce": false
    },
    "mappings": {
      "properties": {
        "@timestamp": { "type": "date" },
        "url.original": { "type": "wildcard" },
        "url.path": { "type": "wildcard" },
        "url.scheme": { "type": "keyword" },
        "url.domain": { "type": "keyword" },
        "client.geo.continent_name": { "type": "keyword" },
        "client.geo.country_name": { "type": "keyword" },
        "client.geo.region_name": { "type": "keyword" },
        "client.geo.city_name": { "type": "keyword" },
        "user_agent.original": { "type": "keyword" },
        "user_agent.name": { "type": "keyword" },
        "user_agent.version": { "type": "keyword" },
        "user_agent.device.name": { "type": "keyword" },
        "user_agent.os.name": { "type": "keyword" },
        "user_agent.os.version": { "type": "keyword" }
      }
    }
  }
}


// Creating Monthly indices on the fly while indexing a document.
// This index is for Jan-2023
POST /access-logs-2023-01/_doc
{
  "@timestamp": "2023-01-01T00:00:00Z",
  "url.original": "https://example.com/products",
  "url.path": "/products",
  "url.scheme": "https",
  "url.domain": "example.com",
  "client.geo.continent_name": "Europe",
  "client.geo.country_name": "Denmark",
  "client.geo.region_name": "Capital City Region",
  "client.geo.city_name": "Copenhagen",
  "user_agent.original": "Mozilla/5.0 (iPhone; CPU iPhone OS 12_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0 Mobile/15E148 Safari/604.1",
  "user_agent.name": "Safari",
  "user_agent.version": "12.0",
  "user_agent.device.name": "iPhone",
  "user_agent.os.name": "iOS",
  "user_agent.os.version": "12.1.0"
}

// - Verifying the mapping of `access-logs-2023-01` index follows the template mapping.
GET /access-logs-2023-01/_mapping

// - Verifying the mapping of `access-logs-2023-01` index follows the template settings.
GET /access-logs-2023-01/_settings




// 57. Introduction to dynamic mapping
// - `long` always been chosen for numbers.
//  - sometimes having `integer` is good enough.
//  - When storing millions of documents, it might be worth explicitly mapping the field as an `integer` instead.
// - For strings the default dynamic mapping is to have 2 mapping:
//  - `text` mapping which is the standard analyzer used for text searching.
//  - `keyword` mapping which is providing the exact matching. used for aggregation sorting and filtering.
// - The dynamic string mapping is not the best practice for the following senarios:
//  - Tags: ["computer", "electronics"] -> is very uncommen to use tags for text searching. usually tags are meant to be used for filtering and aggregation so only `keyword` type is enough.
//  - This means that the “text” mapping would be unused, and it would just cause indexing overhead and a waste of disk space.

// - This brings me to the “ignore_above” parameter that has a value of 256.
// - This simply ignores strings that are more than 256 characters long, 
// - causing the value to not be part of the inverted index for the “keyword” mapping.
// - This is done because it almost never makes sense to use such long values for sorting and aggregations.
// - In such a case, the values just use unnecessary disk space, because the data is effectively duplicated for each mapping.


// - description: "hello my name is Omar" -> is very uncommen to use description field for exact matches so ONLY `text` mapping type is enough.



// - Therefore you should consider this default mapping a sensible default that is used for convenience.
// - If you know that you won’t need either of the two mappings, then you should consider adding your own mapping as an optimization.

// an Example of dynamic mapping.
GET /products/_mapping



// 58. Combining explicit and dynamic mapping
PUT /people
{
  "mappings": {
    "properties": {
      "first_name": {
        "type": "text"
      }
    }
  }
}

// it will cerate a dynamic mapping for "last_name" with both `text` and `keyword` type.
POST /people/_doc
{
  "first_name": "Omar",
  "last_name": "Salim"
}

GET /people/_mapping

// Clean UP
DELETE /people


// 59. Configuring dynamic mapping
PUT /people
{
  "mappings": {
    // - It will ignore new fields for mapping.
    // - unmapped fields will only be stored in `_source` document.
    // - it's not recommended to set "dynamic": false
    // - there is a third type which is: "dynamic": "strict", which will throw an error if there is any new field added when POSTing a new document. aka it will act as `zod` run time value checking
    "dynamic": false, 
    "properties": {
      "first_name": {
        "type": "text"
      }
    }
  }
}

POST /people/_doc
{
  "first_name": "Omar",
  "last_name": "Salim"
}

// - in `_mapping` we only see `first_name`
GET /people/_mapping

// - the search result will bring back the original doument with the `last_name` provided.
GET /people/_search
{
  "query": {
    "match": {
      "first_name": "Omar"
    }
  }
}

// - there will be no result as we did not mapped `last_name`
GET /people/_search
{
  "query": {
    "match": {
      "last_name": "Salim"
    }
  }
}

// Clean UP
DELETE /people

// 63. Built-in analyzers
POST /_analyze
{
  "text": "2 guys walk into     a house, but the thrid.... DUCKS! :-)",
  "analyzer": "english"
}

POST /_analyze
{
  "text": "2 guys walks into     a house, but the thrid.... DUCKS! :-), He Gives me joy",
  "char_filter": [],
  "tokenizer": "standard",
  "filter": ["lowercase", "stemmer"]
}
