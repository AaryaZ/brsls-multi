
sub ModeSelection(numofplayers as integer) as object
    mode_port = CreateObject("roMessagePort")
    screen = CreateObject("roScreen", true, 1280, 720)
    screen.SetMessagePort(mode_port)
    BackgroundImg = "pkg:/images/junglebg.png"
    twoplayer = CreateObject("roBitmap", "pkg:/images/2pn.png")
    twoplayerselected = CreateObject("roBitmap", "pkg:/images/2ps.png")
    threeplayer = CreateObject("roBitmap", "pkg:/images/3pn.png")
    threeplayerselected = CreateObject("roBitmap", "pkg:/images/3ps.png")
    fourplayer = CreateObject("roBitmap", "pkg:/images/4pn.png")
    fourplayerselected = CreateObject("roBitmap", "pkg:/images/4ps.png")

    TwoPlayerMode = true
    ThreePlayerMode = false
    FourPlayerMode = false

    'display mode screen
    DisplayModeSelection(BackgroundImg, twoplayer, twoplayerselected, threeplayer, threeplayerselected, fourplayer, fourplayerselected, screen, TwoPlayerMode, ThreePlayerMode, FourPlayerMode)

    modeselected = true
    print "select number of players"
    while modeselected
        mode_msg = mode_port.GetMessage()
        if type(mode_msg) = "roUniversalControlEvent" then
            key = mode_msg.GetInt()
            if key = 0 then
                modeselected = false

            else if key = 2 then
                if FourPlayerMode then '4 se 3
                    TwoPlayerMode = false
                    ThreePlayerMode = true
                    FourPlayerMode = false
                else if ThreePlayerMode then '3 se 2
                    TwoPlayerMode = true
                    ThreePlayerMode = false
                    FourPlayerMode = false
                else if TwoPlayerMode then 'stay at 2
                    TwoPlayerMode = true
                    ThreePlayerMode = false
                    FourPlayerMode = false
                end if
            else if key = 3 then
                if TwoPlayerMode then '2 se 3 niche
                    TwoPlayerMode = false
                    ThreePlayerMode = true
                    FourPlayerMode = false
                else if ThreePlayerMode then '3 se 4 niche
                    TwoPlayerMode = false
                    ThreePlayerMode = false
                    FourPlayerMode = true
                else if FourPlayerMode then 'stay at 4
                    TwoPlayerMode = false
                    ThreePlayerMode = false
                    FourPlayerMode = true
                end if
            else if key = 6 then
                if TwoPlayerMode then
                    numofplayers = 2
                    modeselected = false
                else if ThreePlayerMode then
                    numofplayers = 3
                    modeselected = false
                else if FourPlayerMode then
                    numofplayers = 4
                    modeselected = false
                end if
            end if
            DisplayModeSelection(BackgroundImg, twoplayer, twoplayerselected, threeplayer, threeplayerselected, fourplayer, fourplayerselected, screen, TwoPlayerMode, ThreePlayerMode, FourPlayerMode)
        end if
    end while
    return {
        numofplayers: numofplayers
    }
end sub

'display mode selection screen
sub DisplayModeSelection(BackgroundImg as string, twoplayer as object, twoplayerselected as object, threeplayer as object, threeplayerselected as object, fourplayer as object, fourplayerselected as object, screen as object, TwoPlayerMode as boolean, ThreePlayerMode as boolean, FourPlayerMode as boolean)
    screen.SetAlphaEnable(true)
    screen.Clear(&h000000FF)
    Gamebackground(screen, BackgroundImg)
    if TwoPlayerMode then
        screen.drawObject(450, 130, twoplayerselected)
        screen.drawObject(450, 260, threeplayer)
        screen.DrawObject(450, 420, fourplayer)
    else if ThreePlayerMode then
        screen.drawObject(450, 130, twoplayer)
        screen.drawObject(450, 280, threeplayerselected)
        screen.DrawObject(450, 420, fourplayer)
    else if FourPlayerMode then
        screen.drawObject(450, 130, twoplayer)
        screen.drawObject(450, 260, threeplayer)
        screen.DrawObject(450, 420, fourplayerselected)
    end if
    screen.SwapBuffers()
end sub

'method for display bg image
sub Gamebackground(screen as object, game_background_image as string)
    image = CreateObject("roBitmap", game_background_image)
    screen.DrawObject(0, 0, image)
end sub