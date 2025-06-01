FROM node

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

EXPOSE 80

ENV MONGODB_USERNAME=root
ENV MONGODB_PASSWORD=secret

CMD [ "npm", "start" ]

# docker build -t goals-node .

# docker run --name goals-backend --rm goals-node 
# - when we do not publish the port, the frontend cannot reach the backend.

# docker run --name goals-backend -p 80:80 --rm -d goals-node

# docker run --name goals-backend --network goals-net --rm -d goals-node

# docker run --name goals-backend -p 80:80 --network goals-net --rm -d goals-node
# - we must publish the port as the frontend is SPA which is run inside the browser.

# docker run --rm -d --name goals-backend -p 80:80 --network goals-net -v $(pwd):/app -v logs:/app/logs -v /app/node_modules goals-node
# $(pwd) means: the current directory which will be: `/Users/orhman/os-personal/docker/multi-01-starting-setup/backend`

# docker run --rm -d --name goals-backend -p 80:80 --network goals-net -v $(pwd):/app -v logs:/app/logs -v /app/node_modules -e MONGODB_USERNAME=omar goals-node