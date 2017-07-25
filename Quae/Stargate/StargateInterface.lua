mon = peripheral.find("monitor")
sg = peripheral.find("stargate")
 
mon.setBackgroundColor(colors.black)
mon.clear()
maxEng = 50000
dialling = {}


xmax,ymax = mon.getSize()
homeWin=window.create(mon,1,1,xmax,ymax,false)
homeWin.setBackgroundColor(colors.black)
homeWin.clear()
homeWin.setCursorPos(x/2-5,1)
homeWin.setTextColor(colors.red)
homeWin.write(os.getComputerLabel())

powerBarWin=window.create(homeWin,xmax-1,1,2,ymax,false)
powerWin=window.create(homeWin,xmax-11,ymax,12,1,false)

localAdd=window.create(homeWin,1,ymax,16+#sg.localAddress(),1,true)
localAdd.setBackgroundColor(colors.black)
localAdd.setTextColor(colors.lightGray)
localAdd.setCursorPos(1,1)
localAdd.write("Adresse Locale:")
localAdd.setCursorPos(16, 1)
localAdd.write(sg.localAddress())

irisStateColors={[-1]=colors.red,[0]=colors.black,[1]=colors.lime}
irisWin={}
for i=-1,1 do
  irisWin[i]=window.create(homeWin,6,math.floor(ymax/3)-2,3,y/3+1,false)
  irisWin[i].setBackgroundColor(colors.lightGray)
  irisWin[i].setTextColor(irisStateColors[i])

  for  yc = 1, 10 do
    char = string.sub("   IRIS   ", yc, yc)
    irisWin[i].setCursorPos(2, yc)
    irisWin[i].clearLine()
    irisWin[i].write(char)
  end
end
comWin={}
for i=0,1 do
  comWin[i]=window.create(homeWin,math.floor(xmax/2)-5,ymax-4,5,3,false)
  comWin[i].setBackgroundColor(colors.gray*2^i)
  comWin[i].setTextColor(colors.black)
  comWin[i].clear()
  comWin[i].setCursorPos(2, 2)
  comWin[i].write("COM")
end
termWin={}
for i=0,1 do
  termWin[i]=window.create(homeWin,math.floor(xmax/2)+2,ymax-4,6,3,false)
  termWin[i].setBackgroundColor(colors.gray*2^i)
  termWin[i].setTextColor(colors.black)
  termWin[i].clear()
  termWin[i].setCursorPos(2, 2)
  termWin[i].write("TERM")
end
hystoryBtonWin=window.create(homeWin,xmax-7,math.floor(ymax/3)-2,3,ymax/3+2,false)
hystoryBtonWin.setBackgroundColor(colors.lightGray)
hystoryBtonWin.setTextColor(colors.black)
hystoryBtonWin.clear()
for  yc = 1, ymax/3+1 do
  char = string.sub("HISTORIQUE", yc, yc)
  mon.setCursorPos(2, yc)
  mon.write(char)
end

bookWin=window.create(mon,1,1,xmax,ymax,false)
historyWin=window.create(mon,1,1,xmax,ymax,false)
inputWin=window.create(mon,1,1,xmax,ymax,false)
inputWin.setTextColor(colors.red)
inputWin.setBackgroundColor(colors.black)
inputWin.setCursorPos(xmax/2-11, ymax/2-2)
inputWin.write("Entrez le nom et/ou l'adresse")
inputWin.setCursorPos(xmax/2 - 8, ymax/2-1)
inputWin.write("Dans l'ordinateur")
inputWin.setCursorPos(xmax/2 - 4, ymax/2)
inputWin.write("         ")

local function alarmSet(set)
  rs.setOutput("left", set)
  return
end
 
function drawPowerBar() -- checks power levels and writes power bar to monitor
  x,y = powerBarWin.getSize()
  engPercent = (sg.energyAvailable() / (maxEng +1)) * 100 -- returns percent
  for i = y, (y - y / 100 * engPercent), -1 do
    powerBarWin.setCursorPos(1,i)
    if i > y/4*3 then
      powerBarWin.setBackgroundColor(colors.red)
      powerBarWin.setTextColor(colors.red)
    elseif i > y/2 then
      powerBarWin.setBackgroundColor(colors.orange)
      powerBarWin.setTextColor(colors.orange)
    elseif i > y/4 then
      powerBarWin.setBackgroundColor(colors.green)
      powerBarWin.setTextColor(colors.green)
    else
      powerBarWin.setBackgroundColor(colors.lime)
      powerBarWin.setTextColor(colors.lime)
    end
    powerBarWin.clearLine()
  end
  powerWin.setBackgroundColor(colors.black)
  powerWin.setTextColor(colors.white)
  powerWin.setCursorPos(1,1)
  powerWin.write(math.floor(sg.energyAvailable() / 1000).."k SU ")
end
 
function drawIris(state) --draws button to control the Iris
  ok, result = pcall(sg.openIris)
  if ok == false then
    irisState=-1
  elseif state == true then
    sg.closeIris()
    irisState=1
  else
    irisState=0
    sg.openIris()
  end
  for  i=-1,1 do
    irisWin[i].setVisible(i==irisState)
  end
end
 
function drawLocalAddress() -- draws the address stargate being controlled
  localAdd.setVisible(true)
end
 
function drawDial() -- draws the button to access the dialing menu
  state, int = sg.stargateState()
  if state == "Idle" then
    gateState=1
  else
    gateState=0
  end
  for i=0,1 do
    comWin[i].setVisible(i==gateState)
  end
end
 
function drawTerm() -- draws the button to terminate the stargate connection to another gate
  x,y = mon.getSize()
  state, int = sg.stargateState()
  if state == "Connected" or state == "Connecting" or state == "Dialling" then
    gateState=1
  else
    gateState=0
  end
  for i=0,1 do
    termWin[i].setVisible(i==gateState)
  end
end
 
function drawHome() -- draws the home screen
  homeWin.setVisible(true)
  drawPowerBar()
  drawLocalAddress()
  status, int = sg.stargateState()
  drawHistoryButton()
  if sg.irisState()  == "Open" then
    drawIris(false)
  else
    drawIris(true)
  end
  drawDial()
  mon.setCursorBlink(false)
  drawTerm()
end
 
function drawBookmarksPage()
  bookWin.setBackgroundColor(colors.black)
  bookWin.clear()
  bookWin.setTextColor(colors.black)
  x,y = bookWin.getSize()
  for yc = 1,y-3 do
    if yc%2 == 1 then
      bookWin.setBackgroundColor(colors.red)
    else
      bookWin.setBackgroundColor(colors.gray)
    end
      bookWin.setCursorPos(1, yc)
      bookWin.clearLine(" ")
  end
  for i= 1,y do
    if i%2 == 1 then
      bookWin.setBackgroundColor(colors.red)
    else
      bookWin.setBackgroundColor(colors.gray)
    end
    if fs.exists(tostring(i)) then
      file = fs.open(tostring(i),"r")
      bookmark = textutils.unserialize(file.readAll())
      file.close()
      bookWin.setCursorPos(1,i)
      for k,v in pairs(bookmark) do
        if k == "name" then
          bookWin.write(v)
          bookWin.setCursorPos(x/2, i)
          bookWin.write(bookmark.address)
          bookWin.setCursorPos(x,i)
          bookWin.setBackgroundColor(colors.blue)
          bookWin.write("X")
        end
      end
    elseif i < y-2 then
      bookWin.setCursorPos(1, i)
      bookWin.write("Ajouter Une Adresse")
    end
  end
  bookWin.setCursorPos(x/2-2, y-1)
  bookWin.setBackgroundColor(colors.black)
  bookWin.setTextColor(colors.white)
  bookWin.write("RETOUR")
end
 
function inputPage(type)
  inputWin.setVisible(true)
  term.setTextColor(colors.red)
  term.setBackgroundColor(colors.black)
  term.setCursorBlink(true)
  term.clear()
  term.setCursorPos(1,1)
  term.write("Nom:")
  term.setCursorPos(1,2)
  nameInput = read()
  addressInput = "nil"
  term.clear()
  term.setCursorPos(1, 1)
  print("Entrez L'Adresse De La Porte")
  if type == "secEntry" then
    term.setCursorPos(1, 2)
    print("SANS TIRETS")
  end
  term.setCursorPos(1,3)
  addressInput = string.upper(read())
  newGate ={name = nameInput, address = addressInput}
  term.setCursorBlink(false)
  mon.setTextColor(colors.white)
  inputWin.setVisible(false)
  return newGate
end
 
function drawHistoryButton()
  hystoryBtonWin.setVisible(true)
end
 
function addToHistory(address)
  if fs.exists("history") then
    file = fs.open("history", "r")
    history = textutils.unserialize(file.readAll())
    file.close()
  else
    history ={}
    print("")
    print("")
    print("no history file")
  end
  if textutils.serialize(history) == false then
    history = {}
    print("")
    print("")
    print("couldn't serialize")
  end
  test = textutils.serialize(historyTable)
  --if string.len(test) < 7 then
    --history = {}
    --print("")
    --print("")
    --print("string.len too short")
  --end
  table.insert(history, 1, address)
  file = fs.open("history", "w")
  file.write(textutils.serialize(history))
  file.close()
end
 
function drawHistoryPage()
  historyWin.setBackgroundColor(colors.black)
  historyWin.clear()
  historyWin.setTextColor(colors.black)
  x,y = historyWin.getSize()
  for yc = 1,y-3 do
    if yc%2 == 1 then
      historyWin.setBackgroundColor(colors.red)
    else
      historyWin.setBackgroundColor(colors.gray)
    end
      historyWin.setCursorPos(1, yc)
      historyWin.clearLine(" ")
  end
  if fs.exists("history") then
    file = fs.open("history","r")
    historyTable = textutils.unserialize(file.readAll())
    file.close()
    test = textutils.serialize(historyTable)
    if string.len(test) > 7 then
      for k,v in pairs(historyTable) do
        if k%2 == 1 then
          historyWin.setBackgroundColor(colors.red)
        else
          historyWin.setBackgroundColor(colors.gray)
        end
        historyWin.setCursorPos(1,k)
        historyWin.write(v)
        historyWin.setCursorPos(x-9, k)
        historyWin.setBackgroundColor(colors.blue)
        historyWin.write("SAUVEGARDER")
        clickLimit = k
      end
    end
    test = {}
  end
  historyWin.setBackgroundColor(colors.black)
  for yc = y-2, y do
    for xc = 1,x do
      mon.setCursorPos(xc, yc)
      mon.write(" ")
    end
  end
  mon.setCursorPos(x/2-2, y-1)
  mon.setTextColor(colors.white)
  mon.write("RETOUR")
end
 
function historyInputPage(address)
  inputWin.setVisible(true)
  term.setBackgroundColor(colors.black)
  term.clear()
  term.setCursorPos(1,1)
  print("Entrez le nom")
  term.setCursorPos(1,2)
  nameInput = read()
  addressInput = "nil"
  newGate ={name = nameInput, address = address}
  term.clear()
  term.setCursorPos(1,1)
  return newGate
end
 
 
if fs.exists("currentSec") then -- checks to see if there's list of gates stored for security reasons
  file = fs.open("currentSec", "r")
  currentSec = file.readAll()
  file.close()
else
  currentSec = "NONE"
end
mon.setTextScale(1)
drawHome()
while true do
  event, param1, param2, param3 = os.pullEvent()
  if event == "monitor_touch" then
    x,y = mon.getSize()
    if param2 >= 6 and param2 <= 8 and param3 >= y/3-3 and param3 <= y/3*2+1 then --opens or closes the Irisy
      if sg.irisState() == "Closed" then
        ok, result = pcall(sg.openIris)
        if ok then
          drawIris(false)
        end
      else
        ok, result = pcall(sg.closeIris)
          if ok then
            drawIris(true)
          end
      end
    elseif param2 > x/2-5 and param2 <= x/2 and param3 >= y-4 and param3 <= y-2 then -- Click has opened dial menu
      status, int = sg.stargateState()
      if status == "Idle" then
        while true do
          homeWin.setVisible(false)
          drawBookmarksPage()
          event, param1, param2, param3 = os.pullEvent()
          if event == "monitor_touch" then
            if param3 >= y-2 then -- user clicked back
              bookWin.setVisible(false)
              drawHome()
              break
            elseif param2 > x-2 then -- user clicked delete on a bookmark
              if fs.exists(tostring(param3)) then
                fs.delete(tostring(param3))
              end
            else -- user has clicked on a bookmark
              if fs.exists(tostring(param3)) then
                file = fs.open(tostring(param3), "r")
                gateData = textutils.unserialize(file.readAll()) -- GATE DATA VARIABLE!!!
                file.close()
                bookWin.setVisible(false)
                drawHome()
                  if gateData.address then
                    ok, result = pcall(sg.dial, gateData.address)
                    if ok then
                      status, int = sg.stargateState()
                      address = gateData.address
                      addToHistory(gateData.address)
                    end
                  end
                  sleep(.5)
                break
              else
                x,y = mon.getSize()
                for i = 1,y do
                  if fs.exists(tostring(i)) == false then
                    homeWin.setVisible(false)
                    file = fs.open(tostring(i), "w")
                    file.write(textutils.serialize(inputPage()))
                    file.close()
                    break
                  end
                end
              end
            end
          else
            drawHome()
            break
          end
        end
      end
    elseif param2 > x-7 and param2 < x-4 and param3 >= y/3-3 and param3 <= y/3*2+1 then -- Click has opened history menu
      while true do
        homeWin.setVisible(false)
        drawHistoryPage()
        event, param1, param2, param3 = os.pullEvent()
        if event == "monitor_touch" then
          if param3 >= y-2 then -- user clicked back
            historyWin.setVisible(false)
            drawHome()
            break --might break everything
          elseif param2 >= x-9 and param3 <= clickLimit then -- user has clicked save.
            if fs.exists("history") then
              file = fs.open("history", "r")
              history = textutils.unserialize(file.readAll())
              file.close()
              for i = 1,y do
                if fs.exists(tostring(i)) == false then
                  file = fs.open(tostring(i), "w")
                  file.write(textutils.serialize(historyInputPage(history[param3])))
                  file.close()
                  historyWin.setVisible(false)
                  break
                end
              end
            end
          homeWin.setVisible(false)
          drawHome()
          break  
        end    
      end
      end
    elseif param2 > x/2+2 and param2 <= x/2+7 and param3 >= y-4 and param3 <= y-2 then -- user clicked TERM
      ok, result = pcall(sg.disconnect)
    end
  elseif event == "sgDialIn" then
    alarmSet(true)
    if fs.exists("currentSec") then
      file = fs.open("currentSec", "r")
      currentSec = file.readAll()
      file.close()
    end
    addToHistory(param2)
  elseif event == "sgDialOut" then
    alarmSet(true)
    if fs.exists("currentSec") then
      file = fs.open("currentSec", "r")
      currentSec = file.readAll()
      file.close()
    end
    addToHistory(param2)
  elseif event == "sgStargateStateChange" then
    homeWin.setVisible(false)
    drawHome()
    status, int = sg.stargateState()
    if status == "idle" then
      isConnected = false
    else
      isConnected = true
    end
  end
  sleep(0)
end