# Get build the docker container
docker build -t prisma-zip .

# run the container with the given name prisma-zip
docker run --name prisma-zip --entrypoint "/bin/sh" -d -it prisma-zip

# Get the docker container ID
docker ps -aqf "name=prisma-zip"

# Copy the zip package out to local
docker cp $(docker ps -aqf "name=prisma-zip"):/app/package/prisma-py3.11-layer.zip .

docker rm --force prisma-zip
