modem=peripheral.find('modem')
colorString=string.lower(string.sub(os.getComputerLabel(),7,-1))
color=colors[colorString]
xmax,ymax=term.getSize()

os.loadAPI('ahb')


dispBeforeGame=window.create(term.current(),1,1,xmax,ymax,false)
dispBeforeGame.setBackgroundColor(color)
dispBeforeGame.setTextColor(colors.black)
dispBeforeGame.clear()
ahb.center('Vous avez rejoint la partie!',dispBeforeGame,math.floor(ymax/2))
ahb.center("Cliquez sur l'ecran principal pour lancer la partie",dispBeforeGame,math.floor(ymax/2))
dispBeforeGame.setCursorPos(xmax-6, 1)
dispBeforeGame.blit('Quitter','fffffff','eeeeeee')
dispBeforeGame.setCursorPos(xmax-6, 2)
dispBeforeGame.blit('   la  ','fffffff','eeeeeee')
dispBeforeGame.setCursorPos(xmax-6, 3)
dispBeforeGame.blit(' partie','fffffff','eeeeeee')






dispBeforeGame.setVisible(true)