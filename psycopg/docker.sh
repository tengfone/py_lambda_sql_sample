# Get build the docker container
docker build -t psycopg-zip .

# run the container with the given name psycopg-zip
docker run --name psycopg-zip --entrypoint "/bin/sh" -d -it psycopg-zip

# Get the docker container ID
docker ps -aqf "name=psycopg-zip"

# Copy the zip package out to local
docker cp $(docker ps -aqf "name=psycopg-zip"):/app/package/psycopg-py3.11-layer.zip .

docker rm --force psycopg-zip
