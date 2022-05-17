############################################################
# Dockerfile to run Memcached Containers
# Based on Ubuntu Image
############################################################

# Set the base image to use to Ubuntu
FROM hungnt612/ubuntu-focal:TZ-HCM

# Update the default application repository sources list
RUN apt-get update

# Install Memcached
RUN apt-get install -y memcached

RUN rm -rf /etc/memcached.conf
COPY memcached.conf /etc/memcached.conf
# Port to expose (default: 11211)
EXPOSE 11211

# Default Memcached run command arguments
CMD ["-m", "128"]

# Set the user to run Memcached daemon
USER daemon

# Set the entrypoint to memcached binary
ENTRYPOINT memcached