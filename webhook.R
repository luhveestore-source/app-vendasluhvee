library(plumber)
library(httr)
library(jsonlite)

# SEU LINK DE VENDAS
link_vendas <- "https://luhveestore-unbgvh5h.manus.space"

# FUNÇÃO DE ENVIO WHATSAPP
enviar_msg <- function(numero, mensagem){
  url <- "https://api.twilio.com/2010-04-01/Accounts/SEU_SID/Messages.json"
  
  POST(url,
       authenticate("SEU_SID", "SEU_TOKEN"),
       body = list(
         From = "whatsapp:+14155238886",
         To = numero,
         Body = mensagem
       ),
       encode = "form"
  )
}

# BOT INTELIGENTE
responder <- function(msg){

  msg <- tolower(msg)

  if(grepl("oi|olá|ola", msg)){
    return(paste(
      "😍 Oii! Bem-vinda à Luhvee Stores!",
      "\n🔥 Tenho achadinhos exclusivos com preço baixo HOJE!",
      "\n👉 Quer ver agora? ", link_vendas
    ))
  }

  if(grepl("preço|valor", msg)){
    return(paste(
      "💰 Os preços estão promocionais HOJE!",
      "\n⚡ Corre antes que acabe:",
      "\n👉", link_vendas
    ))
  }

  if(grepl("comprar|quero", msg)){
    return(paste(
      "🛒 Perfeito! Já pode garantir o seu aqui:",
      "\n👉", link_vendas,
      "\n🔥 Estoque LIMITADO!"
    ))
  }

  return(paste(
    "🔥 Temos ofertas absurdas HOJE!",
    "\n👉 Veja aqui:", link_vendas
  ))
}

# WEBHOOK
#* @post /webhook
function(req){

  dados <- parseQueryString(req$postBody)

  numero <- dados$From
  mensagem <- dados$Body

  resposta <- responder(mensagem)

  enviar_msg(numero, resposta)

  return(list(status="ok"))
}
