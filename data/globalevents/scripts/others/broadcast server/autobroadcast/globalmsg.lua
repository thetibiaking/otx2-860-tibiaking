function onThink(interval, lastExecution)
  -- Configurações
    local cor = 22 -- Defina a cor da mensagem (22 = branco)
    local mensagens ={
[[[Information] Sejam Todos Bem-Vindos ao Tremix-global, somos um servidor Global 100% sério, com algums sistemas, customizados, e em perfeito estado, sinta-se em casa! Para mais informações sobre o nosso servidor digite !info. Bom jogo à todos!]]
}

  -- Fim de Configurações

  doBroadcastMessage(mensagens[math.random(1,table.maxn(mensagens))], cor)
return TRUE
end
