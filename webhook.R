library(plumber)
library(httr)

# =========================
# CONFIGURAÇÕES
# =========================
# O link da sua loja
link_vendas <- "https://luhveestore-unbgvh5h.manus.space"

# Pegando as chaves de forma segura do ambiente (Render)
TWILIO_SID   <- Sys.getenv("TWILIO_SID")
TWILIO_TOKEN <- Sys.getenv("TWILIO_TOKEN")

# =========================
# FUNÇÃO DE ENVIO WHATSAPP
# =========================
enviar_msg <- function(numero, mensagem) {
  url <- paste0("https://api.twilio.com/2010-04-01/Accounts/", TWILIO_SID, "/Messages.json")
  
  # Log para debug no console do Render
  print(paste("Enviando mensagem para:", numero))
  
  res <- POST(url,
       authenticate(TWILIO_SID, TWILIO_TOKEN),
       body = list(
         From = "whatsapp:+14155238886", # Número padrão do Sandbox Twilio
         To = numero,
         Body = mensagem
       ),
       encode = "form"
  )
  return(res)
}

# =========================
# LÓGICA DO BOT (RESPOSTAS)
# =========================
responder <- function(msg) {
  msg <- tolower(msg)

  if (grepl("oi|olá|ola", msg)) {
    return(paste(
      "😍 Oii! Bem-vinda à Luhvee Stores!",
      "\n🔥 Tenho achadinhos exclusivos com preço baixo HOJE!",
      "\n👉 Quer ver agora? ", link_vendas
    ))
  }

  if (grepl("preço|valor|quanto", msg)) {
    return(paste(
      "💰 Os preços estão promocionais HOJE!",
      "\n⚡ Corre antes que acabe:",
      "\n👉", link_vendas
    ))
  }

  if (grepl("comprar|quero|ten|tem|produto", msg)) {
    return(paste(
      "🛒 Perfeito! Já pode garantir o seu aqui:",
      "\n👉", link_vendas,
      "\n🔥 Estoque LIMITADO! Garanta o seu antes que esgote!"
    ))
  }

  # Resposta padrão caso não entenda
  return(paste(
    "🔥 Temos ofertas absurdas HOJE na Luhvee Stores!",
    "\n👉 Veja aqui todos os itens:", link_vendas,
    "\n💖 Você vai amar!"
  ))
}

# =========================
# WEBHOOK (ENTRADA)
# =========================

#* @post /whatsapp
function(req) {
  # O Twilio envia os dados no corpo da requisição (body)
  # No Plumber, acessamos os dados do formulário assim:
  dados <- req$body
  
  numero   <- dados$From
  mensagem <- dados$Body
  
  # Log para você ver quem está chamando no painel do Render
  print(paste("Mensagem recebida de:", numero, "Conteúdo:", mensagem))

  # Processa a resposta
  resposta_texto <- responder(mensagem)

  # Envia de volta para o cliente
  enviar_msg(numero, resposta_texto)

  # Retorna OK para o Twilio não tentar reenviar a mesma mensagem
  return(list(status = "success"))
}
