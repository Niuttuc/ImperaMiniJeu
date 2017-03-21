modem=peripheral.find("modem")
monitor=peripheral.find('monitor')
 
file=fs.open("leCote","r")
leCote=file.readLine()
file.close()
print("Cote "..leCote)
 
modem.open(2)
monitor.setTextScale(1.5)
monitor.setBackgroundColor(colors.black)
 
function info()
    monitor.setTextScale(1)
    monitor.setBackgroundColor(colors.black)
    monitor.clear()
    monitor.setCursorPos(1,1)
    monitor.write("\\HBjoin rejoindre la partie")
    monitor.setCursorPos(1,2)
    monitor.write("\\HBquit rejoindre la partie")
    monitor.setCursorPos(1,3)
    monitor.write("\\HBgo lancer la partie")
    monitor.setCursorPos(1,4)
    monitor.write("\\HBreset mise à zero")
end
info()
 
while true do
    local event, modemSide, senderChannel,
      replyChannel, message, senderDistance = os.pullEvent("modem_message")
     
    datas=textutils.unserialize(message)
    print('>'..datas.msg)
    if datas.msg=="1" or datas.msg=="2" or datas.msg=="3" or datas.msg=="GO" then
        monitor.setBackgroundColor(colors.black)
        monitor.clear()
        monitor.setTextScale(5)
        monitor.setCursorPos(3,1)
        monitor.write(datas.msg)
        -- info
        -- gagnant
    elseif datas.msg=="scoreboard" then
       
        i=2
        monitor.setBackgroundColor(colors.black)
        monitor.setTextColor(colors.yellow)
        monitor.clear()
        monitor.setTextScale(1.5)
        monitor.setCursorPos(2,1)
        monitor.write("Meilleurs scores")      
        table.foreach(datas.score,function(cote,data)
            if data.joueur~='' then
                monitor.setCursorPos(1,i)  
                monitor.write(data.nom.."                                       ")
                monitor.setCursorPos(16,i)
                monitor.write(tostring(data.pt))
                i=i+1
            end
        end)
    else
        i=4
        monitor.setBackgroundColor(colors.black)
        monitor.clear()
        monitor.setTextScale(1.5)
        gagnant=""
        table.foreach(datas.score,function(cote,data)
            if data.joueur~='' then
                monitor.setCursorPos(1,i)
                if data.cote==leCote then
                    monitor.setBackgroundColor(colors.yellow)
                    monitor.setTextColor(colors.white)
                else
                    monitor.setBackgroundColor(colors.black)
                    monitor.setTextColor(colors.yellow)
                end    
                monitor.write(data.joueur.."                                     ")
                monitor.setCursorPos(16,i)
                monitor.write(tostring(data.pt))
                i=i+1
            end
        end)
        if datas.msg=="gagnant" then
            monitor.setCursorPos(2,i)
            monitor.write("Gagnant : "..datas.score[1].joueur)
        else
            if i~=60 and i~=0 then
                monitor.setCursorPos(5,i)
                monitor.write(tostring(datas.temps))
            end
        end
        if i==1 then
            info()
        end
    end
end