modem=peripheral.find('modem')
timeFlowing=false
time=0
 
 
function sec(temps)
    if type(temps)=='table' then
        return temps.minute*60+temps.seconde
    else
        return temps
    end
end
 
function minSec(temps)
    if type(temps)=='table' then
        return temps
    else
        return (temps-temps%60)/60,temps%60
    end
end
 
function updateTime(temps)
    redstone.setAnalogOutput('top', math.floor(minSec(temps).minute/10))
    redstone.setAnalogOutput('front', minSec(temps).minute%10)
    redstone.setAnalogOutput('left', math.floor(minSec(temps).seconde/10))
    redstone.setAnalogOutput('right', minSec(temps).seconde%10)
end
 
function waitCommands()
    modem.open(colors.yellow)
    while true do
        ev,side,freq,repFreq,mess,dis=os.pullEvent('modem_message')
        if type(mess)=='number' and repFreq==colors.white then
            time=mess+1
            timeFlowing=true
        elseif mess=='Pause' then
            timeFlowing=false
        elseif mess=='Resume' then
            timeFlowing=true
        elseif mess=='Reset' then
            updateTime(0)
            timeFlowing=false
            time=0
        end
    end
end
 
function timeTicking()
    while true do
        if timeFlowing then
            if time==0 then
                modem.transmit(colors.white,colors.yellow,'Time ran Out')
            elseif time>0 then
                time=time-1
                updateTime(time)
                sleep(0.9)
            end
        end
        sleep(0.1)
    end
end
 
parallel.waitForAll(waitCommands,timeTicking)