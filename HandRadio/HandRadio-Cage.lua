modem=peripheral.find('modem')
sensor=peripheral.find('sensor')
team={}
points=0
players={}
 
file=fs.open('color','r')
couleur=tonumber(file.readLine())
file.close()
stop=true
if couleur==colors.blue then
    col='blue'
else
    col='red'
end
 
function isIn(element,table)            --return a boolean: 'is element in table'
  for key,val in pairs(table) do
    if val==element then
      return true
    end
  end
  return false
end
 
 
function waitForPoint()
    while true do
        os.pullEvent('redstone')
        if redstone.getInput('back') and not(stop) then
            But=true
            print('but marque?')
            players=sensor.getTargets()
            for k,v in pairs(players) do
                if not(isIn(k,team[col])) and v.IsPlayer then
                    position=v.Position
                    if position.X<7.95 and position.X>-5.95 and math.abs(position.Z)<5.95 then
                        But=false
                        print('but annule')
                    end
                end
            end
            if But then
                print('but marque')
                points=points+1
                modem.transmit(colors.white,couleur,points)
            end
        end
    end
end
 
function waitForcommand()
    modem.open(couleur)
    while true do
        ev,side,freq,repFreq,mess,dist=os.pullEvent('modem_message')
        if repFreq==colors.white then
            if mess=='Resume' then
                stop=false
            elseif mess=='Pause'    then
                stop=true
            elseif mess=='Reset' then
                points=0
                team={}
                stop=true
            elseif type(mess)=='table' then
                team=mess
            end
        end
    end
end
parallel.waitForAll(waitForPoint, waitForcommand)