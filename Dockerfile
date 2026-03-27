FROM rocker/r-ver:4.3.1

# 1. Instalar dependências do sistema (Essencial para pacotes de R)
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    zlib1g-dev \
    make \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# 2. Instalar os pacotes do R (Adicionei o 'processx' que ajuda o plumber no Render)
RUN R -e "install.packages(c('plumber', 'httr2', 'ellmer', 'future', 'promises', 'processx'), repos='https://cloud.r-project.org/')"

# 3. Preparar a pasta do app
RUN mkdir /app
COPY . /app
WORKDIR /app

# 4. Expor a porta que o Render fornece
EXPOSE 8080

# 5. Comando para rodar (com um pequeno ajuste na sintaxe para garantir o carregamento)
CMD ["R", "-e", "library(plumber); pr <- pr('webhook.R'); pr$run(host='0.0.0.0', port=as.numeric(Sys.getenv('PORT', '8080')))"]
