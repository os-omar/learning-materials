// 69. Introduction to searching

// - `_shards.skipped` it can skip the operation if it determines it does not that the value you're looking for.
// - `_shards.skipped` typically happened when we request range query.

// - `hits.total.relation` equal to `"eq"` means: the given `hits.total.value` is an accurate number, which is almost alaways be the case.

// - `hits.max_score` equal to `1` means: the percentagge of document that matches the query, `1` means `%100`. Because we used `match_all` it maches all doument therefore the max_score = 1
GET /products/_search
{
  "query": {
    "match_all": {}
  }
}


// 70. Intoduction to term level queries.

// - `term` used to find the exact match, (i.e filtering, &/or aggregation).
// - `term` level queries are not analyzed.
// - You should never use `terms` _search query with `text` ONLY data type.
// - `term` should ONLY be for `keyword` data type.
// - `term` or `terms` default pagination is 10 hits aka records.

// 71. Searching for terms

GET /products/_mapping

// - for `term` only one value.
GET /products/_search
{
  "query": {
    "term": {
      "tags.keyword": "Vegetable"
    }
  }
}

// - We use `terms` when need a document that has at least one of these these terms.
// - `tages.keyword` CONTAINS "Soup" AND/OR "MEAT"
GET /products/_search
{
  "query": {
    "terms": {
      "tags.keyword": [
        "Soup",
        "Meat"
      ]
    }
    }
}

// 72. Retrieving documents by IDs

// SQL equivalent:
// SELECT * FROM products WHERE _id IN ("100", "200", "300

// - It will not throw an error if a centrain `_id` does not exist. It simply returns what exist.
// - For this example only `"100"`, `"200"`, & `"300"` found in `products` index
GET /products/_search
{
  "query": {
    "ids": {
      "values": ["100", "200", "300", "20000"]
    }
  }
}



// 73. Range searches

// - `range` query is for ranges usually used in numbers.
GET /products/_search
{
  "query": {
    "range": {
      "in_stock": {
        // `gte`: greater than or equal aka `>=`
        "gte": 1,
        // `lte`: less than or equal aka `<=`
        "lte": 5
      }
    }
  }
}

GET /products/_search
{
  "query": {
    "range": {
      "in_stock": {
        // `gt`: greater than aka `>`
        "gt": 1,
        // `lt`: less than aka `<`
        "lt": 5
      }
    }
  }
}

// - `range` can also be used with `date` field types.
// - if the time is not specified it will default to midnight 00:00
GET /products/_search
{
  "query": {
    "range": {
      "created": {
        // all the products created with in the month of October 2016
        "gte": "2016/10/01",
        "lte": "2016/10/31"
      }
    }
  }
}


// 74. Prefixes, wildcard & regular expressions.


// Prefix:
// - `prefix` query is used for an exact match of the beginning of the field
// - example "Pasta - Back Olive" aka "Past`*`"
// - if it's not in the beginning the document won't match with this query (e.i. "LaLa Pasta").

GET /products/_search
{
  "query": {
    "prefix": {
      "name.keyword": {
        "value": "Past"
      }
    }
  }
}


GET /products/_search
{
  "query": {
    "prefix": {
      "name.keyword": {
        "value": "past",
        // it support case_insensitive but not the default one. you should specifiy
        "case_insensitive": true
      }
    }
  }
}

// - Wildcards:

// - Wildcard - `?`: A question mark matches any single character, 
//   - example `Past?` -> "Pasta" or "Paste"  aka no more than one char.
GET /products/_search
{
  "query": {
    "wildcard": {
      "tags.keyword": {
        "value": "Past?"
        // it support case_insensitive but not the default one. you should specifiy
        // "case_insensitive": true
      }
    }
  }
}

// - Wildcard - `*`: an asterisk `*` matches any character zero or more.
//   - example: `Bee*` -> `Bee`, `Beef`, or `Beets` ..etc
// Note: you should avoid having wildcards `*` in the begginning of the search query. It will work but it has performance issues (e.i: `*Bee`).
GET /products/_search
{
  "query": {
    "wildcard": {
      "tags.keyword": {
        "value": "Bee*"
         // it support case_insensitive but not the default one. you should specifiy
        // "case_insensitive": true
      }
    }
  }
}


// regular expressions: `regexp`
GET /products/_search
{
  "query": {
    "regexp": {
      "tags.keyword": {
        "value": "Bee(f|r)+"
         // it support case_insensitive but not the default one. you should specifiy
        // "case_insensitive": true
      }
    }
  }
}

// 75. Querying by field existence
// - `exists` 
// SQL equivalent:
// SELECT * FROM products WHERE tags IS NOT NULL
GET /products/_search
{
  "query": {
    "exists": {
      "field": "tags.keyword"
    }
  }
}


// SQL equivalent:
// SELECT * FROM products WHERE tags IS NULL
GET /products/_search
{
  "query": {
    "bool": {
      "must_not": [
        {
          "exists": {
            "field": "tags.keyword"
          }
        }
      ]
    }
  }
}



// 77. The match query
// - the `match` query is been anazyed then scearched.
// - if the field `name` is been a custom anazyed the `match` query will be anazyed with the same 
GET /products/_search
{
  "query": {
    "match": {
      "name": "PASTA"
    }
  }
}

// - The `match` query will look be analyser as following:
// - ['pasta', 'chicken']
// - The default operater will be 'OR' so, it will look up for either pasta, chicken, or both.
GET /products/_search
{
  "query": {
    "match": {
      "name": "PASTA CHICKEN"
    }
  }
}


// - To change the default operator, from `'OR'` to `'AND'` we need to specifiy the operator
GET /products/_search
{
  "query": {
    "match": {
      "name": {
        "query": "PASTA CHICKEN",
        "operator": "and"
      }
    }
  }
}


// 82. Querying with boolean logic

// SQL Equivalent
/**
 SELECT *
  FROM products
  WHERE tags IN ("Alcohol") AND NOT IN ("Wine")
  
  // without the `should`
*/
GET /products/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "term": {
            "tags.keyword": {
              "value": "Alcohol"
            }
          }
        }
      ],
      "must_not": [
        {
          "term": {
            "tags.keyword": {
              "value": "Wine"
            }
          }
        }
      ],
      // - `should`: it gives a relevent boost to the score so it priorities which one is first in the list
      "should": [
        {
          "term": {
            "tags.keyword": {
              "value": "Beer"
            }
          }
        },
        {
          "match": {
            "name": "beer"
          }
        },
        {
          "match": {
            "description": "beer"
          }
        }
      ]
    }
  }
}


// SQL Equivalent
// SELECT * FROM Product WHERE (tags IN ("Beer") OR LIKE '%Beer%') AND in_stock <= 100
GET /products/_search
{
  "query": {
    "bool": {
      // `filter` occurrence type is the same as `must` occurrence type, but it does not affect the relevance scoring.
      // doing `filter` the query will be a candidate for caching.
      "filter": [
        {
          "range": {
            "in_stock": {
              "lte": 100
            }
          }
        }
        ],
        "should": [
          {
            "term": {
              "tags.keyword": {
                "value": "Beer"
              }
            }
          },
          {
            "match": {
              "name": {
                "query": "beer"
              }
            }
          }
          ],
          "minimum_should_match": 1
    }
  }
}

// SQL Equivalent
// SELECT * FROM Product WHERE tags IN ("Beer") AND (name LIKE '%Beer%' OR description LIKE '%Beer%') AND in_stock <= 100
GET /products/_search
{
  "query": {
    "bool": {
      "filter": [
        {
          "range": {
            "in_stock": {
              "lte": 100
            }
          }
        },
        {
          "term": {
            "tags.keyword": {
              "value": "Beer"
            }
          }
        }
        ],
        /**
        "should": [
          {
            "match": {
              "name": {
                "query": "beer"
              }
            }
          },
          {
            "match": {
              "description": {
                "query": "beer"
              }
            }
          }
          ],
          "minimum_should_match": 1
          */
          "must": [
            {
              // the `multi_match` query is the same as `should` query with `minimum_should_match` eneabled
              "multi_match": {
                "query": "beer",
                // with `multi_match` either "name", "description", OR Both must match.
                "fields": ["name", "description"]
              }
            }
            ]
    }
  }
}




// 84. Boosting query

// normal query without any boosting.
GET /products/_search
{
  // `size`: increase the default number of returns, the default is `10`
  "size": 20,
  "query": {
    "match": {
      "name": "juice"
    }
  }
}


// - this is the boosting query.
/**
 - Give Me all products that has the name `juice`.
 - while make sure apple juice is at the buttom of the list as I don't like them.
*/
GET /products/_search
{
  "size": 20,
  "query": {
    "boosting": {
      // - search me every product that its' `name` field contains the word `juice`. 
      "positive": {
        "match": {
          "name": "juice"
        }
      },
      // - from the result of the positive `match` query, everything that its name contains the name `apple` in it, lower its priority by `negative_boost` number.
      "negative": {
        "match": {
          "name": "apple"
        }
      },
      // - the `negative_boost` is set to `0.5` meaning the piriorty of `apple` is half of the others.
      // - the match equation is: `_score` * `negative_boost`
      "negative_boost": 0.5
    }
  }
}


/**
- I am a person Who does not like apples at all.
- any food that contains apples I don't prefer it.
- Give me all the products while make sure any apple product to be at the buttom of the list.
*/
GET /products/_search
{
  "size": 1000,
  "query": {
    "boosting": {
      // - Give me all the products. 
      "positive": {
        "match_all": {}
      },
      // - from the result of the positive `match` query, everything that its name contains the name `apple` in it, lower its priority by `negative_boost` number.
      "negative": {
        "match": {
          "name": "apple"
        }
      },
      // - the `negative_boost` is set to `0.5` meaning the piriorty of `apple` is half of the others.
      // - the match equation is: `_score` * `negative_boost`
      "negative_boost": 0.5
    }
  }
}


/**
- I am a person who likes Vegetables in every food I have.
- But I do not prefer Meat at all, I rarely have meat in my food.
- Give me all the products with a preference of `Vegetable` tag and Disfavoring the products with `Meat` tag.
*/
GET /products/_search
{
  "size": 1000,
  "query": {
    "boosting": {
      "positive": {
        // - The boosting query’s positive and negative parameters only allow us to specify a single query clause each.
        // - So adding multiple ones within an array is not an option.
        // - So what we need to do is to wrap the queries within a compound query. The bool query to the rescue!.
        "bool": {
          "must": [
            {
              "match_all": {}
            }
            ],
            "should": [
              {
                "term": {
                  "tags.keyword": {
                    "value": "Vegetable"
                  }
                }
              }
              ]
        }
      },
      "negative": {
        "term": {
          "tags.keyword": {
            "value": "Meat"
          }
        }
      },
      "negative_boost": 0.5
    }
  }
}

// 85. Disjunction max (dis_max)
GET /products/_search
{
  "query": {
    "dis_max": {
      "tie_breaker": 0.3,
      "queries": [
        {
          "match": {
            "name": "vegetable"
          }
        },
        {
          "match": {
            "tags": "vegetable"
          }
        }
      ]
    }
  }
}
// - it's the same as muti_match query
GET /products/_search
{
  "query": {
    "multi_match": {
      "query": "vegetable",
      "fields": ["name", "tags"],
      "tie_breaker": 0.3
    }
  }
}


// 86. Querying nested objects.


/**
  Question: write a query that return the following:
  Give me all the recipes that their ingredients has at least one with `parmesan`.
  While the amount of that `parmesan` ingredient is more than or equal to 100
*/
// - this query will not give you the expected outcomes, as it was mapped by the default dynamic mapping.
// - the default mapping of an object, is `arrays of objects`.
// - when indexing `arrays-of-objects`, the relationships between values are not maintained.
// - The solution is:
//   - Use the `nested` data type and the `nested` query.
//   - Create a new index to update the field mapping & reindex documents.
GET /recipes/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "ingredients.name": {
              "query": "parmesan"
            }
          }
        },
        {
          "range": {
            "ingredients.amount": {
              "gte": 100
            }
          }
        }
      ]
    }
  }
}

GET /recipes/_mapping



DELETE /recipes




PUT /recipes
{
  "mappings": {
    "properties": {
      "title": {
        "type": "text"
      },
      "description": {
        "type": "text"
      },
      "preparation_time_minutes": {
        "type": "integer"
      },
      "steps": {
        "type": "text"
      },
      "created": {
        "type": "date"
      },
      "ratings": {
        "type": "float"
      },
      "servings": {
        "properties": {
          "min": {
            "type": "integer"
          },
          "max": {
            "type": "integer"
          }
        }
      },
      "ingredients": {
        // - it will be stored as a hidden lucine document
        "type": "nested",
        "properties": {
          "name": {
            "type": "text",
            "fields": {
              "keyword": {
                "type": "keyword"
              }
            }
          },
          "amount": {
            "type": "integer"
          },
          "unit": {
            "type": "keyword"
          }
        }
      }
    }
  }
}


// - `recipes-bulk.json`, indexing the same recipes bulk again.
POST /recipes/_bulk
{
  
}


GET /recipes/_search
{
  "query": {
    "nested": {
      "path": "ingredients",
      "inner_hits": {},
      "query": {
        "bool": {
          "must": [
            {
              "match": {
                "ingredients.name": {
                  "query": "parmesan"
                }
              }
            },
            {
              "range": {
                "ingredients.amount": {
                  "gte": 100
                }
              }
            }
          ]
        }
      }
    }
  }
}

// 87. Nested inner hits

