FROM node 16.14.0
MAINTAINER André Luiz Clinio <clinio@tecgraf.puc-rio.br>

RUN apt-get update -y
RUN apt-get install -y wget
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt-get install ./google-chrome-stable_current_amd64.deb

