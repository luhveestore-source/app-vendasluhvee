FROM rocker/r-ver:4.3.1

# Instala dependências do sistema Linux necessárias para pacotes de rede e segurança
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Instala os pacotes do R
RUN R -e "install.packages(c('plumber', 'httr2', 'ellmer', 'future', 'promises'), repos='https://cloud.r-project.org/')"

COPY . /app
WORKDIR /app

# O Render usa uma variável de ambiente chamada PORT
EXPOSE 8080

CMD ["R", "-e", "pr <- plumber::pr('webhook.R'); pr$run(host='0.0.0.0', port=as.numeric(Sys.getenv('PORT', 8080)))"]
