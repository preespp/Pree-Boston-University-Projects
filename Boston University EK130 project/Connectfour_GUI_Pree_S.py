import pygame

#define variable
Columns = ["A","B","C","D","E","F","G"]
Boards = [["","","","","","",""],["","","","","","",""],["","","","","","",""]
,["","","","","","",""],["","","","","","",""],["","","","","","",""]]
ROWS = 6
COLS = 7
pygame.display.set_caption('Connectfour by Pree')
pygame.font.init()
myfontheader = pygame.font.SysFont("Arial",40)
myfontdetail = pygame.font.SysFont("Arial",20)
window = pygame.display.set_mode((110*COLS,110*ROWS+100))

#instruction before start game
def instruct():
    Instruct_status = True
    Game_name = myfontheader.render("CONNECT FOUR",True,(200,50,0))
    Instruction = myfontdetail.render("How to play",True,(150,150,150))
    Player_define = myfontdetail.render("First player: Blue | Second Player: Red",True,(150,150,150))
    How_to_select = myfontdetail.render("Click on the button of the column you want",True,(150,150,150))
    start()
    while Instruct_status:
        window.blit(Game_name,(200,50))
        window.blit(Instruction,(200,150))
        window.blit(Player_define,(200,200))
        window.blit(How_to_select,(200,250))
        if not start():
            Instruct_status = False

#start button
def start():
    pygame.draw.rect(window,(120,120,0),(250,360,130,70))
    textstart = myfontheader.render("START",True,(0,0,0))
    window.blit(textstart,(250,375))
    pygame.display.flip()
    cursor = pygame.mouse.get_pos()
    while True:
        for event in pygame.event.get():
            if event.type == pygame.MOUSEBUTTONDOWN:
                return False
                break
            else:
                return True
                break

#print board
def getboard(Boards):
    pygame.draw.rect(window,(100,100,100),(0,100,110*COLS,110*ROWS))
    pygame.display.flip()
    for i in range(COLS):
        for j in range(ROWS):
            if Boards[j][i] == "R":
                pygame.draw.circle(window,(255,0,0),(55+i*110,155+j*110),55)
                pygame.display.flip()
            elif Boards[j][i] == "B":
                pygame.draw.circle(window,(0,0,250),(55+i*110,155+j*110),55)
                pygame.display.flip()
            else:
                pygame.draw.circle(window,(250,250,250),(55+i*110,155+j*110),55)
                pygame.display.flip()

#check winner
def checkwinhorizon(Boards):
    for a in range(ROWS):
        for b in range(COLS-3) :
            if Boards[a][b]=="B" and Boards[a][b+1]=="B" and Boards[a][b+2]=="B" and Boards[a][b+3]=="B":
                return True
            elif Boards[a][b]=="R" and Boards[a][b+1]=="R" and Boards[a][b+2]=="R" and Boards[a][b+3]=="R":
                return True
    return False

def checkwinvertical(Boards):
    for b in range(COLS):
        for a in range(ROWS-3) :
            if Boards[a][b]=="B" and Boards[a+1][b]=="B" and Boards[a+2][b]=="B" and Boards[a+3][b]=="B":
                return True
            elif Boards[a][b]=="R" and Boards[a+1][b]=="R" and Boards[a+2][b]=="R" and Boards[a+3][b]=="R":
                return True
    return False

def checkwindiag1(Boards):
    for a in range(ROWS-3):
        for b in range(COLS-3) :
            if Boards[a][b]=="B" and Boards[a+1][b+1]=="B" and Boards[a+2][b+2]=="B" and Boards[a+3][b+3]=="B":
                return True
            elif Boards[a][b]=="R" and Boards[a+1][b+1]=="R" and Boards[a+2][b+2]=="R" and Boards[a+3][b+3]=="R":
                return True
    return False

def checkwindiag2(Boards):
    for a in range(ROWS-1,ROWS-4,-1):
        for b in range(COLS-3) :
            if Boards[a][b]=="B" and Boards[a-1][b+1]=="B" and Boards[a-2][b+2]=="B" and Boards[a-3][b+3]=="B":
                return True
            elif Boards[a][b]=="R" and Boards[a-1][b+1]=="R" and Boards[a-2][b+2]=="R" and Boards[a-3][b+3]=="R":
                return True
    return False

#check the rows that the circle will be filled
def checkifeligible(numofcols):
    for i in range(ROWS):
        if Boards[i][numofcols] == "":
            continue
        else:
            return i-1,numofcols
            break 
    if i == 5 :
        return i,numofcols

#play + buttons to select the answer
def play():
    for i in range(COLS):
        pygame.draw.rect(window,(120+10*i,120+10*i,0),(110*i,0,110,100))
        textcol = myfontheader.render(chr(i+65),True,(0,0,0))
        window.blit(textcol,(40+i*110,50))
        pygame.display.flip()
    gamecon = False
    while gamecon == False:
        cursor = pygame.mouse.get_pos()    
        x = cursor[0]
        y = cursor[1]
        for event in pygame.event.get():
            if event.type == pygame.MOUSEBUTTONDOWN :
                if 0<=x and x<=110:
                    input = 0
                    gamecon = True
                elif 110<x and x<=220:
                    input = 1
                    gamecon = True
                elif 220<x and x<=330:
                    input = 2
                    gamecon = True
                elif 330<x and x<=440:
                    input = 3
                    gamecon = True
                elif 440<x and x<=550:
                    input = 4
                    gamecon = True
                elif 550<x and x<=660:
                    input = 5
                    gamecon = True
                elif 660<x and x<=770:
                    input = 6
                    gamecon = True
    Row,Col = checkifeligible(input)
    return Row, Col

#main function
def main():
    instruct()
    Game = False
    getboard(Boards)
    turn = 0
    while Game == False:
        turn+=1
        a = turn%2
        if a == 0:
            a+=2
        textplayer = myfontheader.render("Player: "+str(a)+" Turn: "+str(turn),True,(225,225,225))
        window.blit(textplayer,(220,0))
        pygame.display.flip()
        pygame.event.pump()
        pygame.time.delay(750)
        Row,Col=play()
        while Row == -1:
            Row,Col=play()
        if turn%2 == 1:
            Boards[Row][Col]="B"
        elif turn%2 == 0:
            Boards[Row][Col]="R"
        getboard(Boards)
        Game = checkwinhorizon(Boards)
        if Game:
            break
        Game = checkwinvertical(Boards)
        if Game:
            break
        Game = checkwindiag1(Boards)
        if Game:
            break
        Game = checkwindiag2(Boards)
        if Game:
            break
        if turn > 41:
            textwin = myfontheader.render("No one win!!",True,(50,0,0))
            window.blit(textwin,(250,350))
            pygame.display.flip()
            pygame.event.pump()
            pygame.time.delay(5000)
            break
    if a == 2:
        textwin = myfontheader.render("Player 2 win!!",True,(50,0,0))
        window.blit(textwin,(250,350))
        pygame.display.flip()
        pygame.event.pump()
        pygame.time.delay(5000)
    else:
        textwin = myfontheader.render("Player 1 win!!",True,(50,0,0))
        window.blit(textwin,(250,350))
        pygame.display.flip()
        pygame.event.pump()
        pygame.time.delay(5000)

pygame.init()
main()