# Use an official Python image as the base
FROM python:3.11

# Set the working directory
WORKDIR /app

# Install the required tools and skip recommended packages
RUN apt-get update && apt-get install -y --no-install-recommends zip curl

# SPECIAL FOR PSYCOPG Install the bin for psycopg (https://www.reddit.com/r/aws/comments/1757d1m/comment/k7j1u0g/) (https://pypi.org/project/psycopg2-binary/#files)
RUN pip install --platform manylinux2014_x86_64 --only-binary=:all: --target ./python psycopg2-binary==2.9.9

# Remove tests and cache stuff (to reduce size)
RUN find ./python -type d -name "tests" -exec rm -rfv {} +
RUN find ./python -type d -name "__pycache__" -exec rm -rfv {} +

# Create a directory for the zipped package
RUN mkdir /app/package

# Zip the library
RUN zip -r9 /app/package/psycopg-py3.11-layer.zip . -i /python/*

# Run as nonrootuser
RUN useradd -u 1001 nonrootuser
USER nonrootuser
