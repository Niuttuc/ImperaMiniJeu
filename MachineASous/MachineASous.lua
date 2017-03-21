chest=peripheral.wrap("back") -- Chest de laine
chestInsert=peripheral.wrap("front") -- Chest insert
chestInsertSortie="WEST"
chestCoffre=peripheral.wrap("right")
chestCoffreSortie="UP"
chatBox=peripheral.find("chatBox")
 
noteBlock=peripheral.find("noteBlock")
ecran=peripheral.find("monitor")
arriveRedstone="bottom"
credit=0
 
file=fs.open("gagnotte","r")
gagnotte=tonumber(textutils.unserialize(file.readAll()))
file.close()
 
statutActuelLanc=redstone.testBundledInput(arriveRedstone,colors.brown)
 
nMax=8
 
cote={"WEST","SOUTH","EAST"}
anim={
    {0.05,0.05,0.05},
    {0.05,0.05,0.05},
    {0.1,0.05,0.05},
    {0.2,0.05,0.05},
    {0  ,0.2,0.1},
    {0  ,0.3,0.1},
    {0  ,0  ,0.2}
}
couleur={14,1,4,5,13,11,9,10}
-- "north", "south"
 
 
 
redstone.setOutput("top", false)
function envoi(choix,cote)
    chest.condenseItems()
    stacks=chest.getAllStacks()
    table.foreach(stacks,function(i,data)
        info=data.basic()
        if info.dmg==couleur[choix+1] then
            chest.pushItem(cote,i,1)
            redstone.setOutput("top", true)
            os.sleep(0.08)
            redstone.setOutput("top", false)
            return
        end
    end)
end
function actuEcran()
    ecran.setTextColor(colors.white)
    ecran.setBackgroundColor(colors.yellow)
    ecran.clear()
    ecran.setTextScale(2)
    affichage=tostring(gagnotte);
 
    ecran.setCursorPos(1+math.floor((14-string.len(affichage))/2),1)
    ecran.write(affichage)
 
    ecran.setCursorPos(3,2)
    ecran.write(tostring(math.floor(credit/2))..' credits')
end
function ecranCredit2(t)
    if t then
        ecran.setTextColor(colors.white)
        ecran.setBackgroundColor(colors.yellow)
    else
        ecran.setTextColor(colors.yellow)
        ecran.setBackgroundColor(colors.white)
    end
    ecran.clear()
    ecran.setTextScale(2)
    ecran.setCursorPos(6,1)
    ecran.write("GAIN")
    ecran.setCursorPos(3,2)
    ecran.write("+2 credits")
end
function ecranJackpot(t)
    if t then
        ecran.setTextColor(colors.white)
        ecran.setBackgroundColor(colors.orange)
    else
        ecran.setTextColor(colors.white)
        ecran.setBackgroundColor(colors.yellow)
    end
    ecran.clear()
    ecran.setTextScale(2)
    ecran.setCursorPos(3,1)
    ecran.write("JACKPOT")
    affichage=tostring(gagnotte);
    ecran.setCursorPos(1+math.floor((14-string.len(affichage))/2),2)
    ecran.write(affichage)
end
 
actuEcran()
jeuActif=false
function lancement()           
    tirage={math.random(nMax-1),math.random(nMax-1),math.random(nMax-1)}
    --tirage={4,2,1}
 
    table.foreach(anim,function(u,ligne)
        table.foreach(ligne,function(o,dure)
            if dure~=0 then
                os.sleep(dure)
                tirage[o]=tirage[o]+1
                if tirage[o]==nMax then tirage[o]=0 end
                envoi(tirage[o],cote[o])           
            end
        end)
    end)
    if tirage[1]==tirage[2] and tirage[2]==tirage[3] then
        if tirage[1]==0 then
            ecranJackpot(true)
            noteBlock.playNote(0,0)
            os.sleep(0.5)
           
            gagnotteD=gagnotte
            chestCoffre.condenseItems()
            stacks=chestCoffre.getAllStacks()
            table.foreach(stacks,function(i,data)
                if gagnotteD>0 then
                    info=data.basic()
                    if gagnotteD>info.qty then
                        chestCoffre.pushItem(chestCoffreSortie,i,info.qty)
                        gagnotteD=gagnotteD-info.qty
                    else
                        chestCoffre.pushItem(chestCoffreSortie,i,gagnotteD)
                        gagnotteD=0
                    end
                end
            end)
            for i = 1,40 do
                ecranJackpot(false)
                noteBlock.playNote(0,3)
                os.sleep(0.15)
                ecranJackpot(false)
                noteBlock.playNote(0,0)
                ecranJackpot(true)
                os.sleep(0.15)
            end
            file=fs.open("gagnotteGain","w")
            file.write(tostring(gagnotte))
            file.close()
            gagnotte=100
            file=fs.open("gagnotte","w")
            file.write(tostring(100))
            file.close()
        else
            ecranCredit2(true)
            noteBlock.playNote(0,0)
            os.sleep(0.5)
            ecranCredit2(false)
            noteBlock.playNote(0,1)
            for i = 1,6 do
                os.sleep(0.1)
                ecranCredit2(true)
                os.sleep(0.1)
                ecranCredit2(false)
            end
            credit=credit+4
        end
    else
        os.sleep(0.5)
        noteBlock.playNote(4,4)
        os.sleep(0.3)
        noteBlock.playNote(4,2)
    end
    actuEcran()
    jeuActif=false
end
function verifDollar()
    if redstone.testBundledInput(arriveRedstone,colors.green) then
        print("verif dollar")
        chestInsert.condenseItems()
        stacks=chestInsert.getAllStacks()
        table.foreach(stacks,function(i,data)
            info=data.basic()          
            chestInsert.pushItem(chestInsertSortie,i,info.qty)
            credit=credit+info.qty
            noteBlock.playNote(0,2)
        end)
        actuEcran()
    end
end
function verif()
    while true do
        local event = os.pullEvent("redstone")
        verifDollar()
    end
end
while true do
    local event = os.pullEvent("redstone")
    verifDollar()
    if redstone.testBundledInput(arriveRedstone,colors.brown)~=statutActuelLanc then
        statutActuelLanc=redstone.testBundledInput(arriveRedstone,colors.brown)
        if jeuActif==false then
            if credit>=2 then
                credit=credit-2
                gagnotte=gagnotte+1
                file=fs.open("gagnotte","w")
                file.write(tostring(gagnotte))
                file.close()
                actuEcran()
                jeuActif=true
                parallel.waitForAny(verif,lancement)
            else
                noteBlock.playNote(4,2)
                ecran.setTextColor(colors.white)
                ecran.setBackgroundColor(colors.red)   
                ecran.clear()
                ecran.setTextScale(2)
                ecran.setCursorPos(1,1)
                ecran.write("PAS DE CREDIT")
                ecran.setCursorPos(1,2)
                ecran.write("insert 2 coin")
            end
        end
    end
end