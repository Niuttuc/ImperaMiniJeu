xmax,ymax=term.getSize()
colorString=string.lower(string.sub(os.getComputerLabel(),7,-1))
color=colors[colorString]

beforeGame=window.create(term.current(),1,1,xmax,ymax,false)

beforeGame.setBackgroundColor(color)
beforeGame.setTextColor(colors.black)
beforeGame.clear()
ahb.center('Vous avez rejoint!',beforeGame,math.floor(ymax/2)-1)
ahb.center("Cliquez sur l'ecran",beforeGame,math.floor(ymax/2))
ahb.center(" principal pour lancer",beforeGame,math.floor(ymax/2)+1)
ahb.center("la partie",beforeGame,math.floor(ymax/2)+2)
beforeGame.setCursorPos(xmax-6, 1)
beforeGame.blit('Quitter','fffffff','eeeeeee')
beforeGame.setCursorPos(xmax-6, 2)
beforeGame.blit('   la  ','fffffff','eeeeeee')
beforeGame.setCursorPos(xmax-6, 3)
beforeGame.blit(' partie','fffffff','eeeeeee')

leaveGame=window.create(term.current(),1,1,xmax,ymax,false)

leaveGame.setBackgroundColor(colors.black)
leaveGame.setTextColor(colors.white)
leaveGame.clear()
ahb.center('Vous avez quitte',leaveGame,math.floor(ymax/2)-1)
ahb.center("le jeu.",leaveGame,math.floor(ymax/2))
ahb.center(" Au revoir!",leaveGame,math.floor(ymax/2)+1)

gameInProgress=window.create(term.current(),1,1,xmax,ymax,false)

gameInProgress.setBackgroundColor(colors.red)
gameInProgress.setTextColor(colors.black)
gameInProgress.clear()
ahb.center('Partie en cours',gameInProgress,math.floor(ymax/2)-1)
ahb.center("Trop tard.",gameInProgress,math.floor(ymax/2))
ahb.center(" Desole!",gameInProgress,math.floor(ymax/2)+1)


gameInProgress=window.create(term.current(),1,1,xmax,ymax,false)

gameInProgress.setBackgroundColor(colors.red)
gameInProgress.setTextColor(colors.black)
gameInProgress.clear()
ahb.center('Partie en cours',gameInProgress,math.floor(ymax/2)-1)
ahb.center("Trop tard.",gameInProgress,math.floor(ymax/2))
ahb.center(" Desole!",gameInProgress,math.floor(ymax/2)+1)

playWindow=window.create(term.current(),1,1,xmax,ymax,false)
playWindow.setBackgroundColor(color)
playWindow.setTextColor(colors.black)
playWindow.clear()


listColumn=window.create(playWindow,1,4,math.floor(xmax/2)-1,math.min(14,ymax-4),true)
listColumn.setBackgroundColor(colors.lightGray)
listColumn.setTextColor(colors.black)
listColumn.clear()

separateColumn=window.create(playWindow,math.floor(xmax/2),4,math.floor(xmax/2)+1,math.min(14,ymax-4),true)
separateColumn.setBackgroundColor(color)
separateColumn.setTextColor(colors.black)
separateColumn.clear()
for i=1,6 do
	separateColumn.setCursorPos(1,i)
	separateColumn.write(i)
end
for i=7,math.min(14,ymax-4) do
	separateColumn.setCursorPos(1,i)
	separateColumn.write('|')
end

choiceColumn=window.create(playWindow,math.floor(xmax/2)+1,4,xmax,math.min(14,ymax-4),true)
choiceColumn.setBackgroundColor(colors.gray)
choiceColumn.setTextColor(colors.black)
choiceColumn.clear()


countDown=window.create(playWindow,math.floor(xmax/2)-1,ymax-3,math.floor(xmax/2)+2,ymax,true)
countDown.setBackgroundColor(colors.black)
countDown.setTextColor(colors.white)
countDown.clear()


gameOver=window.create(term.current(),1,1,xmax,ymax,false)

gameOver.setBackgroundColor(colors.red)
gameOver.setTextColor(colors.black)
gameOver.clear()
ahb.center('Game Over',gameOver,math.floor(ymax/2)-1)
ahb.center("Vous etes mort",gameOver,math.floor(ymax/2))
ahb.center(" Desole!",gameOver,math.floor(ymax/2)+1)

gameWin=window.create(term.current(),1,1,xmax,ymax,false)

gameWin.setBackgroundColor(color)
gameWin.setTextColor(colors.black)
gameWin.clear()
ahb.center('Victoire',gameWin,math.floor(ymax/2)-1)
ahb.center("Vous avez gagne",gameWin,math.floor(ymax/2))
ahb.center(" (absolument rien)",gameWin,math.floor(ymax/2)+1)
