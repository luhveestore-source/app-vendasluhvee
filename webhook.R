library(plumber)
library(httr)

# =========================
# CONFIGURAÇÕES
# =========================
LINK_VENDAS <- "https://luhveestore-unbgvh5h.manus.space"

# =========================
# FUNÇÃO DE ENVIO WHATSAPP
# =========================
enviar_msg <- function(numero, mensagem) {
  # Buscando as chaves que você salvou no Render (EM MAIÚSCULAS)
  SID   <- Sys.getenv("TWILIO_SID")
  TOKEN <- Sys.getenv("TWILIO_TOKEN")
  
  URL_TWILIO <- paste0("https://api.twilio.com/2010-04-01/Accounts/", SID, "/Messages.json")
  
  print(paste("TENTANDO ENVIAR PARA:", numero))
  
  RES <- POST(URL_TWILIO,
              authenticate(SID, TOKEN),
              body = list(
                From = "whatsapp:+14155238886", 
                To = numero,
                Body = mensagem
              ),
              encode = "form")
  
  return(RES)
}

# =========================
# LÓGICA DO BOT (RESPOSTAS)
# =========================
responder_cliente <- function(msg) {
  # Converte o que o cliente digitou para minúsculo para facilitar a busca
  TEXTO <- tolower(msg)

  if (grepl("oi|olá|ola|bom dia|boa tarde", TEXTO)) {
    return(paste0("😍 Oii! Bem-vinda à Luhvee Stores!\n🔥 Tenho achadinhos exclusivos com preço baixo HOJE!\n👉 Quer ver agora? ", LINK_VENDAS))
  }

  if (grepl("preço|valor|quanto|custo|preco", TEXTO)) {
    return(paste0("💰 Os preços estão promocionais HOJE!\n⚡ Corre antes que acabe:\n👉 ", LINK_VENDAS))
  }

  if (grepl("comprar|quero|ten|tem|produto|link|site", TEXTO)) {
    return(paste0("🛒 Perfeito! Já pode garantir o seu aqui:\n👉 ", LINK_VENDAS, "\n🔥 Estoque LIMITADO! Garanta o seu antes que esgote!"))
  }

  # RESPOSTA PADRÃO
  return(paste0("🔥 Temos ofertas absurdas HOJE na Luhvee Stores!\n👉 Veja aqui todos os itens: ", LINK_VENDAS, "\n💖 Você vai amar!"))
}

# =========================
# WEBHOOK (ENTRADA DE DADOS)
# =========================

#* @post /whatsapp
function(req) {
  # Garante que o Plumber entenda os dados vindos do Twilio
  DADOS <- as.list(req$postBody)
  
  NUMERO_CLIENTE   <- DADOS$From
  MENSAGEM_CLIENTE <- DADOS$Body
  
  # Caso a primeira tentativa falhe, tenta o formato alternativo
  if (is.null(NUMERO_CLIENTE)) {
    DADOS <- req$body
    NUMERO_CLIENTE <- DADOS$From
    MENSAGEM_CLIENTE <- DADOS$Body
  }

  print(paste("MENSAGEM RECEBIDA DE:", NUMERO_CLIENTE))

  if (!is.null(NUMERO_CLIENTE) && !is.null(MENSAGEM_CLIENTE)) {
    RESPOSTA_FINAL <- responder_cliente(MENSAGEM_CLIENTE)
    enviar_msg(NUMERO_CLIENTE, RESPOSTA_FINAL)
  }

  return(list(status = "SUCCESS"))
}
