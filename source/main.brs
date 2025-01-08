sub Main()
    port = CreateObject("roMessagePort")
    screen = CreateObject("roScreen", true, 1280, 720)
    screen.SetMessagePort(port)
    font = CreateObject("roFontRegistry").GetDefaultFont()

    Snk = Snakesss()

    'ladder and snake
    LStart = CreateObject("roArray", 7, true)
    LStart.Push(4)
    LStart.Push(13)
    LStart.Push(33)
    LStart.Push(42)
    LStart.Push(50)
    LStart.Push(62)
    LStart.Push(74)
    LEnd = CreateObject("roArray", 7, true)
    LEnd.Push(25)
    LEnd.Push(46)
    LEnd.Push(49)
    LEnd.Push(63)
    LEnd.Push(69)
    LEnd.Push(81)
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

    numofplayers = 2
    op = ModeSelection(numofplayers)
    numofplayers = op.numofplayers
    print "Number of Players = " + numofplayers.ToStr()
    playersss = processPlayers(numofplayers)
    ' playersss[2]["firstTimeSix"] = 23

    ' for i = 0 to playersss.Count() - 1
    '     player = playersss[i]
    '     print "Player " + i.ToStr() + ":"
    '     for each key in playersss
    '         value = playersss[key]

    '         print key + ": " + str(value)
    '     end for
    ' end for


    ' print "firstTimeSix of Player 3: " + str(playersss[2]["firstTimeSix"])
    selectedPlayer = 0
    playersss[0]["selected"] = 1
    '===========================================================================

    firstPlayerSelect = true
    secondplayerSelect = false
    player1Level = 0
    player2Level = 0
    firstTimeSixP1 = 0
    firstTimeSixP2 = 0
    player1OldLevel = 1
    player2OldLevel = 1



    '----------------------------------------------------------------------------
    xIndex = CreateObject("roArray", 100, true)
    yIndex = CreateObject("roArray", 100, true)
    yValue = 600

    for i = 0 to 99
        if i > 0 and i mod 10 = 0 then
            yValue -= 60
        end if
        yIndex[i] = yValue
    end for
    value = 1
    for i = 0 to 99
        if (value mod 2) = 0 then
            xValue = 880 - (i mod 10) * 60
        else
            xValue = 340 + (i mod 10) * 60
        end if
        xIndex[i] = xValue
        if (i mod 10) = 9 then
            value += 1
        end if
    end for

    lns_flag = 0 'climb ladder or snake
    should_not_traverse_l_s = 1


    NewDiceValueP1 = 1
    NewDiceValueP2 = 1

    ' MainScreen(screen, font, firstPlayerSelect, secondplayerSelect, xIndex, yIndex, player1Level, player2Level, selectedPlayer, 1, 1)
    MainScreenmulti(screen, font, xIndex, yIndex, playersss, selectedPlayer)
    screen.SwapBuffers()
    while true
        msg = wait(0, port)
        if type(msg) = "roUniversalControlEvent" then
            key = msg.GetInt()
            if key = 6 then
                print "Current player=" + selectedPlayer.ToStr()
                newLevel = SelectPositionMulti(screen, font, port, selectedPlayer, xIndex, yIndex, should_not_traverse_l_s, playersss)
                ' newselectedplayer = newLevel.selectedPlayer
                ' newplayersss = newLevel.playersss
                currentplayerposition = playersss[selectedPlayer]["position"]
                currentdicevalue = newLevel.DiceValue
                ' selectedPlayer = newselectedplayer '~~~~~~~~~~~~~~~~~~~~~
                ' playersss = newplayersss '~~~~~~~~~~~~~~~~~~~~~
                playersss[selectedPlayer]["newDiceValue"] = currentdicevalue
                should_not_traverse_l_s = newLevel.should_not_traverse_l_s

                print "Player " + selectedPlayer.ToStr() + ":"
                for each key in playersss[selectedPlayer]
                    value = playersss[selectedPlayer][key]

                    print key + ": " + str(value)
                end for
                print "~~~~~~~~~~~~~~~~~~~~~~~"

                if CheckWinMulti(selectedPlayer, playersss) then
                    i = playersss[selectedPlayer]["oldLevel"]
                    newposition = 100
                    for j = i to newposition
                        playersss[selectedPlayer]["oldLevel"] += 1
                        MainScreenmulti(screen, font, xIndex, yIndex, playersss, selectedPlayer)
                        screen.SwapBuffers()
                        sleep(100)
                    end for
                    'Reset to new game

                end if

                'reset old position
                playersss[selectedPlayer]["oldLevel"] = playersss[selectedPlayer]["position"]

                'next roll
                if currentdicevalue = 6 then
                    playersss[selectedPlayer]["selected"] = 1
                else 'next pplayer
                    playersss[selectedPlayer]["selected"] = 0
                    selectedPlayer = (selectedPlayer + 1) mod numofplayers
                    playersss[selectedPlayer]["selected"] = 1
                end if

            end if


        end if

        MainScreenmulti(screen, font, xIndex, yIndex, playersss, selectedPlayer)
        screen.SwapBuffers()
        playersss[selectedPlayer]["oldLevel"] = playersss[selectedPlayer]["position"]
        should_not_traverse_l_s = 1


    end while
end sub

sub SelectPosition(screen as object, font as object, port as object, selectedPlayer as integer, player1Level as integer, player2Level as integer, firstPlayerSelect as boolean, secondplayerSelect as boolean, xIndex as object, yIndex as object, NewDiceValueP1 as integer, OldDiceValueP1 as integer, NewDiceValueP2 as integer, OldDiceValueP2 as integer, firstTimeSixP1 as integer, firstTimeSixP2 as integer, player1OldLevel as integer, player2OldLevel as integer, should_not_traverse_l_s as integer) as object

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
    if firstTimeSixP1 = 0 or firstTimeSixP2 = 0 then
        if FirstTimeDiceValue = 7 or FirstTimeDiceValue = 8 then
            FirstTimeDiceValue = 6
        end if
        DiceValue = FirstTimeDiceValue
    else
        DiceValue = Int(Rnd(6))
    end if

    if selectedPlayer = 1 then

        while animationTime < timeLimit
            frame = frameRegions[currentFrame]
            MainScreen(screen, font, firstPlayerSelect, secondplayerSelect, xIndex, yIndex, player1Level, player2Level, selectedPlayer, NewDiceValueP1, OldDiceValueP1, NewDiceValueP2, OldDiceValueP2)
            screen.DrawObject(100, 300, frame)
            screen.SwapBuffers()
            currentFrame = (currentFrame + 1) mod frameRegions.Count()
            animationTime = startTime.TotalMilliseconds()
        end while
        sleep(100)

        if firstTimeSixP1 = 0 then
            if DiceValue = 6 then
                firstTimeSixP1 = 1
                player1Level = 1
                return {
                    player1Level: player1Level
                    DiceValue: DiceValue
                    firstTimeSixP1: firstTimeSixP1
                    should_not_traverse_l_s: 1
                }
            else
                return {
                    player1Level: player1Level
                    DiceValue: DiceValue
                    firstTimeSixP1: firstTimeSixP1
                    should_not_traverse_l_s: 1
                }
            end if
        else if firstTimeSixP1 = 1 then
            if player1Level + DiceValue < 100 then
                player1Level += DiceValue
                temp1level = LadderAndSnake(player2Level, player1Level, selectedPlayer, should_not_traverse_l_s)
                player1Level = temp1level.player1Level
                shouldnot = temp1level.should_not_traverse_l_s
                return {
                    player1Level: player1Level
                    DiceValue: DiceValue
                    firstTimeSixP1: firstTimeSixP1
                    should_not_traverse_l_s: shouldnot
                }
            else
                return {
                    player1Level: 100
                    DiceValue: DiceValue
                    firstTimeSixP1: firstTimeSixP1
                    should_not_traverse_l_s: 1 'new game so resetto 1
                }
            end if
        else
            return {
                player1Level: player1Level
                DiceValue: DiceValue
                firstTimeSixP1: firstTimeSixP1
                should_not_traverse_l_s: 1
            }
        end if
    else if selectedPlayer = 2 then
        while animationTime < timeLimit
            frame = frameRegions[currentFrame]
            MainScreen(screen, font, firstPlayerSelect, secondplayerSelect, xIndex, yIndex, player1Level, player2Level, selectedPlayer, NewDiceValueP1, OldDiceValueP1, NewDiceValueP2, OldDiceValueP2)
            screen.DrawObject(1000, 300, frame)
            screen.SwapBuffers()
            currentFrame = (currentFrame + 1) mod frameRegions.Count()
            animationTime = startTime.TotalMilliseconds()
        end while

        sleep(100)

        if firstTimeSixP2 = 0 then
            if DiceValue = 6 then
                firstTimeSixP2 = 1
                player2Level = 1
                return {
                    player2Level: player2Level
                    DiceValue: DiceValue
                    firstTimeSixP2: firstTimeSixP2
                    should_not_traverse_l_s: 1
                }
            else
                return {
                    player2Level: player2Level
                    DiceValue: DiceValue
                    firstTimeSixP2: firstTimeSixP2
                    should_not_traverse_l_s: 1
                }
            end if
        else if firstTimeSixP2 = 1 then
            if player2Level + DiceValue < 101 then
                player2Level += DiceValue
                temp2level = LadderAndSnake(player2Level, player1Level, selectedPlayer, should_not_traverse_l_s)
                player2Level = temp2level.player2Level
                shouldnot = temp2level.should_not_traverse_l_s

                return {
                    player2Level: player2Level
                    DiceValue: DiceValue
                    firstTimeSixP2: firstTimeSixP2
                    should_not_traverse_l_s: shouldnot
                }
            else
                return {
                    player2Level: player2Level
                    DiceValue: DiceValue
                    firstTimeSixP2: firstTimeSixP2
                    should_not_traverse_l_s: 1
                }
            end if
        else
            return {
                player2Level: player2Level
                DiceValue: DiceValue
                firstTimeSixP2: firstTimeSixP2
                should_not_traverse_l_s: 1
            }
        end if
    end if
end sub

sub CheckWin(player1Level as integer, player2Level as integer) as boolean
    if player1Level = 100 then
        print "Player 1 Win"
        return true
    else if player2Level = 100 then
        print "Player 2 Win"
        return true
    end if
    return false
end sub

sub LadderAndSnake(player2Level as integer, player1Level as integer, selectedPlayer as integer, should_not_traverse_l_s as integer) as object
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

    result = CreateObject("roAssociativeArray") 'store level and shouldnot_travel_l_s flag
    result.should_not_traverse_l_s = should_not_traverse_l_s

    if selectedPlayer = 1 then
        for i = 0 to 7 '@#$
            if (LStart[i] = player1Level) then
                result.should_not_traverse_l_s = 0
                result.player1Level = LEnd[i]
                return result
            else if (SStart[i] = player1Level) then
                result.should_not_traverse_l_s = 0
                result.player1Level = SnEnd[i]
                return result
            end if
        end for
        result.player1Level = player1Level 'unchanged
        return result
    else if selectedPlayer = 2 then
        for i = 0 to 7
            if (LStart[i] = player2Level) then
                result.player2Level = LEnd[i]
                result.should_not_traverse_l_s = 0
                return result
            else if (SStart[i] = player2Level) then
                result.player2Level = SnEnd[i]
                result.should_not_traverse_l_s = 0
                return result
            end if
        end for
        result.player2Level = player2Level 'unchanged
        return result
    end if
end sub


sub MainScreen(screen as object, font as object, firstPlayerSelect as boolean, secondplayerSelect as boolean, xIndex as object, yIndex as object, player1Level as integer, player2Level as integer, selectedPlayer as integer, NewDiceValueP1 as integer, OldDiceValueP1 as integer, NewDiceValueP2 as integer, OldDiceValueP2 as integer)
    screen.SetAlphaEnable(true)
    screen.Clear(&hFFFFFFFF)
    bg = CreateObject("roBitmap", "pkg:/images/gamebg2.png")
    screen.DrawObject(0, 0, bg)

    board = CreateObject("roBitmap", "pkg:/images/Board.jpg")
    firstPlayer = CreateObject("roBitmap", "pkg:/images/P1.png")
    firstPlayersmall = CreateObject("roBitmap", "pkg:/images/P1small.png")
    secondPlayer = CreateObject("roBitmap", "pkg:/images/P2.png")
    secondPlayersmall = CreateObject("roBitmap", "pkg:/images/P2small.png")
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

    screen.DrawObject(100, 420, firstPlayer)
    screen.DrawObject(1000, 420, secondPlayer)
    screen.DrawObject(339, 59, board)
    if firstPlayerSelect then
        screen.DrawObject(100, 420, select)
    else if secondplayerSelect then
        screen.DrawObject(1000, 420, select)
    end if

    if selectedPlayer = 1 then
        if player1Level = 0 then
            if player2Level > 0 then
                screen.DrawObject(250, 600, firstPlayer)
                screen.DrawObject(xIndex[player2Level - 1], yIndex[player2Level - 1], secondPlayer)
                screen.DrawObject(100, 300, diceArray[OldDiceValueP1 - 1])
                screen.DrawObject(1000, 300, diceArray[NewDiceValueP2 - 1])
            else
                screen.DrawObject(250, 600, firstPlayer)
                screen.DrawObject(250, 500, secondPlayer)
                screen.DrawObject(100, 300, diceArray[OldDiceValueP1 - 1])
                screen.DrawObject(1000, 300, diceArray[NewDiceValueP2 - 1])
            end if
        else
            if player2Level = 0 then
                screen.DrawObject(250, 500, secondPlayer)
                screen.DrawObject(xIndex[player1Level - 1], yIndex[player1Level - 1], firstPlayer)
                screen.DrawObject(100, 300, diceArray[NewDiceValueP1 - 1])
                screen.DrawObject(1000, 300, diceArray[OldDiceValueP2 - 1])
            else
                if(player1Level = player2Level) then
                    screen.DrawObject(xIndex[player1Level - 1], yIndex[player1Level - 1], firstPlayersmall)
                    screen.DrawObject(xIndex[player2Level - 1] + 40, yIndex[player2Level - 1] + 40, secondPlayersmall)
                else
                    screen.DrawObject(xIndex[player1Level - 1], yIndex[player1Level - 1], firstPlayer)
                    screen.DrawObject(xIndex[player2Level - 1], yIndex[player2Level - 1], secondPlayer)
                end if
                screen.DrawObject(100, 300, diceArray[NewDiceValueP1 - 1])
                screen.DrawObject(1000, 300, diceArray[OldDiceValueP2 - 1])
            end if
        end if
    else if selectedPlayer = 2 then
        if player2Level = 0 then
            if player1Level > 0 then
                screen.DrawObject(xIndex[player1Level - 1], yIndex[player1Level - 1], firstPlayer)
                screen.DrawObject(250, 500, secondPlayer)
                screen.DrawObject(100, 300, diceArray[OldDiceValueP1 - 1])
                screen.DrawObject(1000, 300, diceArray[NewDiceValueP2 - 1])
            else
                screen.DrawObject(250, 600, firstPlayer)
                screen.DrawObject(250, 500, secondPlayer)
                screen.DrawObject(100, 300, diceArray[OldDiceValueP1 - 1])
                screen.DrawObject(1000, 300, diceArray[NewDiceValueP2 - 1])
            end if
        else
            if player1Level = 0 then
                screen.DrawObject(250, 600, firstPlayer)
                screen.DrawObject(xIndex[player2Level - 1], yIndex[player2Level - 1], secondPlayer)
                screen.DrawObject(100, 300, diceArray[OldDiceValueP1 - 1])
                screen.DrawObject(1000, 300, diceArray[NewDiceValueP2 - 1])
            else
                if(player1Level = player2Level) then
                    screen.DrawObject(xIndex[player2Level - 1], yIndex[player2Level - 1], secondPlayersmall)
                    screen.DrawObject(xIndex[player1Level - 1] + 40, yIndex[player1Level - 1] + 40, firstPlayersmall)
                else
                    screen.DrawObject(xIndex[player2Level - 1], yIndex[player2Level - 1], secondPlayer)
                    screen.DrawObject(xIndex[player1Level - 1], yIndex[player1Level - 1], firstPlayer)
                end if
                screen.DrawObject(100, 300, diceArray[OldDiceValueP1 - 1])
                screen.DrawObject(1000, 300, diceArray[NewDiceValueP2 - 1])
            end if
        end if
    end if

end sub








' mainscreen while traversing ladde r or snake
sub MainScreenLS(screen as object, font as object, firstPlayerSelect as boolean, secondplayerSelect as boolean, xIndex as object, yIndex as object, player1Level as integer, player2Level as integer, selectedPlayer as integer, NewDiceValueP1 as integer, OldDiceValueP1 as integer, NewDiceValueP2 as integer, OldDiceValueP2 as integer, currplayer as integer, xi as integer, yi as integer)
    screen.SetAlphaEnable(true)
    screen.Clear(&hFFFFFFFF)
    bg = CreateObject("roBitmap", "pkg:/images/gamebg2.png")
    screen.DrawObject(0, 0, bg)

    board = CreateObject("roBitmap", "pkg:/images/Board.jpg")
    firstPlayer = CreateObject("roBitmap", "pkg:/images/P1.png")
    firstPlayersmall = CreateObject("roBitmap", "pkg:/images/P1small.png")
    secondPlayer = CreateObject("roBitmap", "pkg:/images/P2.png")
    secondPlayersmall = CreateObject("roBitmap", "pkg:/images/P2small.png")
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

    screen.DrawObject(100, 400, firstPlayer)
    screen.DrawObject(1000, 400, secondPlayer)
    screen.DrawObject(339, 59, board)
    if firstPlayerSelect then
        screen.DrawObject(100, 400, select)
    else if secondplayerSelect then
        screen.DrawObject(1000, 400, select)
    end if

    if currplayer = 1 then
        if player2Level = 0 then
            screen.DrawObject(250, 500, secondPlayer)
            screen.DrawObject(xi, yi, firstPlayer)
            screen.DrawObject(150, 300, diceArray[NewDiceValueP1 - 1])
            screen.DrawObject(1000, 300, diceArray[OldDiceValueP2 - 1])
        else
            if(player1Level = player2Level) then
                screen.DrawObject(xi, yi, firstPlayersmall)
                screen.DrawObject(xIndex[player2Level - 1] + 20, yIndex[player2Level - 1] + 20, secondPlayersmall)
            else
                screen.DrawObject(xi, yi, firstPlayer)
                screen.DrawObject(xIndex[player2Level - 1], yIndex[player2Level - 1], secondPlayer)
            end if
            screen.DrawObject(150, 300, diceArray[NewDiceValueP1 - 1])
            screen.DrawObject(1000, 300, diceArray[OldDiceValueP2 - 1])
        end if


    else if currplayer = 2 then
        if player1Level = 0 then
            screen.DrawObject(250, 600, firstPlayer)
            screen.DrawObject(xi, yi, secondPlayer)
            screen.DrawObject(150, 300, diceArray[OldDiceValueP1 - 1])
            screen.DrawObject(1000, 300, diceArray[NewDiceValueP2 - 1])
        else
            if(player1Level = player2Level) then
                screen.DrawObject(xi, yi, secondPlayersmall)
                screen.DrawObject(xIndex[player1Level - 1] + 20, yIndex[player1Level - 1] + 20, firstPlayersmall)
            else
                screen.DrawObject(xi, yi, secondPlayer)
                screen.DrawObject(xIndex[player1Level - 1], yIndex[player1Level - 1], firstPlayer)
            end if
            screen.DrawObject(150, 300, diceArray[OldDiceValueP1 - 1])
            screen.DrawObject(1000, 300, diceArray[NewDiceValueP2 - 1])
        end if

    end if
end sub



