FROM node:14-alpine

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

EXPOSE 80

CMD ["node", "app.js"]

# docker build -t node-dep-example .
# docker run -d --rm --name node-dep -p 80:80 node-dep-example
