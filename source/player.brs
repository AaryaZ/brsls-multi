function processPlayers(numPlayers)
    players = []

    for i = 1 to numPlayers
        player = {
            "selected": 0,
            "position": 0,
            "oldLevel": 1,
            "newDiceValue": 1,
            "oldDiceValue": 0,
            "consecutivesixes": 0,
            "firsTimeSix": 0

        }
        players.push(player)
    end for

    return players
end function



' selectedPlayer = (selectedPlayer + 1) mod numPlayers



