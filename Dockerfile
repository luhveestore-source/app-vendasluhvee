FROM rocker/r-ver:4.3.1

# 1. Instalar dependências de SISTEMA (incluindo libsodium para o pacote sodium)
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

# 2. Instalar pacotes do R (instalando 'sodium' primeiro para garantir)
RUN R -e "install.packages('sodium', repos='https://cloud.r-project.org/')"
RUN R -e "install.packages(c('plumber', 'httr2', 'ellmer', 'future', 'promises'), repos='https://cloud.r-project.org/')"

# 3. Preparar a pasta do app
WORKDIR /app
COPY . /app

# 4. Expor a porta
EXPOSE 8080

# 5. Comando de arranque corrigido
CMD ["R", "-e", "library(plumber); pr <- pr('webhook.R'
