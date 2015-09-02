## About
Have you got the need to run an X11 application inside a docker container? I did (for example [here](https://registry.hub.docker.com/u/suchja/wine/)). It was pretty annoying to have a dockerfile which setups X11 server, maps sockets and finally prepares the application I'm interested in. And what happens, if the machine running your container does not even have a display? Read more about the background [here](https://github.com/suchja/x11server/blob/master/Story.md).

This image in combination with [suchja/x11server](https://registry.hub.docker.com/u/suchja/x11server/) gives you the possibility to run a X11 application on any machine you like and get the display on the same or any other machine.

In contrast to several existing solution the focus here is on a strict separation of concerns. This keeps the images small and focused on exactly one task. Therefore there is no X Window client application installed in this image.

### Tags
This image is provided to you in different versions. You can pull those versions from docker hub by specifying the appropriate tag:

-	`suchja/x11client:latest` - Based on a `debian:jessie` image xauth package and configuration for a secure connetion to a container running the `suchja/x11server` is provided.  **Docker images size: around 140MB**
-	`suchja/x11client:ubuntu` - Based on a `ubuntu:14.04` image xauth package and configuration for a secure connetion to a container running the `suchja/x11server` is provided.  **Docker images size: around 190MB**

### Provided core packages
This image provides the following core packages in addition to the ones contained in the parent image(s):

-	`Xauth` - Required to use Magic-Mit-Cookie provided by X11 server for secure connection between X11 client and server. For details see [here](http://www.x.org/archive/X11R6.7.0/doc/xauth.1.html).

### Docker image structure
I'm a big fan of the *separation of concerns (SoC)* principle. Therefore I try to create Dockerfiles with mainly one responsibility. Thus it happens that an image is using a base image, which is using another base image, ... Here you see all the base images used for this image:

>[ubuntu:14.04](https://github.com/tianon/docker-brew-ubuntu-core/blob/7fef77c821d7f806373c04675358ac6179eaeaf3/trusty/Dockerfile) The base ubuntu 14.04 (aka Trusty) image from docker library, when using `suchja/x11client:ubuntu`
>[debian:jessie](https://github.com/tianon/docker-brew-debian/blob/188b27233cedf32048ee12378e8f8c6fc0fc0cb4/jessie/Dockerfile) The base debian jessie image from docker library, when using `suchja/x11client:latest`
>>[suchja/x11client](https://registry.hub.docker.com/u/suchja/x11client/dockerfile/) This image

## Usage
Use this image in your Dockerfile's `FROM` statement, if you like to create an image running an xclient application like Wine or Firefox.

Even though this image is intended as base image, you can run a container from it. Assuming you already started an x11server container like this:

`docker run -d --name display -e VNC_PASSWORD=newPW -p 5900:5900 suchja/x11server`

You can start a x11client container like this:

`docker run --rm -it --link display:xserver --volumes-from display suchja/x11client /bin/bash`

This however does not make too much sense, because this image does not contain any X11 application. Have a look at [suchja/wine](https://registry.hub.docker.com/u/suchja/wine/) to see how to utilise this x11client image as base image.

**ATTENTION:** It's important that the `entrypoint.sh` script is executed. So if you like to supply your own `ENTRYPOINT` in an image derived from this, ensure that the `/entrypoint.sh` is executed first thing during container startup. Otherwise an X11 application is not able to find and connect the X11 server running in a separate container from [suchja/x11server](https://registry.hub.docker.com/u/suchja/x11server/).

**ATTENTION #2:** When linking a container based on this image to [suchja/x11server](https://registry.hub.docker.com/u/suchja/x11server/) the `alias` must be set to **xserver**. If another alias is used, authentication between x11client and x11server will not work. Thus it is not possible for the client to connect to the server!

### Authentication with Magic Cookie on X11 server
This image uses [X Window Authority](http://en.wikipedia.org/wiki/X_Window_authorization) with MIT Magic Cookies. Therefore a container started from [suchja/x11server](https://registry.hub.docker.com/u/suchja/x11server/) will create such a cookie, provide it as file on a volume and authenticates clients with it.

When starting a container from this x11client image, the `/entrypoint.sh` script reads the magic cookie from the server volume and set's it as default cookie for the client user. That means only the xclient user is able to establish connections to the x11server out of the box.

If you use x11client as a base image and like to create and use another user than xclient, you should run the `/entrypoint.sh` script again as the newly created user.

## Maintenance
The image is build on Docker hub with [Automated builds](http://docs.docker.com/docker-hub/builds/). There is no dedicated maintenance schedule for this image. It is relying on packages from `debian:jessie` / `ubuntu:14.04` and thus I do not assume to update it frequently.

In case you have any issues, you are invited to create a pull request or an issue on the related [github repository](https://github.com/suchja/x11client).

## Copyright free
The sources in [this](https://github.com/suchja/x11client) Github repository, from which the docker image is build, are copyright free (see LICENSE.md). Thus you are allowed to use these sources (e.g. Dockerfile and README.md) in which ever way you like.
