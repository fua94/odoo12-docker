#FROM debian:10.9-slim
FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update

RUN apt install -y git python3-pip build-essential wget python3-dev python3-venv \
    python3-wheel libfreetype6-dev libxml2-dev libzip-dev libldap2-dev libsasl2-dev \
    python3-setuptools node-less libjpeg-dev zlib1g-dev libpq-dev \
    libxslt1-dev libldap2-dev libtiff5-dev libjpeg8-dev libopenjp2-7-dev \
    liblcms2-dev libwebp-dev libharfbuzz-dev libfribidi-dev libxcb1-dev \
    postgresql-client \
    fontconfig libxrender1 xfonts-75dpi xfonts-base

RUN useradd -m -d /opt/odoo -U -r -s /bin/bash odoo

RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.bionic_amd64.deb
RUN apt install -yf --no-install-recommends ./wkhtmltox_0.12.6-1.bionic_amd64.deb
RUN rm -rf /var/lib/apt/lists/* ./wkhtmltox_0.12.6-1.bionic_amd64.deb
RUN apt clean

RUN su - odoo
RUN git clone https://www.github.com/odoo/odoo --depth 1 --branch 12.0 /opt/odoo/odoo12
RUN pip3 install wheel
RUN pip3 install numpy
RUN pip3 install -r /opt/odoo/odoo12/requirements.txt
RUN exit

EXPOSE 8069

CMD ["python3", "/opt/odoo/odoo12/odoo-bin", "-c", "/etc/odoo/odoo.conf"]
