FROM debian:jessie
MAINTAINER Jan Suchotzki <jan@suchotzki.de>

# first create user and group for all the X Window stuff
# required to do this first so we have consistent uid/gid between server and client container
RUN addgroup --system xusers \
  && adduser \
			--home /home/xclient \
			--disabled-password \
			--shell /bin/bash \
			--gecos "user for running an xclient application" \
			--ingroup xusers \
			--quiet \
			xclient

# Install packages required for connecting against X Server
RUN apt-get update && apt-get install -y --no-install-recommends \
				xauth \
		&& rm -rf /var/lib/apt/lists/*

# Before switching user, root needs to ensure that entrypoint can be executed.
COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# During startup we need to prepare connection to X11-Server container
USER xclient
ENTRYPOINT ["/entrypoint.sh"]
