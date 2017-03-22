modem=peripheral.find('modem')
chat=peripheral.find('chatBox')
speak=peripheral.find('speaker')
gameInProgress=false
teams={blue={},red={},arbitre={}}
score={blue=0,red=0}
 
 
defaultTempsPartie=600
 
 
 
 
function isIn(element,table)            --return a boolean: 'is element in table'
  for key,val in pairs(table) do
    if val==element then
      return key
    end
  end
  return false
end
 
 
function getCommandsBeforeGame()
    while true do
        ev,play,args=os.pullEvent('command')
        for i=1,#args do
            args[i]=string.lower(args[i])
            if args[i]=='bleue' or args[i]=='bleu' then
                args[i]='bleu'
            end
        end
        if #args>1 and args[1]=='stade' then
            if #args>2 and args[2]=='bleu' and args[3]=='join' then
                if isIn(play,teams.blue) then
                    table.remove(teams.blue,isIn(play,teams.blue))
                elseif isIn(play,teams.red) then
                    table.remove(teams.red,isIn(play,teams.red))
                elseif isIn(play,teams.arbitre) then
                    table.remove(teams.arbitre,isIn(play,teams.arbitre))
                end
                table.insert(teams.blue,play)
                updateTeams()
            elseif #args>2 and args[2]=='rouge' and args[3]=='join' then
                if isIn(play,teams.blue) then
                    table.remove(teams.blue,isIn(play,teams.blue))
                elseif isIn(play,teams.red) then
                    table.remove(teams.red,isIn(play,teams.red))
                elseif isIn(play,teams.arbitre) then
                    table.remove(teams.arbitre,isIn(play,teams.arbitre))
                end
                table.insert(teams.red,play)
                updateTeams()              
            elseif #args>2 and args[2]=='arbitre' and args[3]=='join' then
                if isIn(play,teams.blue) then
                    table.remove(teams.blue,isIn(play,teams.blue))
                elseif isIn(play,teams.red) then
                    table.remove(teams.red,isIn(play,teams.red))
                elseif isIn(play,teams.arbitre) then
                    table.remove(teams.arbitre,isIn(play,teams.arbitre))
                end
                table.insert(teams.arbitre,play)
                updateTeams()
            elseif args[2]=='quit' then
                if isIn(play,teams.blue) then
                    table.remove(teams.blue,isIn(play,teams.blue))
                elseif isIn(play,teams.red) then
                    table.remove(teams.red,isIn(play,teams.red))
                elseif isIn(play,teams.arbitre) then
                    table.remove(teams.arbitre,isIn(play,teams.arbitre))
                end
                updateTeams()
            elseif args[2]=='go' and isIn(play,teams.arbitre) then
                if #args>2 and tonumber(args[3]) then
                    tempsPartie=tonumber(args[3])
                end
                return true
            end
        end
    end
end
 
function updateTeams()
    modem.transmit(colors.black,colors.white,teams)
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
        if isIn(play,teams.arbitre) then
            if args[1]=='pause' then
                modem.transmit(colors.yellow, colors.white,'Pause')
                modem.transmit(colors.red, colors.white,'Pause')
                modem.transmit(colors.blue, colors.white,'Pause')
                print('game paused')
            elseif args[1]=='resume' then
                modem.transmit(colors.yellow,colors.white,'Resume')
                modem.transmit(colors.red, colors.white,'Resume')
                modem.transmit(colors.blue, colors.white,'Resume')
                print('game resumed')
            elseif args[1]=='reset' then
                return false
            elseif args[1]=='end' then
                modem.transmit(colors.yellow, colors.white, 0)
            elseif args[1]=='points' and #args>2 and args[2]=='rouge' and tonumber(args[3]) then
                score.red=score.red+tonumber(args[3])
            elseif args[1]=='points' and #args>2 and args[2]=='bleu' and tonumber(args[3]) then
                score.blue=score.blue+tonumber(args[3])
            end
        end
    end
end
 
function updateScore()
    modem.transmit(colors.purple,colors.white,score)
end
function getMessages()
    modem.open(colors.white)
    while true do
        ev,side,freq,repFreq,mess,dis=os.pullEvent('modem_message')
        if type(mess)=='number' and repFreq==colors.blue then
            score.red=mess
            updateScore()
        elseif type(mess)=='number' and repFreq==colors.red then   
            score.blue=mess
            updateScore()
        elseif mess=='Time ran Out' and repFreq==colors.yellow then
            return true
        end
    end
end
 
 
 
while true do
    tempsPartie=defaultTempsPartie
    getCommandsBeforeGame()
    score={blue=0,red=0}
    updateScore()
    modem.transmit(colors.yellow, colors.white, tempsPartie)
    modem.transmit(colors.red, colors.white,'Resume')
    modem.transmit(colors.blue, colors.white,'Resume')
    modem.transmit(colors.red, colors.white,teams)
    modem.transmit(colors.blue, colors.white,teams)
    stopped=parallel.waitForAny(getCommandsInGame, getMessages)
    if stopped==1 then
        modem.transmit(colors.yellow, colors.white,'Reset')
        modem.transmit(colors.red, colors.white,'Reset')
        modem.transmit(colors.blue, colors.white,'Reset')
        teams={blue={},red={},arbitre={}}
        score={blue=0,red=0}
        updateScore()
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
            if speak then
                speak.speak("L'equipe "..winner.." gagne la partie!",128,'fr',false)
            end
        else
            chat.say("Il y a egalite!",128,true,'RadioHand')
            if speak then
                speak.speak("Il y a egalitez!",128,'fr',false)
            end
        end
        teams={blue={},red={},arbitre={}}
        score={blue=0,red=0}
    end
end