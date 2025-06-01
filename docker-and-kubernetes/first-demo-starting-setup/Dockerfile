FROM node:14

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

EXPOSE 3000

CMD ["node", "app.mjs"]

# docker build .
# docker run -p 3000:3000 sha256:3e7013aac4d9b982af980a5db3ebe9df2b0367b5446eae42577ce11112b75417