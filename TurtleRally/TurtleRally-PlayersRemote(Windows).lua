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




waitingScreen=window.create(term.current(),1,1,xmax,ymax,false)
waitingScreen.setBackgroundColor(color)
waitingScreen.setTextColor(colors.black)
waitingScreen.clear()
ahb.center('Veuillez patienter',waitingScreen,math.floor(ymax/2)-1)
ahb.center("Une operation",waitingScreen,math.floor(ymax/2))
ahb.center(" est en cours.",waitingScreen,math.floor(ymax/2)+1)

veille=window.create(term.current(),1,1,xmax,ymax,false)
veille.setBackgroundColor(color)
veille.setTextColor(colors.black)
veille.clear()
ahb.center('Votre robot dort',veille,math.floor(ymax/2)-1)
ahb.center("prochain tour",veille,math.floor(ymax/2))
ahb.center("il serra repare",veille,math.floor(ymax/2)+1)



leaveGame=window.create(term.current(),1,1,xmax,ymax,false)

leaveGame.setBackgroundColor(colors.black)
leaveGame.setTextColor(colors.white)
leaveGame.clear()
ahb.center('Cliquer',leaveGame,math.floor(ymax/2)-1)
ahb.center("pour rejoindre",leaveGame,math.floor(ymax/2))
ahb.center("le jeu",leaveGame,math.floor(ymax/2)+1)

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

vie=window.create(playWindow,1,1,7,1,true)
coeur=window.create(playWindow,8,1,11,1,true)
etape=window.create(playWindow,19,1,10,1,true)
etape.setBackgroundColor(colors.white)
etape.setTextColor(colors.black)

choiceColumn=window.create(playWindow,3,3,xmax,5,true)
choiceColumn.setBackgroundColor(colors.lightGray)
choiceColumn.setTextColor(colors.black)
choiceColumn.clear()

listColumn=window.create(playWindow,1,9,xmax,10,true)
listColumn.setBackgroundColor(colors.gray)
listColumn.setTextColor(colors.black)
listColumn.clear()

separateColumn=window.create(playWindow,1,3,2,5,true)
separateColumn.setBackgroundColor(color)
separateColumn.setTextColor(colors.black)
separateColumn.clear()
for i=1,5 do
	separateColumn.setCursorPos(1,i)
	separateColumn.write(i)
end

countDown=window.create(playWindow,1,ymax-1,4,1,true)
countDown.setBackgroundColor(colors.black)
countDown.setTextColor(colors.white)
countDown.clear()

validerBouton=window.create(playWindow,math.floor(xmax/2)-5,9,11,3,true)
validerBouton.setBackgroundColor(colors.white)
validerBouton.setTextColor(colors.black)
validerBouton.clear()
validerBouton.setCursorPos(3,2)
validerBouton.write("Valider")

sleepBt=window.create(playWindow,math.floor(xmax/2)-5,14,11,4,true)
sleepBt.setBackgroundColor(colors.red)
sleepBt.setTextColor(colors.white)
sleepBt.clear()

sleepBt.setCursorPos(3,2)
sleepBt.write("Valider")
sleepBt.setCursorPos(3,2)
sleepBt.write("puis dodo")


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
