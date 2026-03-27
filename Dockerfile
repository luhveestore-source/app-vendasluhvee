FROM rbase/r-ubuntu:4.3.1

# Instala dependências do sistema
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# Instala os pacotes do R que o bot precisa
RUN R -e "install.packages(c('plumber', 'httr', 'jsonlite'), repos='https://cloud.r-project.org/')"

# Copia o código do seu bot para dentro do servidor
COPY webhook.R /webhook.R

# Abre a porta para o bot receber mensagens
EXPOSE 8080

# Comando para ligar o bot
CMD ["R", "-e", "pr <- plumber::pr('/webhook.R'); pr$run(host='0.0.0.0', port=as.numeric(Sys.getenv('PORT', '8080')))"]
