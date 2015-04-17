##About
Base Image which can be used to create an image containing an application requiring an X Window Server. When used in conjunction with [suchja/x11server](https://registry.hub.docker.com/u/suchja/x11server/) the graphical output can be seen via VNC on any computer accessing the containers.

In contrast to several existing solution the focus here is on a strict separation of concerns. This keeps the images small and focused on exactly one task. Therefore there is no X Window client application installed in this image.

More details can be found [here](https://github.com/suchja/x11server/blob/master/Story.md).

##Usage
Use this image in your Dockerfile's `FROM` statement, if you like to create an image running an xclient application like Wine or Firefox.

Even though this image is intended as base image, you can run a container from it. Assuming you already started an x11server container like so:

`docker run -d --name display -e VNC_PASSWORD=newPW -p 5900:5900 suchja/x11server`

You can start a x11client container like so:

`docker run --rm -it --link display:xserver --volumes-from display suchja/x11client /bin/bash`

This however does not make too much sense, because this image does not contain any X11 application. Have a look at [suchja/wine](https://registry.hub.docker.com/u/suchja/wine/) to see how to utilise this x11client image as base image.

**ATTENTION:** It's important that the `entrypoint.sh` script is executed. So if you like to supply your own `ENTRYPOINT` in an image derived from this, ensure that the `/entrypoint.sh` is executed first thing during container startup. Otherwise an X11 application is not able to find and connect the X11 server running in a separate container from [suchja/x11server](https://registry.hub.docker.com/u/suchja/x11server/).

**ATTENTION #2:** When linking a container based on this image to [suchja/x11server](https://registry.hub.docker.com/u/suchja/x11server/) the `alias` must be set to **xserver**. If another alias is used, authentication between x11client and x11server will not work. Thus it is not possible for the client to connect to the server!

##Maintenance
The image is build on Docker hub with [Automated builds](http://docs.docker.com/docker-hub/builds/). There is no dedicated maintenance schedule for this image. It is relying on packages from `debian:jessie` and thus I do not assume to update it frequently.

In case you have any issues, you are invited to create a pull request or an issue on the related [github repository](https://github.com/suchja/x11client).

##Copyright free
The sources in [this](https://github.com/suchja/x11-client.git) Github repository, from which the docker image is build, are copyright free (see LICENSE.md). Thus you are allowed to use these sources (e.g. Dockerfile and README.md) in which ever way you like.
