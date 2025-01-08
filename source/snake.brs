function Snakesss()
    Snake = CreateObject("roArray", 8, true)

    Snake[0] = CreateObject("roArray", 6, true)
    Snake[1] = CreateObject("roArray", 6, true)
    Snake[2] = CreateObject("roArray", 6, true)
    Snake[3] = CreateObject("roArray", 6, true)
    Snake[4] = CreateObject("roArray", 5, true)
    Snake[5] = CreateObject("roArray", 6, true)
    Snake[6] = CreateObject("roArray", 5, true)
    Snake[7] = CreateObject("roArray", 9, true)


    ' Snake1
    Snake[0][0] = 27
    Snake[0][1] = 14
    Snake[0][2] = 15
    Snake[0][3] = 7
    Snake[0][4] = 6
    Snake[0][5] = 5

    'Snake2
    Snake[1][0] = 40
    Snake[1][1] = 22
    Snake[1][2] = 19
    Snake[1][3] = 18
    Snake[1][4] = 2
    Snake[1][5] = 3

    'Snake3
    Snake[2][0] = 43
    Snake[2][1] = 37
    Snake[2][2] = 24
    Snake[2][3] = 23
    Snake[2][4] = 22
    Snake[2][5] = 18

    'Snake4
    Snake[3][0] = 54
    Snake[3][1] = 47
    Snake[3][2] = 48
    Snake[3][3] = 49
    Snake[3][4] = 32
    Snake[3][5] = 31

    'Snake5
    Snake[4][0] = 66
    Snake[4][1] = 56
    Snake[4][2] = 55
    Snake[4][3] = 46
    Snake[4][4] = 45

    'Snake6
    Snake[5][0] = 76
    Snake[5][1] = 65
    Snake[5][2] = 55
    Snake[5][3] = 56
    Snake[5][4] = 57
    Snake[5][4] = 58

    'Snake7
    Snake[6][0] = 89
    Snake[6][1] = 72
    Snake[6][2] = 69
    Snake[6][3] = 68
    Snake[6][4] = 53

    'Snake8
    Snake[7][0] = 99
    Snake[7][1] = 82
    Snake[7][2] = 79
    Snake[7][3] = 78
    Snake[7][4] = 63
    Snake[7][4] = 58
    Snake[7][4] = 59
    Snake[7][4] = 60
    Snake[7][4] = 41

    return Snake
end function