displayScreen=peripheral.wrap('monitor_15')
weaponStockChest=peripheral.wrap('tile_extrautils_chestfull_name_32')
weaponFreeChest=peripheral.wrap('tile_extrautils_chestfull_name_33')
chat=peripheral.find('chatBox')
mod=peripheral.find('modem')
resultScreen=peripheral.wrap('monitor_17')
jukeBox={peripheral.wrap('bottom'),peripheral.wrap('front')}
periph=peripheral.getNames()
stockMoney=peripheral.wrap('tile_extrautils_chestfull_name_34')
rewardMoney=peripheral.wrap('tile_extrautils_chestfull_name_35')
 
 
 
computers={}
 
for i=1,#periph do
    if peripheral.getType(periph[i])=='computer' then
        computers[#computers+1]=peripheral.wrap(periph[i])
    end
end
for i=1,#computers do
    if computers[i].isOn() then
        computers[i].reboot()
    else
        computers[i].turnOn()
    end
end
if not(fs.exists('money')) then
    shell.run('pastebin get 3xk9GkFN money')
end
os.loadAPI('money')
                                                                                                                    --Vous pouvez rajouter des salles, pensez juste a rajouter les ecrans ici et ca rajoutera automatiquement les salles.
firstMonitors={peripheral.wrap('monitor_10'),peripheral.wrap('monitor_14'), bg=colors.blue,tx=colors.orange}        --ecrans de la premiere salle de tir, penser a mettre les bons numeros de peripheriques
secondMonitors={peripheral.wrap('monitor_8'),peripheral.wrap('monitor_9'), bg=colors.green,tx=colors.yellow}        --ecrans de la seconde salle de tir, penser a mettre les bons numeros de peripheriques
thirdMonitors={peripheral.wrap('monitor_12'),peripheral.wrap('monitor_13'), bg=colors.red,tx=colors.blue}           --ecrans de la troisième salle de tir, penser a mettre les bons numeros de peripheriques
 
rooms={{monitors=firstMonitors},{monitors=secondMonitors},{monitors=thirdMonitors}}     --Rajouter les salles en plus ici sous le format {x entree, x sortie, moniteurs}
 
 
 
time=20         --Temps max dans chaque salle, -1 pour désactiver. Déconseillé.
armesDispos={Arc='RedstoneArsenal:tool.bowFlux',Pistolet='NuclearCraft:pistol',Railgun='ImmersiveEngineering:railgun',Arme_Perso=''}
payant=true
prix=5
musique=true
 
 
 
running=false
i=0
timeleft=0
ret=0
 
 
------------------------------------------------------------------------------------------------------
function center(texte,mon,y)
    x=mon.getSize()
    if #texte>x then
        mon.setCursorPos(1,y)
        mon.write(string.sub(texte,1,x-3)..'...')
    else
        mon.setCursorPos(math.floor(x/2-#texte/2+0.5),y)
        mon.write(texte)
    end
end
 
 
 
function timer()
    timeLeft=time
    print('launching timer')
    if time==-1 then
        while true do
            sleep(1)
        end
    end
    for b=1,#currentMonitors do
        currentMonitors[b].setTextScale(3)
        currentMonitors[b].setTextColor(currentMonitors.tx)
        currentMonitors[b].setBackgroundColor(currentMonitors.bg)
    end
    for i=0,time do
        for b=1,#currentMonitors do
            currentMonitors[b].clear()
            center('Temps:',currentMonitors[b],2)
            center(tostring(timeLeft),currentMonitors[b],3)
            center('Score:',currentMonitors[b],4)
            center(tostring(points),currentMonitors[b],5)
        end
        actuAccueil(0,0)
        sleep(1)
        timeLeft=timeLeft-1
    end
    return 'end'
end
 
 
function actuAccueil(x,y)
    if running then
        displayScreen.clear()
        displayScreen.setTextScale(2)
        displayScreen.setCursorPos(1,2)
        displayScreen.write('Partie en cours')
        displayScreen.setCursorPos(1,3)
        displayScreen.write("fin d'ici "..tostring((#rooms-j)*20+timeLeft))
        displayScreen.setCursorPos(3,4)
        displayScreen.write("Secondes")
    else
        c=1
        blitzbg,blitztx={},{}
        for k,v in pairs(armesDispos) do
            c=c+1
            blitzbg[k],blitztx[k]=string.rep('e',#k),string.rep('f',#k)
            if y==c and x<=#k and sel~=k then
                sel=k
                file=fs.open('selection','w')
                file.write(sel)
                file.close()
 
                weaponFreeChest.condenseItems()
                weaponStockChest.condenseItems()
                free=weaponFreeChest.getAllStacks()
                for n=1,#free do
                    weaponFreeChest.pushItem('down',n)
                end
                stock=weaponStockChest.getAllStacks()
                for n=1,#stock do
                    if stock[n].basic().id==v then
                        weaponStockChest.pushItem('up',n,1)
                    end
                end
 
            end
 
        end
        if sel~='None' then
            blitzbg[sel],blitztx[sel]=string.rep('5',#sel),string.rep('f',#sel)
        end
        displayScreen.clear()
        displayScreen.setTextScale(1.5)
        displayScreen.setCursorPos(1,1)
        displayScreen.write("Choix de l'arme:")
        c=2
        for k,v in pairs(armesDispos) do
            displayScreen.setCursorPos(1,c)
            displayScreen.blit(k,blitztx[k],blitzbg[k])
            c=c+1
        end
    end
end
 
 
function  accueil()
    displayScreen.setTextScale(1.5)
    if fs.exists('selection') then
        file=fs.open('selection', 'r')
        sel=file.readLine()
        file.close()
    else
        file=fs.open('selection','w')
        sel='None'
        file.write(sel)
        file.close()
       
    end
    actuAccueil(0,0)
    while true do
        ev,side,x,y=os.pullEvent('monitor_touch')
        if side=='monitor_15' then
            actuAccueil(x,y)
        end
    end
end
 
 
function waitLaunch()
    while true do
        ev,play,args=os.pullEvent('command')
        if string.lower(args[1])=='trgtlaunch' then
            if payant then
                if money.getDetailedMoney(stockMoney)>=prix then
                    money.moveMoney(stockMoney,prix,'down')
                    print('lancement de la partie')
                    currentPlayer=play
                    return true
                else
                    chat.tell(play,'La partie est payante! Merci de mettre '..tostring(prix).. ' imperadollars dans le coffre et de recommencer!',64,true,'Tir a la cible')
                end
            else
                print('lancement de la partie')
                currentPlayer=play
                return true
            end
        end
    end
end
 
 
function pointAdjuster()
    while true do
        mod.open(42)
        ev,side,freq,repFreq,mes,dis=os.pullEvent('modem_message')
        print('j='..tostring(j),'\nmes='..tostring(tonumber(mes)))
        if repFreq==j and tonumber(mes) then
            points=points+tonumber(mes)
        end
        mod.close(42)
    end
end
 
function redstoneAdjust()
    while true do
        ev=os.pullEvent('redstone')
        before=redstone.getBundledOutput('right')
        redstone.setBundledOutput('right', colors.combine(redstone.getBundledOutput('right'),redstone.getBundledInput('right')/(2^4)))
        if before~=redstone.getBundledOutput('right') and ret~=1 then
            return true
        elseif before~=redstone.getBundledOutput('right') and ret==1 then
            ret=0
        end
    end
end
 
 
 
------------------------------------------------------------------------------------------------------
 
while true do
    redstone.setBundledOutput('right', colors.lightBlue+colors.white)
    parallel.waitForAny(waitLaunch,accueil)
    redstone.setBundledOutput('right', 0)
    displayScreen.setTextScale(2.5)
    displayScreen.clear()
    displayScreen.setCursorPos(1,1)
    displayScreen.write('Veuillez vous')
    displayScreen.setCursorPos(1,3)
    displayScreen.write('placer sur')
    displayScreen.setCursorPos(1,5)
    displayScreen.write('le tapis roulant')
    displayScreen.setCursorPos(1,7)
    displayScreen.write('La partie va')
    displayScreen.setCursorPos(1,8)
    displayScreen.write('commencer.')
    j=1
    redstoneAdjust()
    if musique and jukeBox then
        juke=math.random(#jukeBox)
        jukeBox[juke].play()
    end
    running=true
    points=0
    while j<=#rooms do
        currentRoom=rooms[j]
        currentMonitors=currentRoom.monitors
        mod.open(42)
        mod.transmit(j,42,'startRoom')
        local mes=''
        while mes~=tostring(j)..' ok' do
            ev,side,freq,repFreq,mes,dis=os.pullEvent('modem_message')
        end
        mod.close(42)
        print('launching room'..tostring(j))
        ret=parallel.waitForAny(timer, pointAdjuster,redstoneAdjust)
        mod.close(42)
        mod.open(42)
        mod.transmit(j,42,'stopRoom')
        while mes~=tostring(j)..' finished' do
            ev,side,freq,repFreq,mes,dis=os.pullEvent('modem_message')
        end
        mod.close(42)
        j=j+1
    end
    if ret==1 then
        ret=0
        redstoneAdjust()
    end
    if musique and jukeBox then
        jukeBox[juke].stop()
    end
    running=false
    mod.open(42)
    mod.transmit(24,42,{player=currentPlayer,weapon=sel,score=points})
    mes=nil
    while type(mes)~='boolean' or repFreq~=24 do
        ev,side,freq,repFreq,mes,dis=os.pullEvent('modem_message')
        if mes==true and repFreq==24 then
            resultScreen.setTextScale(2.5)
            resultScreen.clear()
            center('Vous avez',resultScreen,1)
            center(tostring(points)..' Points',resultScreen,2)
            resultScreen.setCursorPos(1,5)
            resultScreen.blit('Highscore!',string.rep('e',10),string.rep('f',10))
            rewardMoney.pullItem('down',1,1)
        elseif mes==false and repFreq==24 then
            resultScreen.setTextScale(2.5)
            resultScreen.clear()
            center('Vous avez',resultScreen,1)
            center(tostring(points)..' Points.',resultScreen,2)
        end
 
    end
    print(points)
end