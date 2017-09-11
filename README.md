# dfvim
Docker-based containerized F# development environment with vim

Dockerfile is based on the F# 4.1.25 version of the official mono F# Dockerfile: https://github.com/fsprojects/docker-fsharp/tree/96cd7752113e7b4e32fbd6437600816f4b361994/4.1.25/mono with two main differences:

- based on debian jessie image instead of jessie-slim (to preserver man-pages useful for development)
- installs vim and some other useful utilities for development

Build the image using `./build.sh`

Execute `./run.sh` to start the container with the current directory mounted.
