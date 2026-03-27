FROM rocker/r-ver:4.3.1

# Instala dependências do sistema
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# Instala pacotes do R
RUN R -e "install.packages(c('plumber', 'httr', 'jsonlite'), repos='https://cloud.r-project.org/')"

# Copia tudo para o servidor
COPY . /app
WORKDIR /app

# Porta do bot
EXPOSE 8080

# Comando para rodar
CMD ["R", "-e", "pr <- plumber::pr('webhook.R'); pr$run(host='0.0.0.0', port=as.numeric(Sys.getenv('PORT', '8080')))"]
