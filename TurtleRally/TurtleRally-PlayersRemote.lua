modem=peripheral.find('modem')


os.loadAPI('ahb')
os.loadAPI('windows')
os.loadAPI('choices')
os.loadAPI('sync')
totalWeight=0
for i=1,#choices do
	totalWeight=totalWeight+choices[i].weight
end

