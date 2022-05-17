FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt -y install software-properties-common build-essential \
    && apt -y install python3 python3-oauth2client python3-pymysql git python3-pip apache2 libapache2-mod-wsgi-py3
    # && add-apt-repository -y cloud-archive:wallaby \
    # && apt update && apt -y upgrade \
    # && apt -y install python3 python3-openstackclient python3-oauth2client python3-pymysql git python3-pip

RUN ln -fs /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

CMD ["bash"]