modem=peripheral.find('modem')
colorString=string.lower(string.sub(os.getComputerLabel(),7,-1))
color=colors[colorString]

os.loadAPI('ahb')
os.loadAPI('windows')



