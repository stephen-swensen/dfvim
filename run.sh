docker kill dfvim
docker rm dfvim
docker run --name dfvim -it -v $(pwd):/src dfvim
