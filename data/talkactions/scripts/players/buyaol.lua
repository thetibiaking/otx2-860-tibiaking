local config = {
	storage = 67543,
	exausted = 30
}
function onSay(cid, words, param, channel)
	if getPlayerStorageValue(cid, config.storage) >= os.time() then
		doPlayerSendCancel(cid, "Aguarde ".. getPlayerStorageValue(cid, config.storage) - os.time() .. " segundos para utilizar novamente.")
		return true
	end
	setPlayerStorageValue(cid, config.storage, os.time()+config.exausted)
local preco = 10000
  if getPlayerFreeCap(cid) > 5 or not getContainerCapById(2173) then
    if doPlayerRemoveMoney(cid, preco) == TRUE then
      doPlayerAddItem(cid,2173,1)
      doSendMagicEffect(getPlayerPosition(cid),6)
    else
      doPlayerSendCancel(cid,"Você nao tem 10k.")
    end
  else
    doPlayerSendCancel(cid,"Você nao tem Cap suficiente ou não possuí espaço na backpack.")
 end
  return TRUE
end