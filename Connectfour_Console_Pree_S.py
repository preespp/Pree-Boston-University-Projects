print("Connect Four\n")
print("Please enter the column you want\nFirst player:B Second Player:R\n")
print("Please enter in the form of 'A1'")
print("\n\n")

Columns = ["A","B","C","D","E","F","G"]
Boards = []
ROWS = 6
COLS = 7
for _ in range(ROWS):
    Boards.append(["","","","","","",""])

def printboard():
    for i in range(7):
        print(Columns[i],end="   ")
    print("\n")
    for a in range(ROWS):
        print("'---'---'---'---'---'---'---'")
        for b in range(COLS):
            if Boards[a][b] == "R":
                print("| R ",end="")
            elif Boards[a][b] == "B":
                print("| B ",end="")
            else:
                print("|",end="   ")
        print("|",a+1)
    print("'---'---'---'---'---'---'---'")

def checkwinhorizon():
    for a in range(ROWS):
        for b in range(COLS-3) :
            if Boards[a][b]=="B" and Boards[a][b+1]=="B" and Boards[a][b+2]=="B" and Boards[a][b+3]=="B":
                print("\nGame Over! The Winner is Player 1\n")
                return True
            elif Boards[a][b]=="R" and Boards[a][b+1]=="R" and Boards[a][b+2]=="R" and Boards[a][b+3]=="R":
                print("\nGame Over! The Winner is Player 2\n")
                return True
    return False

def checkwinvertical():
    for b in range(COLS):
        for a in range(ROWS-3) :
            if Boards[a][b]=="B" and Boards[a+1][b]=="B" and Boards[a+2][b]=="B" and Boards[a+3][b]=="B":
                print("\nGame Over! The Winner is Player 1\n")
                return True
            elif Boards[a][b]=="R" and Boards[a+1][b]=="R" and Boards[a+2][b]=="R" and Boards[a+3][b]=="R":
                print("\nGame Over! The Winner is Player 2\n")
                return True
    return False

def checkwindiag1():
    for a in range(ROWS-3):
        for b in range(COLS-3) :
            if Boards[a][b]=="B" and Boards[a+1][b+1]=="B" and Boards[a+2][b+2]=="B" and Boards[a+3][b+3]=="B":
                print("\nGame Over! The Winner is Player 1\n")
                return True
            elif Boards[a][b]=="R" and Boards[a+1][b+1]=="R" and Boards[a+2][b+2]=="R" and Boards[a+3][b+3]=="R":
                print("\nGame Over! The Winner is Player 2\n")
                return True
    return False

def checkwindiag2():
    for a in range(ROWS-1,ROWS-4,-1):
        for b in range(COLS-3) :
            if Boards[a][b]=="B" and Boards[a-1][b+1]=="B" and Boards[a-2][b+2]=="B" and Boards[a-3][b+3]=="B":
                print("\nGame Over! The Winner is Player 1\n")
                return True
            elif Boards[a][b]=="R" and Boards[a-1][b+1]=="R" and Boards[a-2][b+2]=="R" and Boards[a-3][b+3]=="R":
                print("\nGame Over! The Winner is Player 2\n")
                return True
    return False

def checkifeligible(A):
    if len(A)!=2 or int(A[1])>6:
        Col = 0
        Row = 0
        return 0, Row, Col
    else:
        Col = ord(A[0])-65
        Row = int(A[1])-1   
        if Boards[Row][Col] != "":
            return 0,Row,Col
        elif Row != 5:
            if Boards[Row+1][Col] == "":
                return 0,Row,Col
            else:
                return 1,Row,Col
        else:
            return 1,Row,Col

def play():
    infromplay = input("Enter your position: ")
    [value,Row,Col] = checkifeligible(infromplay)
    while value == 0:
        infromplay = input("Error! enter your eligible position: ")
        [value,Row,Col] = checkifeligible(infromplay)
    return Row, Col

def main():
    Game = False
    printboard()
    turn = 0
    while Game == False:
        turn+=1
        a = turn%2
        if a == 0:
            a+=2
        print("Player:",a,"turn:",turn)
        [Row,Col]=play()
        if turn%2 == 1:
            Boards[Row][Col]="B"
        elif turn%2 == 0:
            Boards[Row][Col]="R"
        printboard()
        Game1 = checkwinhorizon()
        Game2 = checkwinvertical()
        Game3 = checkwindiag1()
        Game4 = checkwindiag2()
        if Game1 or Game2 or Game3 or Game4:
            break
        if turn > 41:
            print("No one wins")
            break

main()

