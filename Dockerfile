FROM debian:jessie

RUN apt-get update && \
    apt-get -y install jq ca-certificates curl g++ gcc git libX11-dev libffi-dev libnss3-tools locales make bsdtar latexmk texlive-latex-recommended texlive-latex-extra\
    netcat-traditional ruby ruby-dev sudo && \
    curl 'https://dl-ssl.google.com/linux/linux_signing_key.pub' | apt-key add - && \
    echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' > /etc/apt/sources.list.d/chrome.list && \
    curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    echo 'deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main' > /etc/apt/sources.list.d/pgdg.list && \
    apt-get update && \
    apt-get -y install google-chrome-unstable postgresql-9.5 postgresql-contrib-9.5 postgresql-server-dev-9.5 && \
    rm -rf /var/lib/apt/lists/* && \
    echo 'fi_FI.UTF-8 UTF-8' > /etc/locale.gen && \
    locale-gen && \
    sed -i 's/md5/trust/' /etc/postgresql/9.5/main/pg_hba.conf && \
    pg_ctlcluster 9.5 main start && \
    sudo -u postgres psql -c 'CREATE USER digabi WITH SUPERUSER;' && \
    pg_ctlcluster 9.5 main stop && \
    adduser --system --uid 1001 digabi && \
    curl https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | sudo -u digabi bash && \
    sudo -u digabi bash -c 'cd ; . ~/.nvm/nvm.sh; for v in 8.11.3 12.4.0 12.6.0 12.7.0; do nvm install $v; nvm exec $v npm install -g yarn; done' && \
    gem install fpm
