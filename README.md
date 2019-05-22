# translation_docker_image

## Build the image

1. `$ git clone --recurse-submodules https://github.com/guallo/translation_docker_image.git`
2. `$ cd translation_docker_image`
3. `translation_docker_image$ sudo docker build -t <image-name>[:<tag>] .` (note the `.` at end)

## Create and start the container

1. `sudo docker run -it -p 8081:8081 <image-name>[:<tag>]`
