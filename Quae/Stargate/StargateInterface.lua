mon = peripheral.find("monitor")
sg = peripheral.find("stargate")
eChest = peripheral.find("ender_chest")
drive = peripheral.find("drive")

localAddress=sg.localAddress()
mon.setBackgroundColor(colors.black)
mon.clear()
maxEng = 50000
dialling = {}
remoteAdress=""
xmax,ymax = mon.getSize()
function getBookmarksHistory()
  if fs.exists('stargateLocalBookmarks') then
    file = fs.open('stargateLocalBookmarks',"r")
    localBookmarks = textutils.unserialize(file.readAll())
    file.close()
  else
    localBookmarks={}
    file = fs.open('stargateLocalBookmarks',"w")
    file.write(textutils.serialize(localBookmarks))
    file.close()
  end
  if fs.exists('stargateDistantBookmarks') then
    file = fs.open('stargateDistantBookmarks',"r")
    distantBookmarks = textutils.unserialize(file.readAll())
    file.close()
  else
    distantBookmarks={}
    file = fs.open('stargateDistantBookmarks',"w")
    file.write(textutils.serialize(distantBookmarks))
    file.close()
  end
  if fs.exists('stargateHistory') then
    file = fs.open('stargateHistory',"r")
    history = textutils.unserialize(file.readAll())
    file.close()
  else
    history={}
    file = fs.open('stargateHistory',"w")
    file.write(textutils.serialize(history))
    file.close()
  end
  if distantBookmarks.version then
    if eChest then
      while not(eChest.getStackInSlot(1)) do
        sleep(1)
      end
      if tonumber(string.sub(eChest.getStackInSlot(1).display_name,2,-1))>distantBookmarks.version then
        eChest.pushItem('up',1,1)
        fs.delete("stargateDistantBookmarks")
        fs.copy(drive.getMountPath()..'/stargateDistantBookmarks', "stargateDistantBookmarks")
        file = fs.open('stargateDistantBookmarks',"r")
        distantBookmarks = textutils.unserialize(file.readAll())
        file.close()
        eChest.pullItem('up',1,1)
      end
    end
  else
    eChest.pushItem('up',1,1)
    fs.delete("stargateDistantBookmarks")
    fs.copy(drive.getMountPath()..'/stargateDistantBookmarks', "stargateDistantBookmarks")
    file = fs.open('stargateDistantBookmarks',"r")
    distantBookmarks = textutils.unserialize(file.readAll())
    file.close()
    bool=true
    for k,v in pairs(distantBookmarks) do
      if type(v)=="table" and v.address==localAddress then
        bool=false
      elseif type(v)=="table" and string.sub(localAddress,1,7)==v.address then
        bool=false
        distantBookmarks[k]={v.name,localAddress}
        distantBookmarks.version=distantBookmarks.version+1
        file = fs.open('stargateDistantBookmarks',"w")
        file.write(textutils.serialize(distantBookmarks))
        file.close()
        fs.delete(drive.getMountPath()..'/stargateDistantBookmarks')
        fs.copy("stargateDistantBookmarks", drive.getMountPath()..'/stargateDistantBookmarks')
        drive.setDiskLabel("V"..tostring(distantBookmarks.version))
      end
    end
    if bool then
      distantBookmarks[table.maxn(distantBookmarks)+1]={name=os.getComputerLabel(),address=localAddress}
      distantBookmarks.version=distantBookmarks.version+1
      file = fs.open('stargateDistantBookmarks',"w")
      file.write(textutils.serialize(distantBookmarks))
      file.close()
      fs.delete(drive.getMountPath()..'/stargateDistantBookmarks')
      fs.copy("stargateDistantBookmarks", drive.getMountPath()..'/stargateDistantBookmarks')
      drive.setDiskLabel("V"..tostring(distantBookmarks.version))
    end
    eChest.pullItem('up',1,1)
  end
  bookmarks=localBookmarks
  for k,v in pairs(distantBookmarks) do
    if type(k)=='number' and v.address~=localAddress then
      bookmarks[table.maxn(bookmarks)+1]=v
    end
  end
end
function initWin()
  getBookmarksHistory()
  homeWin=window.create(mon,1,1,xmax,ymax,false)
  homeWin.setBackgroundColor(colors.black)
  homeWin.clear()
  homeWin.setCursorPos(xmax/2-5,1)
  homeWin.setTextColor(colors.red)
  homeWin.write(os.getComputerLabel())

  powerBarWin=window.create(homeWin,xmax-1,1,2,ymax,true)
  powerWin=window.create(homeWin,xmax-11,ymax,12,1,true)

  localAdd=window.create(homeWin,1,ymax,16+#sg.localAddress(),1,true)
  localAdd.setBackgroundColor(colors.black)
  localAdd.setTextColor(colors.lightGray)
  localAdd.setCursorPos(1,1)
  localAdd.write("Adresse Locale:")
  localAdd.setCursorPos(16, 1)
  localAdd.write(sg.localAddress())

  remoteAdd=window.create(homeWin,xmax/2-5,ymax/2-2,11,5,true)
  remoteAdd.setBackgroundColor(colors.gray)
  remoteAdd.setTextColor(colors.red)



  irisStateColors={[-1]=colors.red,[0]=colors.black,[1]=colors.lime}
  irisWin={}
  for i=-1,1 do
    irisWin[i]=window.create(homeWin,6,math.floor(ymax/3)-4,3,ymax/3+4,false)
    irisWin[i].setBackgroundColor(colors.lightGray)
    irisWin[i].setTextColor(irisStateColors[i])
    irisWin[i].clear()
    for  yc = 1, ymax/3+4 do
      char = string.sub("   IRIS  ", yc, yc)
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
  historyBtonWin=window.create(homeWin,xmax-7,math.floor(ymax/3)-4,3,ymax/3+4,false)
  historyBtonWin.setBackgroundColor(colors.lightGray)
  historyBtonWin.setTextColor(colors.black)
  historyBtonWin.clear()
  for  yc = 1, ymax/3+4 do
    char = string.sub(" HISTORY ", yc, yc)
    historyBtonWin.setCursorPos(2, yc)
    historyBtonWin.write(char)
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
end

initWin()
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

function drawRemoteAddress()
  remoteAdd.setVisible(true)
  remoteAdd.clear()
  remoteAdd.setCursorPos(2,2)
  remoteAdd.write("Connexion")
  if sg.remoteAddress()~="" then
    remoteAdd.setCursorPos(2,3)
    for k,v in pairs(bookmarks) do
      if type(v)=="table" and v.address==sg.remoteAddress() then
        remoteAdd.write(v.name)
      end
    end
    remoteAdd.setCursorPos(2,4)
    remoteAdd.write(sg.remoteAddress())
  else
    remoteAdd.setCursorPos(2,3)
    remoteAdd.write("Stargate")
    remoteAdd.setCursorPos(4,4)
    remoteAdd.write("libre")
  end
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
  drawRemoteAddress()
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
 
function drawBookmarksPage(page)
  bookWin.setBackgroundColor(colors.black)
  bookWin.clear()
  bookWin.setTextColor(colors.black)
  x,y = bookWin.getSize()
  for yc = 1,y-4 do
    if yc%2 == 1 then
      bookWin.setBackgroundColor(colors.red)
    else
      bookWin.setBackgroundColor(colors.gray)
    end
      bookWin.setCursorPos(1, yc)
      bookWin.clearLine()
  end
  for i= 1,math.min(y-4,math.max(#bookmarks-(page-1)*(y-4),0)) do
    if i%2 == 1 then
      bookWin.setBackgroundColor(colors.red)
    else
      bookWin.setBackgroundColor(colors.gray)
    end
    bookWin.setCursorPos(1,i)
    if bookmarks[i+(page-1)*(y-4)] then
      bookWin.write(bookmarks[i+(page-1)*(y-4)].name)
      bookWin.setCursorPos(x/2, i)
      bookWin.write(bookmarks[i+(page-1)*(y-4)].address)
      bookWin.setCursorPos(x,i)
      bookWin.setBackgroundColor(colors.blue)
      bookWin.write("X")
    elseif i < y-3 then
      bookWin.setCursorPos(1, i)
      bookWin.write("Ajouter Une Adresse")
    end
  end
  bookWin.setBackgroundColor(colors.black)
  bookWin.setCursorPos(x/2-#("^^^ Page "..tostring(page).." VVV")/2, y-3)
  bookWin.clearLine()
  bookWin.setBackgroundColor(colors.white)
  bookWin.setTextColor(colors.black)
  bookWin.write("^^^ Page "..tostring(page).." VVV")
  bookWin.setBackgroundColor(colors.black)
  bookWin.setTextColor(colors.white)
  bookWin.setCursorPos(x/2-3, y-1)
  bookWin.write("RETOUR")
  bookWin.setVisible(true)
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
  term.clear()
  return newGate
end
 
function drawHistoryButton()
  historyBtonWin.setVisible(true)
end
 
function addToHistory(address)
  if fs.exists("stargateHistory") then
    file = fs.open("stargateHistory", "r")
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
  file = fs.open("stargateHistory", "w")
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
  if fs.exists("stargateHistory") then
    file = fs.open("stargateHistory","r")
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
      historyWin.setCursorPos(xc, yc)
      historyWin.write(" ")
    end
  end
  historyWin.setCursorPos(x/2-2, y-1)
  historyWin.setTextColor(colors.white)
  historyWin.write("RETOUR")
  historyWin.setVisible(true)
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
    if param2 >= 6 and param2 <= 8 and param3 >= y/3-3 and param3 <= y/3*2+1 then --opens or closes the Iris
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
      getBookmarksHistory()
      status, int = sg.stargateState()
      if status == "Idle" then
        curPage=1
        while true do
          homeWin.setVisible(false)
          drawBookmarksPage(curPage)
          event, param1, param2, param3 = os.pullEvent()
          if event == "monitor_touch" then
            if param3 >= y-2 then -- user clicked back
              bookWin.setVisible(false)
              drawHome()
              break
            elseif param2 > x-2 then -- user clicked delete on a bookmark
              if fs.exists('stargateLocalBookmarks') then
                file = fs.open('stargateLocalBookmarks',"r")
                localBookmarks = textutils.unserialize(file.readAll())
                file.close()
                if localBookmarks[param3] then
                  table.remove(localBookmarks,param3)
                end
                file = fs.open('stargateLocalBookmarks',"w")
                file.write(textutils.serialize(localBookmarks))
                file.close()
                getBookmarksHistory()
                drawBookmarksPage()
              end
            elseif param3==y-3 and param2>=x/2-#("^^^ Page "..tostring(page).." VVV")/2 and param2<=x/2-#("^^^ Page "..tostring(page).." VVV")/2+2 then
              --user has clicked on previous page
              if curPage>1 then
                curPage=curPage-1
              end
            elseif param3==y-3 and param2<=x/2+#("^^^ Page "..tostring(page).." VVV")/2 and param2>=x/2+#("^^^ Page "..tostring(page).." VVV")/2-3 then
              --user has clicked on next page
              if #bookmarks>=(curPage)*(ymax-4) then
                curPage=curPage+1
              end
            elseif param3<=y4 then -- user has clicked on a bookmark
              gateData =  bookmarks[param3]-- GATE DATA VARIABLE!!!
              bookWin.setVisible(false)
              drawHome()
              if gateData then
                ok, result = pcall(sg.dial, gateData.address)
                if ok then
                  status, int = sg.stargateState()
                  address = gateData.address
                  addToHistory(gateData.address)
                  sleep(0.5)
                  bookWin.setVisible(false)
                  drawHome()
                  break
                end
              else
                for i = 1,y do
                  if not(bookmarks[i]) then
                    homeWin.setVisible(false)
                    file = fs.open('stargateLocalBookmarks',"r")
                    localBookmarks = textutils.unserialize(file.readAll())
                    file.close()
                    localBookmarks[table.maxn(localBookmarks)+1]=inputPage()
                    file = fs.open("stargateLocalBookmarks", "w")
                    file.write(textutils.serialize(localBookmarks))
                    file.close()
                    bookWin.setVisible(false)
                    drawHome()
                    break
                  end
                end
              end
              sleep(.5)
              break
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
            if fs.exists("stargateHistory") then
              file = fs.open("stargateHistory", "r")
              history = textutils.unserialize(file.readAll())
              file.close()
              if fs.exists("stargateLocalBookmarks") then
                file = fs.open('stargateLocalBookmarks',"r")
                localBookmarks = textutils.unserialize(file.readAll())
                file.close()
                for i = 1,y do
                  if not(localBookmarks[i]) then                    
                    localBookmarks[i]=historyInputPage(history[param3])
                    file = fs.open("stargateLocalBookmarks", "w")
                    file.write(textutils.serialize(localBookmarks))
                    file.close()
                    getBookmarksHistory()
                    drawBookmarksPage()
                    break
                  end
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
      remoteAdress=""
    end
  elseif event == "sgDialIn" then
    alarmSet(true)
    remoteAdress=param2
    if fs.exists("currentSec") then
      file = fs.open("currentSec", "r")
      currentSec = file.readAll()
      file.close()
    end
    addToHistory(param2)
  elseif event == "sgDialOut" then
    alarmSet(true)
    remoteAdress=param2
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