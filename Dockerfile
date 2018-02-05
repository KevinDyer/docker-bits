FROM ubuntu:xenial
EXPOSE 80 443

RUN apt-get update && apt-get install -y \
    curl \
    && \
  curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && apt-get install -y \
    nodejs \
    build-essential \
    yarn \
    && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /opt/bits