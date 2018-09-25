function playercontrol = musiccontrol(player,controlcode)
switch controlcode
    case 1
        player.play
    case 2
        stop(player);
end

