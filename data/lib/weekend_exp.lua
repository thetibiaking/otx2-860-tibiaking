config_weekend_exp = {
   dates = {"Tuesday", "Wednesday", "Thursday"}, -- Dias da semana que será ativo
   rates = {
         {1, 1.05}, -- {quantidade de jogador online, taxa de bonus}
         {2, 1.10},
         {3, 1.15}
      },
   storage_bonus = 30303,
}

function get_bonus_weekend_exp()
   for _, rate in ipairs(config_weekend_exp.rates) do
      if  #getPlayersOnline() >= rate[1] then
         if getGlobalStorageValue(config_weekend_exp.storage_bonus) ~= 1 then
            doBroadcastMessage("[Weekend Exp Event] The server reached "..rate[1].." players online! The bonus of exp is now "..((rate[2] - 1)*100).."%!")
         end
         setGlobalStorageValue(config_weekend_exp.storage_bonus, 1) --Bonus ativado
         return rate[2] --retornando a taxa de exp que deve ser adicionada
      else
         setGlobalStorageValue(config_weekend_exp.storage_bonus, -1)
      end
   end
   return 1
end

function set_bonus_weekend_exp(cid, monster_name)
   local rate_bonus = get_bonus_weekend_exp()
   local monster = getMonsterInfo(monster_name)
   if getGlobalStorageValue(config_weekend_exp.storage_bonus) == 1 then
      if getConfigValue("experienceStages") == true then
         doPlayerAddExp(cid, (monster.experience * getExperienceStage(getPlayerLevel(cid))) * rate_bonus)
         doPlayerSendTextMessage(cid, 25, "[Weekend Exp Event] Voce esta com "..((rate_bonus - 1)*100).."% de bonus experiencia.")
      end
   end
   return true
end