modem=peripheral.wrap("right")
joueurs={
    j1={
        ecranInfo="monitor_4",
        ecran=peripheral.wrap("monitor_4"),
        turtle=colors.cyan,
        prochain=0,
        position=0,
        direction=1
    },
    j2={
        ecranInfo="monitor_3",
        ecran=peripheral.wrap("monitor_3"),
        turtle=colors.orange,
        prochain=0,
        position=26,
        direction=-1
    }
}
modem.open(99)
function prepa(joueur)
    joueurs[joueur].fenetreBouton=window.create(joueurs[joueur].ecran, 1, 1, 20, 5)
    joueurs[joueur].fenetreBouton.setCursorPos(2,2)
    joueurs[joueur].fenetreBouton.write("1  2  3")
    joueurs[joueur].fenetreBouton.setVisible(false)
   
    joueurs[joueur].fenetreAttente=window.create(joueurs[joueur].ecran, 1, 1, 40, 5)
    joueurs[joueur].fenetreAttente.write("Attente de l'autre joueur ...")  
    joueurs[joueur].fenetreAttente.setVisible(false)
   
    joueurs[joueur].fenetreSuite=window.create(joueurs[joueur].fenetreAttente, 1, 2, 40, 5)
    joueurs[joueur].fenetreSuite.write("")
   
    joueurs[joueur].fenetreTurtle=window.create(joueurs[joueur].ecran, 1, 2, 20, 5)
    joueurs[joueur].fenetreTurtle.write("Attente turtle")
    joueurs[joueur].fenetreTurtle.setVisible(false)
   
    joueurs[joueur].fenetreGagnant=window.create(joueurs[joueur].ecran, 1, 2, 20, 5)
    joueurs[joueur].fenetreGagnant.write("VICTOIRE")
    joueurs[joueur].fenetreGagnant.setVisible(false)
   
    joueurs[joueur].fenetrePerdant=window.create(joueurs[joueur].ecran, 1, 2, 20, 5)
    joueurs[joueur].fenetrePerdant.write("  PERDU")
    joueurs[joueur].fenetrePerdant.setVisible(false)
end
 
prepa('j1')
prepa('j2')
 
while true do
   
    tour=math.random(2)
    joueurs['j1'].position=0
    joueurs['j2'].position=26
    joueurs['j1'].prochain=0
    joueurs['j2'].prochain=0
    joueurs['j1'].fenetreSuite.clear()
    joueurs['j2'].fenetreSuite.clear()
   
    joueurs['j1'].ecran.setTextScale(1)
    joueurs['j1'].fenetreTurtle.setVisible(true)
   
    joueurs['j2'].ecran.setTextScale(1)
    joueurs['j2'].fenetreTurtle.setVisible(true)
   
    modem.transmit(joueurs['j1'].turtle, 99,-1)
    modem.transmit(joueurs['j2'].turtle, 99,-1)
    local event, modemSide, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")
    local event, modemSide, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")
   
    joueurs['j1'].fenetreTurtle.setVisible(false)  
    joueurs['j2'].fenetreTurtle.setVisible(false)
   
    partie=true
    while partie do
        print("Tour "..tour)
        if tour%2==0 then
            p1="j1"
            p2="j2"
        else
            p1="j2"
            p2="j1"
        end
       
        joueurs[p1].fenetreBouton.setVisible(false)
        joueurs[p1].ecran.setTextScale(0.5)
        joueurs[p1].fenetreAttente.setVisible(true)
       
        joueurs[p2].fenetreAttente.setVisible(false)
        joueurs[p2].ecran.setTextScale(2)
        joueurs[p2].fenetreBouton.setVisible(true)
       
        info=true
        while info do
            event, side, xPos, yPos = os.pullEvent("monitor_touch")
            if side==joueurs[p2].ecranInfo then
                info=false
                joueurs[p2].prochain=(math.ceil(xPos/3))
                joueurs[p2].fenetreSuite.clear()
                joueurs[p2].fenetreSuite.setCursorPos(1,1)
                joueurs[p2].fenetreSuite.write('Prochain coup : '..joueurs[p2].prochain)
               
            end    
        end
       
        futurPosition=joueurs[p2].position+(joueurs[p2].prochain*joueurs[p2].direction)
       
        if joueurs[p2].direction==-1 then
            if joueurs[p1].position>=futurPosition then
                partie=false
            end
        else
            if joueurs[p1].position<=futurPosition then
                partie=false
            end
        end
        joueurs[p2].position=futurPosition
       
        if not(joueurs[p1].prochain==0) then
            joueurs[p1].fenetreAttente.setVisible(false)
            joueurs[p2].fenetreBouton.setVisible(false)
           
            modem.transmit(joueurs[p1].turtle, 99,joueurs[p1].prochain)
            joueurs[p1].prochain=0     
       
            joueurs[p1].ecran.setTextScale(1)
            joueurs[p1].fenetreTurtle.setVisible(true)
           
            joueurs[p2].ecran.setTextScale(1)
            joueurs[p2].fenetreTurtle.setVisible(true)
           
            local event, modemSide, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")
           
            joueurs['j1'].fenetreTurtle.setVisible(false)  
            joueurs['j2'].fenetreTurtle.setVisible(false)
        end
       
        tour=tour+1
       
        if partie==false then
            modem.transmit(joueurs[p2].turtle, 99,-2)
           
            joueurs[p2].ecran.setTextScale(2)
            joueurs[p2].fenetrePerdant.setVisible(true)
            joueurs[p1].ecran.setTextScale(2)
            joueurs[p1].fenetreGagnant.setVisible(true)
        end
   
    end
    event, side, xPos, yPos = os.pullEvent("monitor_touch")
    joueurs[p2].fenetrePerdant.setVisible(false)
    joueurs[p1].fenetreGagnant.setVisible(false)
end