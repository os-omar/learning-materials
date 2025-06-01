- `_custer`: is the api.
- `health`: is the command.

```typescript
GET /_cluster/health/
```

- get information about the nodes.
- `_cat`: is the api that display info in readable form
- `nodes`: is the command which tells you how many nodes we have within our cluster.

```typescript
GET /\_cat/nodes?v
```

// `_cat`: is the api that display info in readable form
// `indices`: is the command which tells you how many indices we have within our cluster.
GET /\_cat/indices?v

// shows you all indicies including the system incides.
GET /\_cat/indices?v&expand_wildcards=all

// display the shards we have.
GET /\_cat/shards?v

// Create a new Index called `pages` with the default settings.
// for production use, it's recomemended to stick with the default settings. unless there is a neeed ofr it.
PUT /pages

// Delete an Index called `pages`
DELETE /pages
