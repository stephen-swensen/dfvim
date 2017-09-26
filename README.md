# dfvim
Docker-based containerized F# development environment with vim

DockerHub: https://hub.docker.com/r/swensen/dfvim/

## Get started

Use `docker run -it -v $(pwd):/src swensen/dfvim:4.1.25` to mount the current directory inside a docker container optimized for F# vim development.

See https://github.com/stephen-swensen/fsharp-tutorials for a tutorial based around `dfvim`.

## About

Dockerfile is based on the F# 4.1.25 version of the official mono F# Dockerfile: https://github.com/fsprojects/docker-fsharp/tree/96cd7752113e7b4e32fbd6437600816f4b361994/4.1.25/mono with two main differences:

- based on debian jessie image instead of jessie-slim (to preserver man-pages useful for development)
- installs vim and some other useful utilities for development

Build the image using `./build.sh`

Execute `./run.sh` to start the container with the current directory mounted.

Notes

- Dockerfile creates a user `dfvim` with uid 1000 for use in the running container. If your host uid is 1000 also then file permissions will align (good!), if not then you may have mismatch permission issues (bad!).
- Installs various vim plugins using vim-plug, see .vimrc

TODO

- Use NeoVim instead of regular vim
- Use regular fsharp image based on jessie-slim but figure out how to get man pages installed
