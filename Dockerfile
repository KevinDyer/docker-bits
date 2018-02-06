FROM ubuntu:xenial
EXPOSE 80 443

RUN apt-get update && apt-get install -y \
    curl \
    && \
  curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && apt-get install -y \
    build-essential \
    nodejs \
    yarn \
    git \
    && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /opt/bits
RUN echo '{"allow-root": true}' | tee /root/.bowerrc && \
  git clone https://github.com/LGSInnovations/build-tools /usr/local/src/build-tools && \
  git clone --depth 1 -b 2.17.0 -- https://github.com/LGSInnovations/bits /usr/local/src/bits && \
  /usr/local/src/build-tools/package-module.py --module-dir /usr/local/src/bits --version 2.17.0 && \
  tar xf bits-base-2.17.0-3e65abc.tgz && \
  npm run bits:install && \
  mkdir -p /var/bits/base/nodelogs && \
  rm bits-base-2.17.0-3e65abc.tgz && \
  rm -rf /usr/local/src/build-tools && \
  rm -rf /usr/local/src/bits

ENTRYPOINT [ "node", "app.js", "-v", "-d", "/var/bits", "-o", "/var/bits/base/nodelogs" ]
