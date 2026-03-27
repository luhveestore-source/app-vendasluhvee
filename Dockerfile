FROM rocker/r-ver:4.3.1

RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    zlib1g-dev \
    libsodium-dev \
    make \
    gcc \
    g++ \
    && rm -rf /var/lib/apt/lists/*

RUN R -e "install.packages('sodium', repos='https://cloud.r-project.org/')"
RUN R -e "install.packages(c('plumber', 'httr', 'future', 'promises'), repos='https://cloud.r-project.org/')"

WORKDIR /app
COPY . /app

EXPOSE 8080

CMD ["R", "-e", "library(plumber); pr <- pr('webhook.R'); pr$run(host='0.0.0.0', port=as.numeric(Sys.getenv('PORT', '8080')))"]
