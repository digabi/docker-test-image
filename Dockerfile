FROM --platform=linux/amd64 debian:12.9

RUN mkdir -p /home/digabi
RUN adduser --system --uid 1001 --home /home/digabi --shell /bin/bash digabi
RUN chown digabi /home/digabi

RUN apt-get update && apt-get -y install gnupg curl && \
    curl 'https://dl-ssl.google.com/linux/linux_signing_key.pub' | apt-key add - && \
    echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' > /etc/apt/sources.list.d/chrome.list && \
    echo 'deb http://deb.debian.org/debian bookworm-backports main' > /etc/apt/sources.list.d/bookworm-backports.list && \
    install -d /usr/share/postgresql-common/pgdg && \
    curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc && \
    echo 'deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt bookworm-pgdg main' > /etc/apt/sources.list.d/pgdg.list

RUN apt-get update && \
    apt-get -y install jq ca-certificates cmake g++ gcc git libx11-dev libffi-dev libnss3-tools locales make libarchive-tools latexmk texlive-latex-recommended texlive-latex-extra \
    texlive texlive-xetex texlive-lang-european texlive-fonts-recommended texlive-fonts-extra inkscape netcat-traditional ruby ruby-dev sudo libsystemd-dev golang vim cups-ipp-utils binutils \
    google-chrome-unstable postgresql-16 postgresql-contrib-16 postgresql-server-dev-16 && \
    rm -rf /var/lib/apt/lists/*

RUN echo 'fi_FI.UTF-8 UTF-8' > /etc/locale.gen && \
    locale-gen && \
    ln -sf /usr/share/zoneinfo/Europe/Helsinki /etc/localtime && \
    sed -i 's/scram-sha-256/trust/g' /etc/postgresql/16/main/pg_hba.conf && \
    echo "TimeZone = 'Europe/Helsinki'" >> /etc/postgresql/16/main/postgresql.conf && \
    pg_ctlcluster 16 main start && \
    sudo -u postgres psql -c 'CREATE USER digabi WITH SUPERUSER;' && \
    pg_ctlcluster 16 main stop

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | sudo -u digabi bash && \
    sudo -u digabi bash -c 'cd ; . ~/.nvm/nvm.sh; for v in 18.17.0 22.12.0; do nvm install $v; done'

RUN gem install fpm

# Install playwright based oni official playwright image
# https://github.com/microsoft/playwright/blob/main/utils/docker/Dockerfile.focal
ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright-agent
RUN mkdir /ms-playwright-agent && \
    export PATH=$PATH:/home/digabi/.nvm/versions/node/v22.12.0/bin && \
    cd /ms-playwright-agent && npm init -y && \
    npm i playwright && \
    npx playwright install --with-deps && \
    rm -rf /ms-playwright-agent
