monitor=peripheral.find('monitor')
modem=peripheral.find('modem')
 
monitor.setTextScale(3)
x,y=monitor.getSize()
blueWin=window.create(monitor,1,3,math.floor(x/2-0.5),y-3,true)
separateWindow=window.create(monitor,math.floor(x/2+0.5),3,1,y-3,true)
redWin=window.create(monitor,math.floor(x/2+1.5),3,x-math.floor(x/2+1.5),y-3,true)
 
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
 
function centerBlit(texte,mon,y,tx,bg)
    z=mon.getSize()
    print(z,#texte)
    if #texte>z then
        mon.setCursorPos(1,y)
        mon.blit(string.sub(texte,1,z-3)..'...',string.sub(tx,1,z),string.sub(bg,1,z))
    else
        mon.setCursorPos(math.floor(z/2-#texte/2+0.5),y)
        print(texte)
        mon.blit(texte,tx,bg)
    end
end
 
function waitForCommands()
    modem.open(colors.black)
    while true do
        ev,side,freq,repFreq,mess,dist=os.pullEvent('modem_message')
        if repFreq==colors.white and type(mess)=='table' then
            teams=mess
            monitor.clear()
            center('Equipes:',monitor,1)
            if teams.arbitre[1] then
                centerBlit(' Arbitre: '..teams.arbitre[1]..' ',monitor,2,string.rep('f',#('Arbitre: '..teams.arbitre[1])+2),string.rep('2',#('Arbitre: '..teams.arbitre[1])+2))
            end
            for i=1,y-3 do
                separateWindow.setCursorPos(1,i)
                separateWindow.write('|')
            end
            for i=1,#teams.blue do
                if i<=y-3 then
                    centerBlit(teams.blue[i],blueWin,i,string.rep('f',#teams.blue[i]),string.rep('3',#teams.blue[i]))
                end
            end
            for i=1,#teams.red do
                if i<=y-3 then
                    centerBlit(' '..teams.red[i]..' ',redWin,i,string.rep('f',#teams.red[i]+2),string.rep('e',#teams.red[i]+2))
                end
            end
 
        end
    end
end
 
 
waitForCommands()