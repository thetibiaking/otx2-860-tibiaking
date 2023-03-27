local files = {

    '000-constant.lua',
    '001-class.lua',
    '002-wait.lua',
    '004-database.lua',
    '011-string.lua',
    '012-table.lua',
    '013-math.lua',
    '031-vocations.lua',
    '032-position.lua',
    '033-ip.lua',
    '034-exhaustion.lua',
    '049-vipsys.lua',
    '050-function.lua',
    '075-custom_functions.lua',
    '090-woox_functions.lua',
    '100-shortcut.lua',
    '101-compat.lua',
    '101-war.lua',
    '106-cityswar.lua',
    'antimc.lua',
    'arena.lua',
    'boostedMonster.lua',
    'DTT.lua',
    'lib_zombie.lua',
    'weekend_exp.lua'
}

for _, file in ipairs(files) do
    dofile(('data/lib/%s'):format(file))
end