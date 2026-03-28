library(plumber)
library(httr)

# ==========================================
# COLOQUE SEUS DADOS AQUI (ENTRE AS ASPAS)
# ==========================================
MINHA_CHAVE_SID   <- "AC6627b6f6de8f0121dac1a92dfb093133"
MEU_TOKEN_TWILIO  <- "1cd70e18bb15cdefb2450e1a7c334f3f"
LINK_VENDAS       <- "https://luhveestore-unbgvh5h.manus.space"

# =========================
# FUNÇÃO DE ENVIO
# =========================
enviar_msg <- function(numero, mensagem) {
  URL_TWILIO <- paste0("https://api.twilio.com/2010-04-01/Accounts/", MINHA_CHAVE_SID, "/Messages.json")
  
  print(paste("TENTANDO ENVIAR PARA:", numero))
  
  RES <- POST(URL_TWILIO,
              authenticate(MINHA_CHAVE_SID, MEU_TOKEN_TWILIO),
              body = list(
                From = "whatsapp:+14155238886", 
                To = numero,
                Body = mensagem
              ),
              encode = "form")
  
  print(paste("STATUS DA RESPOSTA TWILIO:", status_code(RES)))
  return(RES)
}

#* @post /whatsapp
#* @serializer json
function(req) {
  params <- URLdecode(req$postBody)
  
  try({
    NUMERO_CLIENTE <- gsub(".From=(whatsapp%3A%2B[0-9]+).", "\\1", params)
    NUMERO_CLIENTE <- URLdecode(NUMERO_CLIENTE)
    
    MENSAGEM_CLIENTE <- gsub(".Body=([^&]+).", "\\1", params)
    MENSAGEM_CLIENTE <- URLdecode(gsub("\\+", " ", MENSAGEM_CLIENTE))
    
    if (!is.null(NUMERO_CLIENTE)) {
      RESPOSTA <- paste0("😍 Oii! Bem-vinda à Luhvee Stores!\n👉 Veja nossos achadinhos aqui: ", LINK_VENDAS)
      enviar_msg(NUMERO_CLIENTE, RESPOSTA)
    }
  })

  return(list(status = "SUCCESS"))
}
