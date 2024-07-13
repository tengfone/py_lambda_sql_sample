# Use an official Python image as the base
FROM python:3.11

# Set the working directory
WORKDIR /app

# Install the required tools and skip recommended packages
RUN apt-get update && apt-get install -y --no-install-recommends zip curl

# Install the library
RUN pip install --no-cache-dir prisma -t ./python

# Remove all directories starting with 'pydantic' in prisma
RUN find ./python -type d -name 'pydantic*' -exec rm -rf {} +

# Install Pydantic thats compatible with AWS Lambda; change PY version accordingly
RUN pip install --platform manylinux2014_x86_64 --implementation cp --python-version 3.11 --only-binary=:all: --target ./python pydantic

# Remove tests and cache stuff (to reduce size)
RUN find ./python -type d -name "tests" -exec rm -rfv {} +
RUN find ./python -type d -name "__pycache__" -exec rm -rfv {} +

# Create a directory for the zipped package
RUN mkdir /app/package

# Zip the library
RUN zip -r9 /app/package/prisma-py3.11-layer.zip . -i /python/*

# Run as nonrootuser
RUN useradd -u 1001 nonrootuser
USER nonrootuser
