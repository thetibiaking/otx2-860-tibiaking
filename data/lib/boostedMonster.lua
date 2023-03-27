monster_name_backup = 74812 -- nao mexer
monster_exp_backup = 74813 -- nao mexer
monster_loot_backup = 74814 -- nao mexer

config_boosted = {

    ["14:02:00"] = { -- Horario de cada dia que irá ocorrer a troca dos monstros
        pos_monster = {x = 1030, y = 1074, z = 6, stackpos = 253}, -- a posição aonde ficara o monstro informando a quantidade de exp e loot
        time_effects = 2 -- tempo em segundos que ficará saindo os efeitos
    }
    
}

monsters_boosteds = { -- Configuracao dos monstros que irão ter exp e loot aumentados
	[1] = {monster_name = "Dwarf", exp = 5, loot = 7},
	[2] = {monster_name = "Goblin", exp = 15, loot = 5},
	[3] = {monster_name = "Orc", exp = 25, loot = 15},
    [4] = {monster_name = "Dwarf Soldier", exp = 35, loot = 10},
    --[5] = {monster_name = "NOME DO MONSTRO", exp = "PORCENTAGEM DE EXP", loot = "PORCENTAGEM DO LOOT"},
}