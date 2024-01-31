FROM node:20.11.0
LABEL MAINTAINER="André Luiz Clinio <clinio@tecgraf.puc-rio.br>"

RUN apt-get update -y
RUN apt-get install -y wget
RUN apt-get install -y git
RUN apt-get install -y curl
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt-get install -y ./google-chrome-stable_current_amd64.deb

