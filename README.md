# translation_docker_image

## Build the image

1. `$ git clone --recurse-submodules https://github.com/guallo/translation_docker_image.git`
2. `$ cd translation_docker_image`
3. `translation_docker_image$ docker build -t <image-name>[:<tag>] .` (note the `.` at end)

## Create and start the container

1. `$ docker run -it --rm -p 8081:8081 -p 8091:8091 -p 8095:8095 --name <container-name> <image-name>[:<tag>]`

Port 8081 is for Translation Service.  
Port 8091 is for Translation Hub - From English to Spanish.  
Port 8095 is for Translation Hub - From Spanish to English.  

## Stop the container

1. `$ docker stop <container-name>`
