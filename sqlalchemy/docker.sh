# Get build the docker container
docker build -t sqlalchemy-zip .

# run the container with the given name sqlalchemy-zip
docker run --name sqlalchemy-zip --entrypoint "/bin/sh" -d -it sqlalchemy-zip

# Get the docker container ID
docker ps -aqf "name=sqlalchemy-zip"

# Copy the zip package out to local
docker cp $(docker ps -aqf "name=sqlalchemy-zip"):/app/package/sqlalchemy-py3.11-layer.zip .

docker rm --force sqlalchemy-zip
