FROM rocker/r-ver:4.3.1

# Instala apenas o que falta (ele vai ser rápido agora porque já fez o grosso)
RUN apt-get update && apt-get install -y libcurl4-openssl-dev libssl-dev libxml2-dev
RUN R -e "install.packages(c('plumber', 'httr', 'jsonlite'), repos='https://cloud.r-project.org/')"

COPY . /app
WORKDIR /app

EXPOSE 8080

CMD ["R", "-e", "pr <- plumber::pr('webhook.R'); pr$run(host='0.0.0.0', port=as.numeric(Sys.getenv('PORT', '8080')))"]
