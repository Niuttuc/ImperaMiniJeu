modem=peripheral.find('modem')
colorString=string.lower(string.sub(os.getComputerLabel(),7,-1))
color=colors[colorString]

os.loadAPI('ahb')
os.loadAPI('windows')
os.loadAPI('choices')
totalWeight=0
for i=1,#choices do
	totalWeight=totalWeight+choices[i].weight
end

