--[[

i would like to thank Enjl, Marioman2007, and Rednaxela for helping me
with all this stuff

--]]



local inventory = {}

local npcManager = require("npcManager")

local inventory = Graphics.loadImage(Misc.resolveFile("inventorystuff/inventory.png"))
local inventorysmol = Graphics.loadImage(Misc.resolveFile("inventorystuff/inventorysmol.png"))
local selector = Graphics.loadImage(Misc.resolveFile("inventorystuff/selector.png"))
local selection = false
local selectx = 30
local selecty = 508
local numx = 40
local numy = 570

local activateinventory = false
local inventoryopen = false

local pUpsTable = table.map{14, 182, 183, 264, 277, 34, 169, 170}

local powerup = {
                 2, 
                 3, 
                 7, 
                 4, 
                 5, 
                 6}
local state = 1

-- how much of each powerup is being stored
SaveData.inventory = SaveData.inventory or {
    shroom = 0,
    fire = 0,
    ice = 0,
    leaf = 0,
    tanooki = 0,
    hammer = 0
}

--these are the graphics that show when you dont have any of one powerup
local noshroom = Graphics.loadImage(Misc.resolveFile("inventorystuff/noshroom.png"))
local nofire = Graphics.loadImage(Misc.resolveFile("inventorystuff/nofire.png"))
local noice = Graphics.loadImage(Misc.resolveFile("inventorystuff/noice.png"))
local noleaf = Graphics.loadImage(Misc.resolveFile("inventorystuff/noleaf.png"))
local notanooki = Graphics.loadImage(Misc.resolveFile("inventorystuff/notanooki.png"))
local nohammer = Graphics.loadImage(Misc.resolveFile("inventorystuff/nohammer.png"))

--same as above but for when the inventory is closed
local noshroomsmol = Graphics.loadImage(Misc.resolveFile("inventorystuff/noshroomsmol.png"))
local nofiresmol = Graphics.loadImage(Misc.resolveFile("inventorystuff/nofiresmol.png"))
local noicesmol = Graphics.loadImage(Misc.resolveFile("inventorystuff/noicesmol.png"))
local noleafsmol = Graphics.loadImage(Misc.resolveFile("inventorystuff/noleafsmol.png"))
local notanookismol = Graphics.loadImage(Misc.resolveFile("inventorystuff/notanookismol.png"))
local nohammersmol = Graphics.loadImage(Misc.resolveFile("inventorystuff/nohammersmol.png"))

-- the maximum and minimum amout of each powerup that can be stored
local maxshroom = 10
local minshroom = 0

local maxfire = 5
local minfire = 0

local maxice = 5
local minice = 0

local maxleaf = 5
local minleaf = 0

local maxtanooki = 5
local mintanooki = 0

local maxhammer = 5
local minhammer = 0


function inventory.onInitAPI()
    registerEvent(inventory , "onStart")
    registerEvent(inventory , "onDraw")
    registerEvent(inventory , "onPostNPCKill")
    registerEvent(inventory , "onTick")
    registerEvent(inventory , "onEvent")
    registerEvent(inventory , "onInputUpdate")
end



-- Run code on the first frame
function inventory.onStart()
    



end

function inventory.onDraw()

    player.reservePowerup = 0 -- disables the item box
    player.keepPowerOnMega = true

    if activateinventory == true then
        if Misc.isPausedByLua() then
            numx = 54
            numy = 574

        

            if SaveData.inventory.shroom >= 10 then
                Text.print(SaveData.inventory.shroom, numx-8, numy)
            else
                Text.print(SaveData.inventory.shroom, numx, numy)
            end


            Text.print(SaveData.inventory.fire, numx+64, numy)
            Text.print(SaveData.inventory.ice, numx+128, numy)
            Text.print(SaveData.inventory.leaf, numx+192, numy)
            Text.print(SaveData.inventory.tanooki, numx+256, numy)
            Text.print(SaveData.inventory.hammer, numx+320, numy)
        end
    end

    if SaveData.inventory.shroom >= maxshroom then
        SaveData.inventory.shroom = maxshroom
    end

    if SaveData.inventory.fire >= maxfire then
        SaveData.inventory.fire = maxfire
    end

    if SaveData.inventory.ice >= maxice then
        SaveData.inventory.ice = maxice
    end

    if SaveData.inventory.leaf >= maxleaf then
        SaveData.inventory.leaf = maxleaf
    end

    if SaveData.inventory.tanooki >= maxtanooki then
        SaveData.inventory.tanooki = maxtanooki
    end

    if SaveData.inventory.hammer >= maxhammer then
        SaveData.inventory.hammer = maxhammer
    end

    if activateinventory == true then
        if Misc.isPausedByLua() then -- selects the powerup
            if player.rawKeys.jump == KEYS_PRESSED then
                if player.powerup == powerup[state] then
                    Audio.playSFX(Misc.resolveFile("inventorystuff/error.wav"))
                 elseif state == 1 then
                    if SaveData.inventory.shroom > 0 then -- mushroom
                        if player.powerup == 1 then
                            Audio.playSFX(Misc.resolveFile("inventorystuff/powerupselect.wav"))
                            Audio.playSFX(6)
                            player.powerup = powerup[state]
                            SaveData.inventory.shroom = SaveData.inventory.shroom - 1
                        end
                    elseif SaveData.inventory.shroom <= 0 then
                        Audio.playSFX(Misc.resolveFile("inventorystuff/error.wav"))
                    end
                elseif state == 2 then
                    if SaveData.inventory.fire > 0 then -- SaveData.inventory.fire flower
                        Audio.playSFX(Misc.resolveFile("inventorystuff/powerupselect.wav"))
                        Audio.playSFX(6)
                        player.powerup = powerup[state]
                        SaveData.inventory.fire = SaveData.inventory.fire - 1
                    elseif SaveData.inventory.fire <= 0 then
                        Audio.playSFX(Misc.resolveFile("inventorystuff/error.wav"))
                    end
                elseif state == 3 then
                    if SaveData.inventory.ice > 0 then -- SaveData.inventory.ice flower
                        Audio.playSFX(Misc.resolveFile("inventorystuff/powerupselect.wav"))
                        Audio.playSFX(6)
                        player.powerup = powerup[state]
                        SaveData.inventory.ice = SaveData.inventory.ice - 1
                    elseif SaveData.inventory.ice <= 0 then
                        Audio.playSFX(Misc.resolveFile("inventorystuff/error.wav"))
                    end
                elseif state == 4 then
                    if SaveData.inventory.leaf > 0 then -- super SaveData.inventory.leaf
                        Audio.playSFX(Misc.resolveFile("inventorystuff/powerupselect.wav"))
                        Audio.playSFX(34)
                        player.powerup = powerup[state]
                        SaveData.inventory.leaf = SaveData.inventory.leaf - 1
                    elseif SaveData.inventory.leaf <= 0 then
                        Audio.playSFX(Misc.resolveFile("inventorystuff/error.wav"))
                    end
                elseif state == 5 then
                    if SaveData.inventory.tanooki > 0 then -- SaveData.inventory.tanooki suit
                        Audio.playSFX(Misc.resolveFile("inventorystuff/powerupselect.wav"))
                        Audio.playSFX(34)
                        player.powerup = powerup[state]
                        SaveData.inventory.tanooki = SaveData.inventory.tanooki - 1
                    elseif SaveData.inventory.tanooki <= mintanooki then
                        Audio.playSFX(Misc.resolveFile("inventorystuff/error.wav"))
                    end
                elseif state == 6 then
                    if SaveData.inventory.hammer > 0 then -- SaveData.inventory.hammer suit
                        Audio.playSFX(Misc.resolveFile("inventorystuff/powerupselect.wav"))
                        Audio.playSFX(34)
                        player.powerup = powerup[state]
                        SaveData.inventory.hammer = SaveData.inventory.hammer - 1
                    elseif SaveData.inventory.hammer <= 0 then
                        Audio.playSFX(Misc.resolveFile("inventorystuff/error.wav"))
                    end
                end
            end
        end
    end

    if activateinventory == true then
        if Misc.isPausedByLua() then
            if SaveData.inventory.shroom == minshroom then
                Graphics.drawImage(noshroom, 30, 508 )
            end
            if SaveData.inventory.fire == minfire then
                Graphics.drawImage(nofire, 94, 508 )
            end
            if SaveData.inventory.ice == minice then
                Graphics.drawImage(noice, 158, 508 )
            end
            if SaveData.inventory.leaf == minleaf then
                Graphics.drawImage(noleaf, 222, 508 )
            end
            if SaveData.inventory.tanooki == mintanooki then
                Graphics.drawImage(notanooki, 286, 508 )
            end
            if SaveData.inventory.hammer == minhammer then
                Graphics.drawImage(nohammer, 350, 508 )
            end

        end
    end


end


function inventory.onPostNPCKill(v,reason)

    if npcManager.collected(v, HARM_TYPE_VANISH) then
        if v.id == 14 or v.id == 183 or v.id == 182 then -- collecting fire flower
            if  player.isMega == true then
                SaveData.inventory.fire = SaveData.inventory.fire + 1
            end

        elseif v.id == 9 or v.id == 184 or v.id == 185 or v.id == 249 then -- collecting mushroom
            if player.powerup >= 2 or player.isMega == true then
                SaveData.inventory.shroom = SaveData.inventory.shroom + 1
            end

        elseif v.id == 264 or v.id == 277 then -- collecting ice flower
            if player.isMega == true then
                SaveData.inventory.ice = SaveData.inventory.ice + 1
            end

        elseif v.id == 34 then -- collecting super leaf
            if player.isMega == true then
                SaveData.inventory.leaf = SaveData.inventory.leaf + 1
            end

        elseif v.id == 169 then -- collecting tanooki suit
            if player.isMega == true then
                SaveData.inventory.tanooki = SaveData.inventory.tanooki + 1
            end

        elseif v.id == 170 then -- collecting hammer suit
            if player.isMega == true then
                SaveData.inventory.hammer = SaveData.inventory.hammer + 1
            end

        end

        if player.powerup == PLAYER_BIG then
            if player.isMega then

            elseif pUpsTable[v.id] then
                SaveData.inventory.shroom = SaveData.inventory.shroom + 1
            end
        elseif player.powerup == PLAYER_FIREFLOWER then
            if pUpsTable[v.id] then
                SaveData.inventory.fire = SaveData.inventory.fire + 1
            end
        elseif player.powerup == PLAYER_LEAF then
            if pUpsTable[v.id] then
                SaveData.inventory.leaf = SaveData.inventory.leaf + 1
            end
        elseif player.powerup == PLAYER_TANOOKIE then
            if pUpsTable[v.id] then
                SaveData.inventory.tanooki = SaveData.inventory.tanooki + 1
            end
        elseif player.powerup == PLAYER_HAMMER then
            if pUpsTable[v.id] then
                SaveData.inventory.hammer = SaveData.inventory.hammer + 1
            end
        elseif player.powerup == PLAYER_ICE then
            if pUpsTable[v.id] then
                SaveData.inventory.ice = SaveData.inventory.ice + 1
            end
        end
    end

end

-- Run code every frame (~1/65 second)
-- (code will be executed before game logic will be processed)
function inventory.onTick()
    Defines.player_hasCheated = false -- disables the disabling of saving when using a cheat code

  activateinventory = true

    Graphics.drawImage(inventorysmol, 32, 538) -- draws the inventory
    
        numx = 40
        numy = 570

            if SaveData.inventory.shroom >= 10 then
        Text.print(SaveData.inventory.shroom, numx-10, numy)
    else
        Text.print(SaveData.inventory.shroom, numx, numy)
    end

        Text.print(SaveData.inventory.fire, numx+32, numy)
        Text.print(SaveData.inventory.ice, numx+64, numy)
        Text.print(SaveData.inventory.leaf, numx+96, numy)
        Text.print(SaveData.inventory.tanooki, numx+128, numy)
        Text.print(SaveData.inventory.hammer, numx+160, numy)

                if SaveData.inventory.shroom == minshroom then
            Graphics.drawImage(noshroomsmol, 32, 538 )
        end
        if SaveData.inventory.fire == minfire then
            Graphics.drawImage(nofiresmol, 64, 538 )
        end
        if SaveData.inventory.ice == minice then
            Graphics.drawImage(noicesmol, 96, 538 )
        end
        if SaveData.inventory.leaf == minleaf then
            Graphics.drawImage(noleafsmol, 128, 538 )
        end
        if SaveData.inventory.tanooki == mintanooki then
            Graphics.drawImage(notanookismol, 160, 538 )
        end
        if SaveData.inventory.hammer == minhammer then
            Graphics.drawImage(nohammersmol, 192, 538 )
        end
end

-- Run code when internal event of the SMBX Engine has been triggered
-- eventName - name of triggered event
function inventory.onEvent(eventName)
    --Your code here
end


function inventory.onInputUpdate()


    if inventoryopen == false then
        if player.keys.dropItem ~= KEYS_PRESSED then
            activateinventory = false
        end
    end

  if player.rawKeys.dropItem == KEYS_PRESSED then -- toggle inventory menu

    if Misc.isPausedByLua() then
        if activateinventory == true then
        inventoryopen = false
            Audio.playSFX(Misc.resolveFile("inventorystuff/invclose.wav"))
            Misc.unpause()
            Audio.MusicVolume(64)
        end
    else
    inventoryopen = true
        Audio.playSFX(Misc.resolveFile("inventorystuff/invopen.wav"))
        Misc.pause()
        Audio.MusicVolume(16)
    end
  end

  if activateinventory == true then
      if Misc.isPausedByLua() then
        Graphics.drawImage(inventory, 30, 508)
        Graphics.drawImage(selector, selectx, selecty)
      end

        if Misc.isPausedByLua() then -- move cursor right
            if player.rawKeys.right == KEYS_PRESSED then
                Audio.playSFX(Misc.resolveFile("inventorystuff/menuselect.wav"))
                selectx = selectx + 64
                state = state + 1
            end

        
        end
        if Misc.isPausedByLua() then -- move cursor left
            if player.rawKeys.left == KEYS_PRESSED then
                Audio.playSFX(Misc.resolveFile("inventorystuff/menuselect.wav"))
                selectx = selectx - 64
                state = state - 1
            end
      end

        if Misc.isPausedByLua() then -- if the cursor is on the far right or left, it will loop around
            if selectx < 30 then
                selectx = 30 + 320
            end 
        end
        if Misc.isPausedByLua() then
            if selectx > 30 + 320 then
                selectx = 30
            end 
        end
        if Misc.isPausedByLua() then
            if state > 6 then
                state = 1
            end
        end
        if Misc.isPausedByLua() then
            if state < 1 then
                state = 6
            end
        end
    end
end

return inventory


