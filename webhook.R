library(plumber)
library(httr)

# =========================
# CONFIGURAÇÕES
# =========================
link_vendas <- "https://luhveestore-unbgvh5h.manus.space"

# =========================
# FUNÇÃO DE ENVIO WHATSAPP
# =========================
enviar_msg <- function(numero, mensagem) {
  # Lemos as chaves aqui dentro para garantir que o Render já as carregou
  sid   <- Sys.getenv("TWILIO_SID")
  token <- Sys.getenv("TWILIO_TOKEN")
  
  url <- paste0("https://api.twilio.com/2010-04-01/Accounts/", sid, "/Messages.json")
  
  print(paste("Enviando resposta para:", numero))
  
  res <- POST(url,
              authenticate(sid, token),
              body = list(
                From = "whatsapp:+14155238886", 
                To = numero,
                Body = mensagem
              ),
              encode = "form")
  
  return(res)
}

# =========================
# LÓGICA DO BOT (RESPOSTAS)
# =========================
responder <- function(msg) {
  msg <- tolower(msg)

  if (grepl("oi|olá|ola|bom dia|boa tarde", msg)) {
    return(paste0("😍 Oii! Bem-vinda à Luhvee Stores!\n🔥 Tenho achadinhos exclusivos com preço baixo HOJE!\n👉 Quer ver agora? ", link_vendas))
  }

  if (grepl("preço|valor|quanto|custo", msg)) {
    return(paste0("💰 Os preços estão promocionais HOJE!\n⚡ Corre antes que acabe:\n👉 ", link_vendas))
  }

  if (grepl("comprar|quero|ten|tem|produto|link", msg)) {
    return(paste0("🛒 Perfeito! Já pode garantir o seu aqui:\n👉 ", link_vendas, "\n🔥 Estoque LIMITADO! Garanta o seu antes que esgote!"))
  }

  return(paste0("🔥 Temos ofertas absurdas HOJE na Luhvee Stores!\n👉 Veja aqui todos os itens: ", link_vendas, "\n💖 Você vai amar!"))
}

# =========================
# WEBHOOK (ENTRADA)
# =========================

#* @post /whatsapp
function(req) {
  # AJUSTE VITAL: Converter o corpo da requisição para lista
  dados <- as.list(req$postBody)
  
  # O Twilio envia os campos 'From' e 'Body'
  numero   <- dados$From
  mensagem <- dados$Body
  
  # Se os dados vierem vazios, tentamos outra forma comum no Plumber
  if (is.null(numero)) {
    dados <- req$body
    numero <- dados$From
    mensagem <- dados$Body
  }

  print(paste("Mensagem recebida de:", numero, "| Conteúdo:", mensagem))

  if (!is.null(numero) && !is.null(mensagem)) {
    resposta_texto <- responder(mensagem)
    enviar_msg(numero, resposta_texto)
  }

  return(list(status = "success"))
}
