FROM node

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

CMD ["node", "app.js"]

# docker build -t favorites-node .
# docker run --name favorites -d --rm -p 3000:3000 favorites-node
# docker run --name favorites --rm -p 3000:3000 favorites-node
# docker run --name favorites --rm -p 3000:3000 --network favorites-net favorites-node

# start a new mongo container
# docker run --name mongodb -d mongo
# docker container inspect mongodb
# docker run --name mongodb -d --network favorites-net mongo "-need to create a network first it won't automatically create a network"
# docker network create favorites-net
# docker network ls