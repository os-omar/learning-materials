FROM node

WORKDIR /app

# the right side is the src repo code, the left side is the container code
COPY package.json .

# executed during building the image  
RUN npm install

COPY . .

# document which expose port (optional) but recommended
EXPOSE 80

# executed when the container is started
CMD [ "node", "server.js" ]


# docker build . "-to create the image"
# docker run -p 3000:80 <image_id> "-to run the container and publish the port"
# docker --help "-to see all commands"
# docker run "- create a new container"
# docker start "- to start a stopped container"
# docker ps "- to see all running containers"
# docker ps -a "- to see all containers"
# docker stop <container_id> "- to stop a running container"
# docker run -d <image_id> "- to run a container in detached mode"
# docker run -p 3000:80 <image_id> "- to publish the port"
# docker attach <container_id> "- to attach to a running container"
# docker logs <container_id> "- to see the logs of a running container"
# docker logs -f <container_id> "- to follow the logs of a running container"
# docker start -a <container_id> "- to start a stopped container and attach to it"
# docker rm <container_id> "- to remove a stopped container"
# docker run -p 3000:80 -d --rm <image_id> " for `--rm` to remove the container when it is stopped"`
# docker run --name <container_name> -p 3000:80 -d <image_id> "- to give a name to the container"

# docker image "- to see all images"
# docker rmi <image_id> "- to remove an image" which is not used by any container even if it is stopped
# docker image prune "- to remove all unused images"
# docker image inspect <image_id> "- to see the details of an image"
# docker build -t <image_name> . "- to build an image with a name"
# docker build -t <image_name>:<tag> . "- to build an image with a name and a tag"
# docker pull <image_name>:<tag> "- to pull an image from the docker hub"