local txt = [[
-- All Comands --

!online
!go - Search Players Online Your Guild and Charges Outfit. (Only Leaders).
!uptime
!serverinfo
!frags
!cast on/off
!buyhouse
!info
!machete
!rope
!shovel
!aol - 1 Crystal Coin.
!bless - 5 Crystal Coins.
!room war - Teleport to Arena Anti-Entrosa.
!room event - Teleport to Event Room.
!exp
!bc - Say in broadcast server Ex: !bc Any guild want to go to war today? (Only Leaders).

-- PVP SYSTEM --

RedSkull = 15 Frags - 24 Hours.
BlackSkull = 30 Frags - 24 Hours.
PK time on Injust = 7 Minutes.
PZ Locked = 1 Minute.
Protect Level = Level: 80.
Free Blessings = Level: 100.

-- Free Rewards --

Level 20: 2 Crystal Coins.
Level 45: 5 Crystal Coins.
Level 80: 8 Crystal Coins.
Level 100: 10 Crystal Coins.

-- Other's Informations --

2 Minutes In Traning Monk you Regen 1 Minute In Stamina.
]]

function onSay(cid, words, param)
    doPlayerPopupFYI(cid, txt)
   
   return true
end