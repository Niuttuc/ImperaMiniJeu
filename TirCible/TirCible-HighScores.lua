monitor=peripheral.wrap('top')
mod=peripheral.find('modem')
 
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
 
 
function displaying()
    while true do
        if not(highscores) then
            if not(fs.exists('HS')) then
                file=fs.open('HS','w')
                file.close()
            end
            file=fs.open('HS','r')
            highscores=textutils.unserialize(file.readAll())
            file.close()
            if not(highscores) then
                highscores={}
            end
        end
        for i=1,#highscores do
            monitor.clear()
            monitor.setTextScale(3)
            center('High-scores:',monitor,1)
            center(highscores[i].player,monitor,3)
            center(highscores[i].weapon,monitor,5)
            center(tostring(highscores[i].score),monitor,7)
            sleep(3)
        end
        sleep(1)
    end
end
 
 
function updating()
    while true do
        mod.open(24)
        ev,side,freq,repFreq,mes,dis=os.pullEvent('modem_message')
        mod.close(24)
        if repFreq==42 then
            add=true
            hs=false
            for i=1,#highscores do
                if highscores[i].weapon==mes.weapon then
                    add=false
                    if highscores[i].score<mes.score then
                        highscores[i].player,highscores[i].score=mes.player,mes.score
                        hs=true
                    end
                end
            end
            if add then
                highscores[#highscores+1]=mes
                hs=true
            end
            file=fs.open('HS','w')
            file.write(textutils.serialize(highscores))
            file.close()
            if hs then
                mod.transmit(42,24,true)
            else
                mod.transmit(42,24,false)
            end
 
        end
    end
end
 
 
 
 
 
 
parallel.waitForAll(displaying, updating)