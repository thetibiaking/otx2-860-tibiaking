local messages = {
	"Digite o comando !shop para retirar seus items do Shop Donate",
	"Use os comando !rope - !shovel - !machete - !pick para receber seus equipamentos",
	"Acesse nosso instagram e fique por dentro das novidades lá @tibia.ot",
	"Use o ctrl + r para nos reportar um bug e ajudar a crescer mais o servidor",
	"Free Bless até o nível 100",
	"Novas Cidades Vip: Sao : Ice City, Nevaska, Gengia, Gundabad, Oramond, Vikya, Ghala, Dragon Lair gray island darmax issavi and Farmine",
	"Novos itens de task confira no site | http://tibiaot.com.br/?subtopic=itemcustom",
	"Lembre-se que ao logar lhe informa se está com bless ou não, então verifique sempre para não perder seu loot",
	"TradeOff - Use nosso Market Online para compras e vendas. http://tibiaot.com.br/?subtopic=tradeoff",
        " Seller Events Coin sao ganhadas nos eventos e sao  trocadas acima do temple de thais.",
	"Promoção de Double Points, aproveite. Na doação feita por Transferência terá um bônus extra.",}

local i = 0
function onThink(interval, lastExecution)
local message = messages[(i % #messages) + 1]
    doBroadcastMessage("Informação: " .. message .. "", MESSAGE_STATUS_CONSOLE_ORANGE)
    i = i + 1
    return TRUE
end







