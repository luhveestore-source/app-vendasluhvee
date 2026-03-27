FROM ghcr.io/r-lib/plumber:v1.2.0

# Instala apenas o que é essencial e rápido
RUN R -e "install.packages(c('httr', 'jsonlite'), repos='https://cloud.r-project.org/')"

# Copia os arquivos
COPY . /app
WORKDIR /app

# Porta padrão
EXPOSE 8080

# Comando direto para rodar
CMD ["R", "-e", "pr <- plumber::pr('webhook.R'); pr$run(host='0.0.0.0', port=as.numeric(Sys.getenv('PORT', '8080')))"]
