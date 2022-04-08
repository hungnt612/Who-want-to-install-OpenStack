FROM docker.io/bitnami/mariadb:10.5
# remove old config
RUN rm /opt/bitnami/mariadb/conf/my.cnf
# add new config
COPY my.conf /opt/bitnami/mariadb/conf/
ENTRYPOINT ["bash"]