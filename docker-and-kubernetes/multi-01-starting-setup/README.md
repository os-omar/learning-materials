## For mongodb docker

```bash
docker run --name mongodb --rm -d -p 27017:27017 mongo
```

- be careful when exposing a port of a DB ideally it should be in a internal network managed by docker.

```bash
docker run --name mongodb --rm -d --network goals-net mongo
```

```bash
docker run --name mongodb --rm -d --network goals-net -v data:/data/db mongo
```

```bash
docker run --name mongodb --rm -d --network goals-net -v data:/data/db -e MONGO_INITDB_ROOT_USERNAME=omar -e  MONGO_INITDB_ROOT_PASSWORD=secret mongo
```

- you need to remove the existing volume if it's been created before the security root user credentials.

## For docker network

```bash
docker network ls

docker network create goals-net
```
