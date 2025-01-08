sub MainScreenmulti(screen as object, font as object, xIndex as object, yIndex as object, playersss as object, selectedPlayer as integer)
    screen.SetAlphaEnable(true)
    screen.Clear(&hFFFFFFFF)
    bg = CreateObject("roBitmap", "pkg:/images/gamebg2.png")
    screen.DrawObject(0, 0, bg)
    board = CreateObject("roBitmap", "pkg:/images/Board.jpg")
    screen.DrawObject(339, 59, board)

    firstPlayer = CreateObject("roBitmap", "pkg:/images/P1.png")
    firstPlayersmall = CreateObject("roBitmap", "pkg:/images/P1small.png")
    secondPlayer = CreateObject("roBitmap", "pkg:/images/P2.png")
    secondPlayersmall = CreateObject("roBitmap", "pkg:/images/P2small.png")
    screen.DrawObject(100, 420, firstPlayer)
    screen.DrawObject(1100, 420, secondPlayer)
    f = CreateObject("roBitmap", "pkg:/images/frame0bg2.png")
    screen.DrawObject(1070, 510, f)

    flag3 = 0
    flag4 = 0

    if playersss.Count() = 3 or playersss.Count() = 4 then
        thirdPlayer = CreateObject("roBitmap", "pkg:/images/P3.png")
        thirdPlayersmall = CreateObject("roBitmap", "pkg:/images/P3small.png")
        screen.DrawObject(1100, 220, thirdPlayer)
        flag3 = 1
    end if
    if playersss.Count() = 4 then
        fourthPlayer = CreateObject("roBitmap", "pkg:/images/P4.png")
        fourthPlayersmall = CreateObject("roBitmap", "pkg:/images/P4small.png")
        screen.DrawObject(100, 220, fourthPlayer)
        flag4 = 1
        flag3 = 0
    end if


    select = CreateObject("roBitmap", "pkg:/images/select2.png")

    one = CreateObject("roBitmap", "pkg:/images/one.png")
    two = CreateObject("roBitmap", "pkg:/images/two.png")
    three = CreateObject("roBitmap", "pkg:/images/three.png")
    four = CreateObject("roBitmap", "pkg:/images/four.png")
    five = CreateObject("roBitmap", "pkg:/images/five.png")
    six = CreateObject("roBitmap", "pkg:/images/six.png")

    diceArray = CreateObject("roArray", 6, true)
    diceArray.Push(one)
    diceArray.Push(two)
    diceArray.Push(three)
    diceArray.Push(four)
    diceArray.Push(five)
    diceArray.Push(six)

    if playersss[0]["selected"] = 1 then
        screen.DrawObject(100, 420, select)
    else if playersss[1]["selected"] = 1 then
        screen.DrawObject(1100, 420, select)
    else if (flag4 = 1 or flag3 = 1) and playersss[2]["selected"] = 1 then
        screen.DrawObject(1100, 220, select)
    else if flag4 = 1 and playersss[3]["selected"] = 1 then
        screen.DrawObject(100, 220, select)
    end if



    if playersss[0]["position"] = 0 then
        screen.DrawObject(250, 600, firstPlayer)
    else
        playerlevel = playersss[0]["position"]
        screen.DrawObject(xIndex[playerlevel - 1], yIndex[playerlevel - 1], firstPlayer)
    end if
    if playersss[1]["position"] = 0 then
        screen.DrawObject(250, 540, secondPlayer)
    else
        playerlevel = playersss[1]["position"]
        screen.DrawObject(xIndex[playerlevel - 1], yIndex[playerlevel - 1], secondPlayer)
    end if
    if (flag4 = 1 or flag3 = 1) then
        if playersss[2]["position"] = 0 then
            screen.DrawObject(190, 600, thirdPlayer)
        else
            playerlevel = playersss[2]["position"]
            screen.DrawObject(xIndex[playerlevel - 1], yIndex[playerlevel - 1], thirdPlayer)
        end if
    end if
    if flag4 = 1 then
        if playersss[3]["position"] = 0 then
            screen.DrawObject(190, 540, fourthPlayer)
        else
            playerlevel = playersss[3]["position"]
            screen.DrawObject(xIndex[playerlevel - 1], yIndex[playerlevel - 1], fourthPlayer)
        end if
    end if

    'each players die
    screen.DrawObject(200, 420, diceArray[playersss[0]["newDiceValue"] - 1])
    screen.DrawObject(1000, 420, diceArray[playersss[1]["newDiceValue"] - 1])
    if (flag4 = 1 or flag3 = 1) then
        screen.DrawObject(1000, 220, diceArray[playersss[2]["newDiceValue"] - 1])
    end if
    if flag4 = 1 then
        screen.DrawObject(200, 220, diceArray[playersss[3]["newDiceValue"] - 1])
    end if
end sub

sub SelectPositionMulti(screen as object, font as object, port as object, selectedPlayer as integer, xIndex as object, yIndex as object, should_not_traverse_l_s as integer, playersss as object) as object

    screen.SetAlphaEnable(true)
    spriteSheet = CreateObject("roBitmap", "pkg:/images/spritesheet.png")
    spriteSheet.SetAlphaEnable(true)
    frameWidth = 100
    frameHeight = 100
    framesPerRow = 5
    framesPerColumn = 3
    totalFrames = 15
    frameRegions = CreateObject("roArray", totalFrames, true)

    for i = 0 to totalFrames - 1
        x = (i mod framesPerRow) * frameWidth
        y = Int(i / framesPerRow) * frameHeight
        frameRegions[i] = CreateObject("roRegion", spriteSheet, x, y, frameWidth, frameHeight)
    end for
    currentFrame = 0
    animationTime = 0
    timeLimit = 2000
    startTime = CreateObject("roTimespan")
    FirstTimeDiceValue = Int(Rnd(8))
    if playersss[selectedPlayer]["firsTimeSix"] = 0 then
        if FirstTimeDiceValue = 7 or FirstTimeDiceValue = 8 then
            FirstTimeDiceValue = 6
        end if
        DiceValue = FirstTimeDiceValue
    else
        DiceValue = Int(Rnd(6))
    end if


    while animationTime < timeLimit
        frame = frameRegions[currentFrame]
        MainScreenmulti(screen, font, xIndex, yIndex, playersss, selectedPlayer)
        screen.DrawObject(1110, 550, frame)
        screen.SwapBuffers()
        currentFrame = (currentFrame + 1) mod frameRegions.Count()
        animationTime = startTime.TotalMilliseconds()
    end while
    sleep(100)

    if playersss[selectedPlayer]["firsTimeSix"] = 0 then
        if DiceValue = 6 then
            playersss[selectedPlayer]["firsTimeSix"] = 1
            playersss[selectedPlayer]["position"] = 1
            return{
                ' playersss: playersss
                DiceValue: DiceValue
                selectedPlayer: selectedPlayer
                should_not_traverse_l_s: 1
            }
        else
            return{
                ' playersss: playersss
                DiceValue: DiceValue
                selectedPlayer: selectedPlayer
                should_not_traverse_l_s: 1
            }
        end if
    else if playersss[selectedPlayer]["firsTimeSix"] = 1 then
        if playersss[selectedPlayer]["position"] + DiceValue < 100 then
            playersss[selectedPlayer]["position"] += DiceValue
            print "Player" + selectedPlayer.ToStr() + "current postion = " + playersss[selectedPlayer]["position"].ToStr()
            tempposition = LadderAndSnakeMulti(playersss, selectedPlayer, should_not_traverse_l_s)
            ' playersss[selectedPlayer]["position"] = tempposition.playersss[selectedPlayer]["position"]
            selectedPlayer = tempposition.selectedPlayer
            ' playersss = tempposition.playersss
            shouldnot = tempposition.should_not_traverse_l_s
            return{
                ' playersss: playersss
                DiceValue: DiceValue
                selectedPlayer: selectedPlayer
                should_not_traverse_l_s: shouldnot
            }
        else
            playersss[selectedPlayer]["position"] = 100
            return{
                ' playersss: playersss
                DiceValue: DiceValue
                selectedPlayer: selectedPlayer
                should_not_traverse_l_s: 1 'new game so resetto 1
            }

        end if
    end if
end sub


sub LadderAndSnakeMulti(playersss as object, selectedPlayer as integer, should_not_traverse_l_s as integer) as object
    LStart = CreateObject("roArray", 8, true)
    LStart.Push(4)
    LStart.Push(13)
    LStart.Push(33)
    LStart.Push(42)
    LStart.Push(50)
    LStart.Push(62)
    LStart.Push(74)
    LStart.Push(74) 'duplicate aisehi to make Sstart.size = Lstart.size . Using single for loop for both ladder and snake  @#$
    LEnd = CreateObject("roArray", 8, true)
    LEnd.Push(25)
    LEnd.Push(46)
    LEnd.Push(49)
    LEnd.Push(63)
    LEnd.Push(69)
    LEnd.Push(81)
    LEnd.Push(92)
    LEnd.Push(92)
    SStart = CreateObject("roArray", 8, true)
    SStart.Push(27)
    SStart.Push(40)
    SStart.Push(43)
    SStart.Push(54)
    SStart.Push(66)
    SStart.Push(76)
    SStart.Push(89)
    SStart.Push(99)
    SnEnd = CreateObject("roArray", 8, true)
    SnEnd.Push(5)
    SnEnd.Push(3)
    SnEnd.Push(18)
    SnEnd.Push(31)
    SnEnd.Push(45)
    SnEnd.Push(58)
    SnEnd.Push(53)
    SnEnd.Push(41)

    for i = 0 to 7
        if (LStart[i] = playersss[selectedPlayer]["position"]) then
            should_not_traverse_l_s = 0
            playersss[selectedPlayer]["position"] = LEnd[i]
            return {
                selectedPlayer: selectedPlayer
                ' playersss: playersss
                should_not_traverse_l_s: should_not_traverse_l_s
            }
        else if (SStart[i] = playersss[selectedPlayer]["position"]) then
            should_not_traverse_l_s = 0
            playersss[selectedPlayer]["position"] = SnEnd[i]
            return {
                selectedPlayer: selectedPlayer
                ' playersss: playersss
                should_not_traverse_l_s: should_not_traverse_l_s
            }
        end if
    end for
end sub

sub CheckWinMulti(selectedplayer as integer, playersss as object) as boolean
    if playersss[selectedplayer]["position"] = 100 then
        print "Player" + selectedplayer.ToStr() + "Win"
        return true
    end if
    return false
end sub
