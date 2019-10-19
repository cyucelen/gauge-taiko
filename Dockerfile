FROM node:10-alpine

# Install Chromium
RUN apk update && apk upgrade && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories && \
    apk add --no-cache \
      git \
      tini \
      chromium@edge \
      nss@edge \
      freetype@edge \
      harfbuzz@edge \
      ttf-freefont@edge \
      libstdc++@edge

# Install NotoSansCJK
RUN mkdir /noto && \
    cd /noto && \
    wget https://noto-website.storage.googleapis.com/pkgs/NotoSansCJKjp-hinted.zip && \
    unzip NotoSansCJKjp-hinted.zip && \
    mkdir -p /usr/share/fonts/noto && \
    cp *.otf /usr/share/fonts/noto && \
    chmod 755 /usr/share/fonts/noto && \
    chmod 644 /usr/share/fonts/noto/* && \
    fc-cache -fv && \
    cd / && \
    rm -rf /noto

# Install taiko
ENV NPM_CONFIG_PREFIX /home/node/.npm-global
ENV PATH $PATH:/home/node/.npm-global/bin

ENV TAIKO_SKIP_CHROMIUM_DOWNLOAD true
ENV TAIKO_BROWSER_PATH /usr/bin/chromium-browser

RUN npm install @getgauge/cli -g --allow-root --unsafe-perm=true && gauge install js && \
    gauge install html-report && \
    gauge install screenshot
RUN npm install taiko -g --allow-root --unsafe-perm=true

# Copy scripts
WORKDIR /taiko