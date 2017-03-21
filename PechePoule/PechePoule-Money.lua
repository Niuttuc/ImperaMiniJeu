modem=peripheral.find("modem")
chest=peripheral.wrap("back")
 
file=fs.open("leCote","r")
leCote=file.readLine()
file.close()
 
function verifier()
    print("Verif")
    chest.condenseItems()
    stacks=chest.getAllStacks()
    money=0
    table.foreach(stacks,function(i,data)
        info=data.basic()
        if info.name=="note500" then
            money=info.qty*5
        elseif info.name=="coin100" or info.name=="note100" then
            money=info.qty*1
        elseif info.name=="note200" then
            money=info.qty*2
        end
    end)
    if money>=5 then
        print("ok")
        modem.transmit(1,3,textutils.serialize({cote=leCote,argent=true}))
    else
        print("pas ok")
        modem.transmit(1,3,textutils.serialize({cote=leCote,argent=false}))
    end
end
function payer()
    print("payer")
    chest.condenseItems()
    stacks=chest.getAllStacks()
    moneys={note500=0,coin100=0,note100=0,note200=0}
    table.foreach(stacks,function(i,data)
        info=data.basic()
        if info.name=="note500" or info.name=="coin100" or info.name=="note100" or info.name=="note200" then
            moneys[info.name]=moneys[info.name]+info.qty
        end
    end)
    money=5
    table.foreach(stacks,function(i,data)
        info=data.basic()
        if moneys.note500~=0 then
            if info.name=="note500" then
                if money==5 then
                    print("> payer billet de 5 ")
                    chest.pushItem("DOWN",i,1)
                    money=0
                end
            end
        else
            if money>0 then
                if info.name=="coin100" or info.name=="note100" then
                   
                    if info.qty<money then
                        chest.pushItem("DOWN",i,info.qty)
                        print("> payer "..info.qty.."x " ..info.name)
                        money=money-info.qty
                        print("reste a payer "..money)
                    else
                        chest.pushItem("DOWN",i,money)                     
                        print("> payer "..money.."x " ..info.name)
                        money=0
                        print("reste a payer "..money)
                    end
                elseif info.name=="note200" then
                    if info.qty*2<money then
                        chest.pushItem("DOWN",i,info.qty)
                        print("> payer "..info.qty.."x " ..info.name)
                        money=money-(info.qty*2)                       
                        print("reste a payer "..money)
                    else
                        chest.pushItem("DOWN",i,math.ceil(money/2))
                        print("> payer "..math.ceil(money/2).."x " ..info.name)
                        money=0            
                        print("reste a payer "..money)
                    end
                end
            end
        end
    end)
end
 
modem.open(3)
while true do
    local event, modemSide, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")
    --local event, message = os.pullEvent("paste")
     
    if message=="verif" then
        verifier()
    elseif message=="payer" then
        payer()
    end
end