function onThink(interval, lastExecution)
  -- Configura��es
    local cor = 22 -- Defina a cor da mensagem (22 = branco)
    local mensagens ={
[[[Information] Sejam Todos Bem-Vindos ao Tremix-global, somos um servidor Global 100% s�rio, com algums sistemas, customizados, e em perfeito estado, sinta-se em casa! Para mais informa��es sobre o nosso servidor digite !info. Bom jogo � todos!]]
}

  -- Fim de Configura��es

  doBroadcastMessage(mensagens[math.random(1,table.maxn(mensagens))], cor)
return TRUE
end
