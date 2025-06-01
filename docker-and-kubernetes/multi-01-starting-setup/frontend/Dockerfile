FROM node:14

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

EXPOSE 3000

CMD [ "npm", "start" ]

# docker build -t goals-react .

# docker run --name goals-frontend -p 3000:3000 --rm -d goals-react

# docker run --name goals-frontend -p 3000:3000 --rm -d goals-react

# docker run --name goals-frontend -p 3000:3000 --rm -d --network goals-net goals-react
# - we should not make it in the same network as the backend. as the backend is published.



# docker run --rm -d --name goals-frontend -p 3000:3000 -v $(pwd)/src:/app/src -v /app/node_modules goals-react