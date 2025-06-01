FROM node:14




WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

# args used only during build time of the image.
ARG DEFAULT_PORT=80

# available during build time image and run time container 
# 80 is the default port for http but you can change it to any port using command line when running the container
ENV PORT $DEFAULT_PORT 

EXPOSE $PORT

# anonymous volumes are created when the container is created
# VOLUME [ "/app/node_modules" ]
# VOLUME [ "/app/temp" ]

CMD [ "node", "server.js" ]

# docker build -t feedback-node:volumes .
# docker build -t feedback-node:dev --build-arg DEFAULT_PORT=8000 .
# docker run -p 3000:80 nodejs-app
# docker run -p 3000:80 -d --rm nodejs-app
# docker run -p 3000:80 -d --rm --name nodejs-app nodejs-app
# docker run -p 3000:80 -d --rm --name feedback-app -v feedback:/app/feedback feedback-node:volumes
# docker run -p 3000:80 -d --rm --name feedback-app -v feedback:/app/feedback -v /app/node_modules feedback-node:volumes
# docker run -p 3000:80 -d --rm --name feedback-app -v feedback:/app/feedback -v /app/node_modules -v /app/temp -v "/Users/orhman/os-personal/docker/data-volumes-01-starting-setup:/app:ro" feedback-node:volumes
# docker run -p 3000:8000 --env PORT=8000 -d --rm --name feedback-app -v feedback:/app/feedback -v /app/node_modules -v /app/temp -v "/Users/orhman/os-personal/docker/data-volumes-01-starting-setup:/app:ro" feedback-node:env
# docker run -p 3000:8000 --env-file ./.env -d --rm --name feedback-app -v feedback:/app/feedback -v /app/node_modules -v /app/temp -v "/Users/orhman/os-personal/docker/data-volumes-01-starting-setup:/app:ro" feedback-node:env
# named volume:  -v feedback:/app/feedback
# anonymous volumes: -v /app/node_modules, & -v /app/temp
# bind mount (read-only): -v "/Users/orhman/os-personal/docker/data-volumes-01-starting-setup:app:ro"

# docker volume ls "- to see all volumes (ONLY managed by docker)" both named and anonymous
# docker volume rm feedback "- to remove a named volume"



