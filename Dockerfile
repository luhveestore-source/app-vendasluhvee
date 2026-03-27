FROM rocker/r-ver:4.3.1

# Instala dependências do sistema
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# Força a instalação dos pacotes antes de rodar o bot
RUN R -e "install.packages('plumber', repos='https://cloud.r-project.org/')"
RUN R -e "install.packages('httr', repos='https://cloud.r-project.org/')"
RUN R -e "install.packages('jsonlite', repos='https://cloud.r-project.org/')"

COPY . /app
WORKDIR /app

EXPOSE 8080

CMD ["R", "-e", "pr <- plumber::pr('webhook.R'); pr$run(host='0.0.0.0', port=as.numeric(Sys.getenv('PORT', '8080')))"]
