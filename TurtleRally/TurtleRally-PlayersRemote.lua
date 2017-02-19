modem=peripheral.find('modem')


os.loadAPI('ahb')
os.loadAPI('windows')
os.loadAPI('choices')
os.loadAPI('sync')
os.loadAPI('clicAPI')
totalWeight=0
for k,v in pairs(choices) do
	totalWeight=totalWeight+choices.k.weight
end

