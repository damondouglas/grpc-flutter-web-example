FROM debian:stretch

RUN apt-get update -y
RUN apt-get upgrade -y

RUN apt-get install -y --no-install-recommends \
  curl \
  git \
  unzip \
  wget \
  xz-utils \
  apt-transport-https \
  ca-certificates \
  gnupg

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -

RUN wget https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_v1.12.13+hotfix.5-stable.tar.xz

RUN tar xf flutter_linux_v1.12.13+hotfix.5-stable.tar.xz

RUN flutter/bin/flutter channel beta
RUN flutter/bin/flutter upgrade
RUN flutter/bin/flutter config --enable-web

