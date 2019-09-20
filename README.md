mcsrvod - Minecraft Server on Demand
===

[![GitHub Release](https://img.shields.io/github/v/tag/timo-reymann/mcsrvod.svg?label=version)](https://github.com/timo-reymann/mcsrvod/releases)
![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/timoreymann/mcsrvod)

## What is this?
This is your ultimate docker container for running minecraft 1.7.10+ in any forms available, not wasting your resources.


## tl;dr

1. Check your desired server software is compatible with 1.7.10+
2. Install docker on your host: [(Ref)](https://docs.docker.com/install/)
3. Dont forget to accept the eula and configure everything, including the memory limit!
4. The port of your server software must listen on port 25565, this is the default.
5. Copy paste the sample docker-compose file


## How does it work?
Mount your server folder unter `/srv/mcsrvod/` and rename your jar file to `server.jar`.

The container will start the attached jar file when an connection to port 3000 is etablished. This is the public port for minecraft, you can change the outside mapping to whatever you like.


## Known limitations
- This docker image is only suitable for minecraft 1.7.10+
- The log is not directly visible in docker logs, it must be read from the according file, due to independence of the server software

## Configuration

### Timeout to shutdown server after idle
You can specify the interval in seconds the server should shutdown than no one is online. To do so specify the environment variable `KILL_INTERVAL`

### Customize start arguments
You can customize the jvm start arguments via an envrionment variable called `JAVA_OPTS`. Same goes for your server arguments, to specify them simply set the env for `SERVER_OPTS`


## Troubleshooting

### Server is not running after first launch
Please check if the eula.txt is created and its agreement is set, this must be done by yourself.

### Server is not responding on connection immediately
The server may need some time to completely start, till that you will see an long running poll. For normal installations this is normally not that long, depending on your machine power. For modpacks this may take some time.


## Ready-To-Use docker-compose File
````yaml
version: '2.4'
services:
  hobbyMinecraftServer:
    image: timoreymann/mcsrvod:latest
    restart: always
    ports:
     # map to default port
     - 25565:3000 
    environment:
    # Set some max memory args
     - JAVA_OPTS=-Xms256M -Xmx1128M -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap
     # we dont want a console in there
     - SERVER_OPTS=nogui --noconsole
     - KILL_INTERVAL=900
    volumes:
    # Mount the folder with the server.jar and stuff
     - ./minecraft:/srv/mcsrvod
     # we dont want to waste our servers resources ;)
    mem_limit: 1200M
````
