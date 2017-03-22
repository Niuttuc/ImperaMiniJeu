sensor=peripheral.find("sensor")
noteBlock=peripheral.find("noteBlock")
modem=peripheral.find("modem")
chatBox=peripheral.find("chatBox")
coteRedstonne="back"
 
payant=true
modem.open(1)
 
file=fs.open("scoreboard","r")
scoreboard=textutils.unserialize(file.readAll())
file.close()
 
redstone.setOutput(coteRedstonne, false)
 
config={
    Ypoint=-7,
    note={
        ZM=1,
        ZP=3,
        XM=5,
        XP=7
    }
}
 
score={
    ZM={joueur="",pt=0,cote='ZM'},
    ZP={joueur="",pt=0,cote='ZP'},
    XM={joueur="",pt=0,cote='XM'},
    XP={joueur="",pt=0,cote='XP'}
}
enLigne=true
joueursNb=0
poulePret={}
temps=60
 
function addJoueur(coteA,nomA)
    if score[coteA].joueur=="" then
        joueursNb=joueursNb+1
    end
    score[coteA].joueur=nomA   
    listeJoueur=""
    table.foreach(score,function(cote,data)
        if data.joueur~="" then
            if listeJoueur~="" then
                listeJoueur=listeJoueur..", "
            end
            listeJoueur=listeJoueur..data.joueur
        end
    end)
    actuEcran("")
end
function reset()
    score={
        ZM={joueur="",pt=0,cote='ZM'},
        ZP={joueur="",pt=0,cote='ZP'},
        XM={joueur="",pt=0,cote='XM'},
        XP={joueur="",pt=0,cote='XP'}
    }
    joueursNb=0
    actuEcran("scoreboard")
end
function actuEcran(msg)
    scoreTrie={}
    if msg=="1" or msg=="2" or msg=="3" or msg=="GO" then
        data=textutils.serialize({msg=msg})
    elseif msg=="scoreboard" then
        table.foreach(scoreboard,function(nom,pt)
            table.insert(scoreTrie,pt)
        end)
        table.sort(scoreTrie, function(a,b) return a>b end)  
        scoreTable={}
        derPt=-1
        table.foreach(scoreTrie,function(a,pts)
            if derPt~=pts then
                derPt=pts
                table.foreach(scoreboard,function(nom,pt)
                    if pt==pts then
                        table.insert(scoreTable,{nom=nom,pt=pt})
                    end
                end)
            end
        end)
        data=textutils.serialize({score=scoreTable,msg=msg,temps=""})
    else
        table.foreach(score,function(cote,data)
            table.insert(scoreTrie,data.pt)
        end)
        table.sort(scoreTrie, function(a,b) return a>b end)  
        scoreTable={}
        derPt=-1
        table.foreach(scoreTrie,function(a,pt)
            if derPt~=pt then
                derPt=pt
                table.foreach(score,function(cote,data)
                    if data.pt==pt then
                        table.insert(scoreTable,data)
                    end
                end)
            end
        end)
        data=textutils.serialize({score=scoreTable,msg=msg,temps=temps})
    end
    modem.transmit(2,1,data)
end
function chatBoxFc()
    while true do
        command, player, arg = os.pullEvent("command")
        if arg[1]=='HBreset' then
            reset()
            return
        end
    end
end
function addPoind(coteA)
    score[coteA].pt=score[coteA].pt+1
    noteBlock.playNote(0,config.note[coteA])
    actuEcran("")
end
 
 
function timeFC()
    temps=60
    while temps~=0 do
        print(temps)
        os.sleep(1)
        temps=temps-1
        actuEcran("")      
    end
    enLigne=false
    os.sleep(20)
end
function jeuFc()
    print("Lancer le jeu !")   
    enLigne=true
    while enLigne do
        liste=sensor.getTargets()
        table.foreach(liste,function(id,data)
            if data.IsPlayer==false then
                if data.Position.Y<config.Ypoint then
                    if poulePret[id] then
                        poulePret[id]=false                    
                        if data.Position.Z<-3 then
                            addPoind("ZM")                 
                        elseif data.Position.Z>3 then
                            addPoind("ZP")
                        elseif data.Position.X<-3 then
                            addPoind("XM")
                        elseif data.Position.X>3 then
                            addPoind("XP")
                        end
                    end
                else
                    poulePret[id]=true
                end
            end
        end)
        os.sleep(0.5)
    end
    actuEcran("gagnant")
    table.foreach(score,function(cote,data)
        if data.joueur~="" then
            if scoreboard[data.joueur]==nil then
                scoreboard[data.joueur]=data.pt
            elseif scoreboard[data.joueur]<data.pt then
                scoreboard[data.joueur]=data.pt
            end
        end
    end)
    file=fs.open("scoreboard","w")
    file.write(textutils.serialize(scoreboard))
    file.close()
   
   
   
    print("FIN")
    score={
        ZM={joueur="",pt=0,cote='ZM'},
        ZP={joueur="",pt=0,cote='ZP'},
        XM={joueur="",pt=0,cote='XM'},
        XP={joueur="",pt=0,cote='XP'}
    }
    joueursNb=0
    return
end
os.sleep(20)
actuEcran("scoreboard")
while true do
    command, player, arg = os.pullEvent("command")
    print(player.." "..arg[1])
    if arg[1]=='HBjoin' then
        liste=sensor.getTargets()
        table.foreach(liste,function(id,data)
            if data.IsPlayer==true and id==player then
                if data.Position.Z<-4.5 then
                    addJoueur("ZM",id)                 
                elseif data.Position.Z>4.5 then
                    addJoueur("ZP",id)
                elseif data.Position.X<-4.5 then
                    addJoueur("XM",id)
                elseif data.Position.X>4.5 then
                    addJoueur("XP",id)
                else
                    chatBox.tell(player,"Vous devez etre sur un escalier")
                end
            end
        end)
    elseif arg[1]=='HBquit' then
        table.foreach(score,function(cote,data)
            if data.joueur==player then
                score[cote].joueur=""
                joueursNb=joueursNb-1
            end
        end)
        actuEcran("")
    elseif arg[1]=='HBreset' then
        reset()
    elseif arg[1]=='HBgo' then
        if joueursNb==0 then
            chatBox.tell(player,"Pas de joueur \\HBjoin quand vous etes en place")
        else
            pret=true
            if payant then
                print("Demande verif")
                modem.transmit(3,1,"verif")
                reponse=0
                retour={}
                prob=""
                while reponse~=4 do
                    local event, modemSide, senderChannel,
                        replyChannel, message, senderDistance = os.pullEvent("modem_message")
                    datas=textutils.unserialize(message)
                    print("reponse "..tostring(reponse).. " : "..datas.cote.." "..tostring(datas.argent))
                    if score[datas.cote].joueur~="" then
                        if datas.argent==false then
                            if prob~="" then
                                prob=prob..", "
                            end
                            prob=prob..score[datas.cote].joueur
                        end
                    end
                   
                    reponse=reponse+1
                end
                if prob=="" then
                    modem.transmit(3,1,"payer")
                    pret=true
                else
                    chatBox.tell(player,"Le(s) joueur(s) suivant non pas paye : "..prob)
                    pret=false
                end
            end
            if pret then
                print("Prepa")
                redstone.setOutput(coteRedstonne, true)
                actuEcran("3")
                noteBlock.playNote(4,1) --3
                os.sleep(1)
                actuEcran("2")
                noteBlock.playNote(4,3) --2
                os.sleep(1)
                actuEcran("1")
                noteBlock.playNote(4,5) --1
                os.sleep(1)        
               
                noteBlock.playNote(4,7)
                os.sleep(0.2)
                noteBlock.playNote(4,7)
                os.sleep(0.2)
                noteBlock.playNote(4,7)    
                actuEcran("GO")    
                print("Lancer le jeu")
                parallel.waitForAny(chatBoxFc,jeuFc,timeFC)
                print("Fin du jeu")
                noteBlock.playNote(4,1)
                os.sleep(0.2)
                noteBlock.playNote(4,1)
                os.sleep(0.2)
                noteBlock.playNote(4,1)
                redstone.setOutput(coteRedstonne, false)
            end
        end
    end
end