FROM hungnt612/ubuntu-focal:TZ-HCM

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt -y install software-properties-common \
    && add-apt-repository -y cloud-archive:wallaby \
    && apt update && apt -y upgrade \
    && apt -y install python3-openstackclient apache2 libapache2-mod-wsgi-py3 python3-oauth2client python3-pymysql git python3-pip placement-api libpq-dev

COPY placement /placement
RUN pip3 install -r placement/requirements.txt && pip3 install -r placement/test-requirements.txt


RUN mv /etc/placement/placement.conf /etc/placement/placement.conf.org
COPY placement.conf /etc/placement/placement.conf

COPY init.sh /usr/bin/init.sh
RUN chmod +x /usr/bin/init.sh
EXPOSE 8778

CMD ["/usr/bin/init.sh"]

