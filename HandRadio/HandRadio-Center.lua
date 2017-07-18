perNames=peripheral.getNames()
periph={}
for i=1,#perNames do
    if periph[peripheral.getType(perNames[i])] then
        periph[peripheral.getType(perNames[i])][#periph[peripheral.getType(perNames[i])]+1]=peripheral.wrap(perNames[i])
    else
        periph[peripheral.getType(perNames[i])]={peripheral.wrap(perNames[i])}
    end
end

reds={
    dizRed=peripheral.wrap('hb_interupteur_0'),
    unitRed=peripheral.wrap('hb_interupteur_1'),
    dizBlue=peripheral.wrap('hb_interupteur_2'),
    unitBlue=peripheral.wrap('hb_interupteur_3'),
    dizMin=peripheral.wrap('hb_interupteur_4'),
    unitMin=peripheral.wrap('hb_interupteur_5'),
    dizSec=peripheral.wrap('hb_interupteur_6'),
    unitSec=peripheral.wrap('hb_interupteur_7')
}
cageSensor={
    redSouth=peripheral.wrap('openperipheral_sensor_4'),
    redNorth=peripheral.wrap('openperipheral_sensor_3'),
    blueSouth=peripheral.wrap('openperipheral_sensor_0'),
    blueNorth=peripheral.wrap('openperipheral_sensor_2')
}
modem=periph.modem[1]
chat=periph.chatBox[1]
gameInProgress=false
teams={blue={},red={},arbitre={}}
score={blue=0,red=0}
os.loadAPI('ahb')
defaultTempsPartie=600
for k,monitor in pairs(periph.monitor) do
    monitor.setTextScale(2)
    x,y=monitor.getSize()
    periph.monitor[k].blueWin=window.create(monitor,1,4,math.floor(x/2-0.5),y-3,true)
    periph.monitor[k].separateWindow=window.create(monitor,math.floor(x/2+0.5),4,1,y-3,true)
    periph.monitor[k].redWin=window.create(monitor,math.floor(x/2+1.5),4,x-math.floor(x/2+1.5),y-3,true)
end

function minSec(temps)
    if type(temps)=='table' then
        return temps
    else
        return (temps-temps%60)/60,temps%60
    end
end

function getCommandsBeforeGame()
    while true do
        ev,play,args=os.pullEvent('command')
        for i=1,#args do
            args[i]=string.lower(args[i])
            if args[si]=='bleue' or args[i]=='bleu' then
                args[i]='bleu'
            end
        end
        if #args>1 and args[1]=='stade' then
            if #args>2 and args[2]=='bleu' and args[3]=='join' then
                if ahb.isIn(play,teams.blue) then
                    table.remove(teams.blue,ahb.isIn(play,teams.blue))
                elseif ahb.isIn(play,teams.red) then
                    table.remove(teams.red,ahb.isIn(play,teams.red))
                elseif ahb.isIn(play,teams.arbitre) then
                    table.remove(teams.arbitre,ahb.isIn(play,teams.arbitre))
                end
                table.insert(teams.blue,play)
                updateTeams()
            elseif #args>2 and args[2]=='rouge' and args[3]=='join' then
                if ahb.isIn(play,teams.blue) then
                    table.remove(teams.blue,ahb.isIn(play,teams.blue))
                elseif ahb.isIn(play,teams.red) then
                    table.remove(teams.red,ahb.isIn(play,teams.red))
                elseif ahb.isIn(play,teams.arbitre) then
                    table.remove(teams.arbitre,ahb.isIn(play,teams.arbitre))
                end
                table.insert(teams.red,play)
                updateTeams()              
            elseif #args>2 and args[2]=='arbitre' and args[3]=='join' then
                if ahb.isIn(play,teams.blue) then
                    table.remove(teams.blue,ahb.isIn(play,teams.blue))
                elseif ahb.isIn(play,teams.red) then
                    table.remove(teams.red,ahb.isIn(play,teams.red))
                elseif ahb.isIn(play,teams.arbitre) then
                    table.remove(teams.arbitre,ahb.isIn(play,teams.arbitre))
                end
                table.insert(teams.arbitre,play)
                updateTeams()
            elseif args[2]=='quit' then
                if ahb.isIn(play,teams.blue) then
                    table.remove(teams.blue,ahb.isIn(play,teams.blue))
                elseif ahb.isIn(play,teams.red) then
                    table.remove(teams.red,ahb.isIn(play,teams.red))
                elseif ahb.isIn(play,teams.arbitre) then
                    table.remove(teams.arbitre,ahb.isIn(play,teams.arbitre))
                end
                updateTeams()
            elseif args[2]=='go' and ahb.isIn(play,teams.arbitre) then
                if #args>2 and tonumber(args[3]) then
                    tempsPartie=tonumber(args[3])
                end
                return true
            end
        end
    end
end
 
function updateTeams()
    for k,monitor in pairs(periph.monitor) do
        monitor.clear()
        ahb.center('Equipes:',monitor,1)
        if #teams.arbitre>0 then
            ahb.centerBlit(' Arbitre: '..teams.arbitre[1]..' ',monitor,2,colors.black,colors.pink)
        end
        for i=1,y-3 do
            monitor.separateWindow.setCursorPos(1,i)
            monitor.separateWindow.write('|')
        end
        for i=1,#teams.blue do
            if i<=y-3 then
                ahb.centerBlit(' '..teams.blue[i],monitor.blueWin,i,colors.black,colors.blue)
            end
        end
        for i=1,#teams.red do
            if i<=y-3 then
                ahb.centerBlit(' '..teams.red[i]..' ',monitor.redWin,i,colors.black,colors.red)
            end
        end
    end
end
 
function getCommandsInGame()
    while true do
        ev,play,args=os.pullEvent('command')
        for i=1,#args do
            args[i]=string.lower(args[i])
            if args[i]=='bleue' or args[i]=='bleu' then
                args[i]='bleu'
            end
        end
        if ahb.isIn(play,teams.arbitre) then
            if args[1]=='pause' then
                pause=true
                print('game paused')
            elseif args[1]=='resume' then
                pause=false
                lastTimer=os.startTimer(1)
                print('game resumed')
            elseif args[1]=='reset' then
                return false
            elseif args[1]=='end' then
                tempsPartie=0
                updateTime()
            elseif args[1]=='points' and #args>2 and args[2]=='rouge' and tonumber(args[3]) then
                score.red=score.red+tonumber(args[3])
            elseif args[1]=='points' and #args>2 and args[2]=='bleu' and tonumber(args[3]) then
                score.blue=score.blue+tonumber(args[3])
            end
        end
    end
end

function scoreTracker()
    while true do
        ev=os.pullEvent('redstone')
        if redstone.getBundledInput('right')==colors.red and not(pause) then
            bool=true
            for k,v in pairs(cageSensor.redSouth.getPlayers()) do
                if not(v.name==teams.arbitre[1]) and (ahb.isIn(v.name,teams.red) or ahb.isIn(v.name,teams.blue)) then
                    local infoPlayer=cageSensor.redSouth.getPlayerByName(v.name).all()
                    if infoPlayer.position.x<=3.0125 and infoPlayer.position.x>=-2.7 and infoPlayer.position.z<=4.0125 then
                        bool=false
                    end
                end
            end
            for k,v in pairs(cageSensor.redNorth.getPlayers()) do
                if not(v.name==teams.arbitre[1]) and (ahb.isIn(v.name,teams.red) or ahb.isIn(v.name,teams.blue)) then
                    local infoPlayer=cageSensor.redNorth.getPlayerByName(v.name).all()
                    if infoPlayer.position.x<=3.0125 and infoPlayer.position.x>=-2.7 and infoPlayer.position.z>=-3.0125 then
                        bool=false
                    end
                end
            end
             if bool then
                score.blue=score.blue+1
            end
        elseif redstone.getBundledInput('right')==colors.blue and not(pause)then
            for k,v in pairs(cageSensor.blueSouth.getPlayers()) do
                if not(v.name==teams.arbitre[1]) and (ahb.isIn(v.name,teams.red) or ahb.isIn(v.name,teams.blue)) then
                    local infoPlayer=cageSensor.blueSouth.getPlayerByName(v.name).all()
                    if infoPlayer.position.x<=3.7 and infoPlayer.position.x>=-2.0125 and infoPlayer.position.z<=4.0125 then
                        bool=false
                    end
                end
            end
            for k,v in pairs(cageSensor.blueNorth.getPlayers()) do
                if not(v.name==teams.arbitre[1]) and (ahb.isIn(v.name,teams.red) or ahb.isIn(v.name,teams.blue)) then
                    local infoPlayer=cageSensor.blueNorth.getPlayerByName(v.name).all()
                    if infoPlayer.position.x<=3.7 and infoPlayer.position.x>=-2.0125 and infoPlayer.position.z>=-3.0125 then
                        bool=false
                    end
                end
            end
            if bool then
                score.red=score.red+1
            end
        end
        updatePoints(score.blue,score.red)
        os.sleep(5)
    end
end

function timer()
    lastTimer=os.startTimer(1)
    while tempsPartie>0 do
        ev, value=os.pullEvent('timer')
        if value==lastTimer and not(pause) then
            tempsPartie=tempsPartie-1
            print(tempsPartie)
            updateTime(minSec(tempsPartie))
            lastTimer=os.startTimer(1)
        end
    end
end

function updatePoints(pointsBleus,pointsRouges)
    reds.dizBlue.set(math.floor(pointsBleus/10))
    reds.unitBlue.set(pointsBleus%10)
    reds.dizRed.set(math.floor(pointsRouges/10))
    reds.unitRed.set(pointsRouges%10)
end
function updateTime(minutes,seconds)
    reds.dizMin.set(math.floor(minutes/10))
    reds.unitMin.set(minutes%10)
    reds.dizSec.set(math.floor(seconds/10))
    reds.unitRed.set(seconds%10)
end
 
 
 
while true do
    tempsPartie=defaultTempsPartie
    getCommandsBeforeGame()
    score={blue=0,red=0}
    updatePoints(score.blue,score.red)
    updateTime(minSec(tempsPartie))
    updateTeams()
    stopped=parallel.waitForAny(getCommandsInGame, scoreTracker, timer)
    if stopped==1 then
        teams={blue={},red={},arbitre={}}
        score={blue=0,red=0}
        updatePoints()
        updateTeams()
    else
        if score.blue>score.red then
            winner='Bleue'
        elseif score.red>score.blue then
            winner='Rouge'
        else
            winner='egalite'
        end
        if winner~='egalite' then
            chat.say("L'equipe "..winner.." gagne la partie!",128,true,'RadioHand')
        else
            chat.say("Il y a egalite!",128,true,'RadioHand')
        end
        teams={blue={},red={},arbitre={}}
        score={blue=0,red=0}
    end
end