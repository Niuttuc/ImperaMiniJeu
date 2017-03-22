compass=peripheral.find('compass')
modem=peripheral.find('modem')
local card={north=1,east=2,south=3,west=4}
homeBlock="EnderStorage:enderChest"
 
 
local programName="TurtleGo"
local potentialConfig={{nom="sens d'avance",choices=true, possibilities={"north","south","east","west"}},{nom="couleur",choices=true,possibilities={"cyan","orange"}}}
if not(fs.exists('InstallCraft')) then
    os.run('pastebin get Byfqqd4S InstallCraft')
end
os.loadAPI('InstallCraft')
local config=InstallCraft.config(programName,potentialConfig)
 
for k,v in pairs(card) do                           --On calcule les directions qui nous manque
    if math.abs(v-card[config["sens d'avance"]])==2 then
        dirRecule=k
    end
end
 
function rotateToDirection(dir)                     --Tourne, tourne, Turtle
    if (card[compass.getFacing()]-card[dir])%4==1 then
        turtle.turnLeft()
    elseif (card[compass.getFacing()]-card[dir])%4==2 then
        turtle.turnLeft()
        turtle.turnLeft()
    elseif (card[compass.getFacing()]-card[dir])%4==3 then
        turtle.turnRight()
    end
end
 
function goHome()
    rotateToDirection(dirRecule)
    bool,block=turtle.inspectDown()
    while not(block.name==homeBlock) do
        turtle.forward()
        bool,block=turtle.inspectDown()
    end
    rotateToDirection(config["sens d'avance"])
    while (turtle.getFuelLimit()-turtle.getFuelLevel())>80 do
        turtle.suckDown(math.min(math.floor((turtle.getFuelLimit()-turtle.getFuelLevel()/80)),64))
        turtle.refuel()
    end
end
 
function waitForAnything()
    modem.open(colors[config.couleur])
    ev,side,freq,repFreq,mess,dis=os.pullEvent('modem_message')
end
 
function dance()
    while true do
        turtle.turnLeft()
    end
end
 
function waitForDANCE()
    modem.open(colors[config.couleur])
    while true do
        ev,side,freq,repFreq,mess,dis=os.pullEvent('modem_message')
        if mess==-2 then
            turtle.forward()
            turtle.forward()
            turtle.forward()
            parallel.waitForAny(dance,waitForAnything)
        end
    end
end
 
function waitForModem()
    modem.open(colors[config.couleur])
    rotateToDirection(config["sens d'avance"])
    while true do
        ev,side,freq,repFreq,mess,dis=os.pullEvent('modem_message')
        if mess==-1 then
            os.sleep(0.5)
            goHome()
            modem.transmit(repFreq, freq, "Retour a la base, Over")
        elseif mess>0 then
            for i=1,mess do
                turtle.forward()
            end
            modem.transmit(repFreq, freq, "Move done, Over")
        end
    end
end
 
while true do
    parallel.waitForAny(waitForModem,waitForDANCE)
end