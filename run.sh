docker kill dfvim
docker rm dfvim
# docker run --name dfvim -it -u `id -u`:`id -g` -v $(pwd):/src dfvim
docker run --name dfvim -it -v $(pwd):/src dfvim
