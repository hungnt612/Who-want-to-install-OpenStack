FROM hungnt612/ubuntu-focal:TZ-HCM

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt -y install software-properties-common \
    && apt -y install mariadb-server mariadb-client expect

# replace config mariadb
RUN rm /etc/mysql/mariadb.conf.d/50-server.cnf
COPY 50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY init.sh /usr/bin/init.sh
RUN chmod +x /usr/bin/init.sh
EXPOSE 3306

ENTRYPOINT ["/usr/bin/init.sh"]