##About
Base Image which can be used to create an image containing an application requiring an X Window Server. When used in conjunction with `suchja/x11-services` the graphical output can be seen via VNC on any computer accessing the containers.

In contrast to several existing solution the focus here is on a strict separation of concerns. This keeps the images small and focused on exactly one task. Therefore there is no X Window client application installed in this image.

More details can be found [here](https://github.com/suchja/x11server/blob/master/Story.md).

##Usage
Use this image in your Dockerfile's `FROM` statement, if you like to create an image running an xclient application like Wine or Firefox.

###Environment Variables
When you run a container based on the `x11-client` image, you should adjust at least some of its configuration.

tbd.

##Maintenance
The image is build on Docker hub with [Automated builds](http://docs.docker.com/docker-hub/builds/). There is no dedicated maintenance schedule for this image. It is relying on packages from `debian:jessie` and thus I do not assume to update it frequently.

In case you have any issues, you are invited to create a pull request or an issue on the related [github repository](https://github.com/suchja/x11-client).

##Copyright free
The sources in [this](https://github.com/suchja/x11-client.git) Github repository, from which the docker image is build, are copyright free (see LICENSE.md). Thus you are allowed to use these sources (e.g. Dockerfile and README.md) in which ever way you like.
