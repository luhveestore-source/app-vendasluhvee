# Usamos uma imagem oficial do R
FROM rocker/r-ver:4.3.1

# Instala dependências do sistema para internet e segurança
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# Instala os pacotes R que o seu bot usa (plumber e httr)
RUN R -e "install.packages(c('plumber', 'httr'), repos='https://cloud.r-project.org/')"

# Copia os arquivos do GitHub para o servidor
WORKDIR /app
COPY . .

# Define a porta padrão (o Render vai preencher isso automaticamente)
ENV PORT=8080
EXPOSE 8080

# Comando para ligar o seu bot vendedor
CMD ["R", "-e", "pr <- plumber::pr('webhook.R'); pr$run(host='0.0.0.0', port=as.numeric(Sys.getenv('PORT', 8080)))"]
