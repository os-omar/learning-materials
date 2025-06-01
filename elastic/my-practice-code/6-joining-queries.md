// 90. Add departments test data.

// adding new index `department` with custom mapping.
PUT /department
{
  "mappings": {
    "properties": {
      "name": {
        "type": "text",
        "fields": {
          "keyword": {
            "type": "keyword"
          }
        }
      },
      "employees": {
        "type": "nested"
      }
    }
  }
}

// posting the first document for index `department`
PUT /department/_doc/1
{
  "name": "Development",
  "employees": [
    {
      "name": "Eric Green",
      "age": 39,
      "gender": "M",
      "position": "Big Data Specialist"
    },
    {
      "name": "James Taylor",
      "age": 27,
      "gender": "M",
      "position": "Software Developer"
    },
    {
      "name": "Gary Jenkins",
      "age": 21,
      "gender": "M",
      "position": "Intern"
    },
    {
      "name": "Julie Powell",
      "age": 26,
      "gender": "F",
      "position": "Intern"
    },
    {
      "name": "Benjamin Smith",
      "age": 46,
      "gender": "M",
      "position": "Senior Software Engineer"
    }
  ]
}

// posting the second document for index `department`
PUT /department/_doc/2
{
  "name": "HR & Marketing",
  "employees": [
    {
      "name": "Patricia Lewis",
      "age": 42,
      "gender": "F",
      "position": "Senior Marketing Manager"
    },
    {
      "name": "Maria Anderson",
      "age": 56,
      "gender": "F",
      "position": "Head of HR"
    },
    {
      "name": "Margaret Harris",
      "age": 19,
      "gender": "F",
      "position": "Intern"
    },
    {
      "name": "Ryan Nelson",
      "age": 31,
      "gender": "M",
      "position": "Marketing Manager"
    },
    {
      "name": "Kathy Williams",
      "age": 49,
      "gender": "F",
      "position": "Senior Marketing Manager"
    },
    {
      "name": "Jacqueline Hill",
      "age": 28,
      "gender": "F",
      "position": "Junior Marketing Manager"
    },
    {
      "name": "Donald Morris",
      "age": 39,
      "gender": "M",
      "position": "SEO Specialist"
    },
    {
      "name": "Evelyn Henderson",
      "age": 24,
      "gender": "F",
      "position": "Intern"
    },
    {
      "name": "Earl Moore",
      "age": 21,
      "gender": "M",
      "position": "Junior SEO Specialist"
    },
    {
      "name": "Phillip Sanchez",
      "age": 35,
      "gender": "M",
      "position": "SEM Specialist"
    }
  ]
}


// 91. mapping document relationships
PUT /department/_mapping
{
  "properties": {
    "join_field": {
      "type": "join",
      "relations": {
        // addded relationship between indecies where
        // - `department` is the parent of `employee`
        // - we can define multiple child to `department`
        // - like this: `"department": ["employee", "another-index"]`
        "department": "employee"
      }
    }
  }
}


GET /department/_mapping

// 92. Adding documents

PUT /department/_doc/1
{
  "name": "Development",
  "join_field": "department"
  
}

PUT /department/_doc/2
{
  "name": "Marketing",
  "join_field": {
    "name": "department"
  }
}

PUT /department/_doc/3?routing=1
{
  "name": "Bo Andersen",
  "age": 28,
  "gender": "M",
  "join_field": {
    "name": "employee",
    "parent": 1
  }
}



PUT /department/_doc/4?routing=2
{
  "name": "John Doe",
  "age": 44,
  "gender": "M",
  "join_field": {
    "name": "employee",
    "parent": 2
  }
}

PUT /department/_doc/5?routing=1
{
  "name": "James Evans",
  "age": 32,
  "gender": "M",
  "join_field": {
    "name": "employee",
    "parent": 1
  }
}

PUT /department/_doc/6?routing=1
{
  "name": "Daniel Harris",
  "age": 52,
  "gender": "M",
  "join_field": {
    "name": "employee",
    "parent": 1
  }
}

PUT /department/_doc/7?routing=2
{
  "name": "Jane Park",
  "age": 23,
  "gender": "F",
  "join_field": {
    "name": "employee",
    "parent": 2
  }
}

PUT /department/_doc/8?routing=1
{
  "name": "Christina Parker",
  "age": 29,
  "gender": "F",
  "join_field": {
    "name": "employee",
    "parent": 1
  }
}

// 93. Querying by parent ID

// Give me All employees that belong to the department `id=1`
GET /department/_search
{
  "query": {
    "parent_id": {
      "type": "employee",
      "id": 1
    }
  }
}


// 94. Querying child documents by parent
// Give me all employees that their deplartment name === 'Development'
GET /department/_search
{
  "query": {
    "has_parent": {
      "parent_type": "department",
      // - Considering score it will calculate relevent scoring and prioritise reults accordingly.
      // - this is not a great example as we are useing `term` query which does not consider the relevent score but you get the point.
      "score": true,
      "query": {
        "term": {
          "name.keyword": {
            "value": "Development"
          }
        }
      }
    }
  }
}

// 95. Querying parent by child documents
// Give me all the departments that has employees equal or over the age 50 years and prioritise the list of a Male Gender.
GET /department/_search
{
  "query": {
    "has_child": {
      "type": "employee",
      "score_mode": "sum",
      "min_children": 1,
      "max_children": 10, 
      "query": {
        "bool": {
          "must": [
            {
              "range": {
                "age": {
                  "gte": 50
                }
              }
            }
          ],
          "should": [
            {
              "term": {
                "gender.keyword": {
                  "value": "M"
                }
              }
            }
          ]
        }
      }
    }
  }
}

// 96. Multi-level relations







