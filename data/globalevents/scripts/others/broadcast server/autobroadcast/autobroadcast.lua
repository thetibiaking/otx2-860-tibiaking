local messages = {
	"Por favor, reporte bugs e criaturas faltando/npcs/quests no forum de nosso servidor com imagens e descrição.",
	"Siga as regras do servidor para evitar um banimento.",
	"Você tem a possibilidade de doar com cartão de crédito, depósito, transferencias bancárias ou através de boleto bancario no tremix-global.com!",
	"Visite o site oficial diariamente para ter uma visão geral das últimas notícias.",
	"A equipe do servidor não faz quests nem wars, então se você quer um OT cheio de wars ajude-nos a divulgar para fazer diversas wars.",
	"Não nos responsabilizamos por items/senhas perdidos, para evitar isso não de sua senha para ninguem e tenha sua Recovery Key anotada em segurança!!",
	"Convide seus amigos para jogar, fazer uma guild, ganhar dinheiro, encontrar itens raros e se tornar uma lenda.",
	"Aproveite o servidor por inteiro fazendo uma doação e adquirindo todas as vantagens que o mesmo lhe ofereçe",
	"Quando alguém ameaçar matá-lo se você não der seus items, não de nada, pois eles podem matá-lo de qualquer maneira.",
	"Zao, Razachai são uma das novas áreas que voce poderá desfrutar aqui no tremix-global.com!",
	"Não jogue mochilas vazias no chão, jogue no lixo.",
	"Por favor, pense duas vezes antes de matar um dog. Eles só querem ser seu amigo!"
}

local i = 0
function onThink(interval, lastExecution)
local message = messages[(i % #messages) + 1]
    doBroadcastMessage("Informação: " .. message .. "", MESSAGE_STATUS_CONSOLE_ORANGE)
    i = i + 1
    return TRUE
end