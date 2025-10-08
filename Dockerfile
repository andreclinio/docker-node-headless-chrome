FROM node:22-slim
LABEL maintainer="André Luiz Clinio <clinio@tecgraf.puc-rio.br>"

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y wget git curl && \
	wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
	apt-get install -y ./google-chrome-stable_current_amd64.deb && \
	rm -f google-chrome-stable_current_amd64.deb && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

