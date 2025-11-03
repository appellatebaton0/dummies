
// Player

player = {

	movement_speed = 1.4,

	init=function(this)
		this.x = 64
		this.y = 64
	end,

	update=function(this)
		if (btn(0)) then this.x = this.x - this.movement_speed end
		if (btn(1)) then this.x = this.x + this.movement_speed end
		if (btn(2)) then this.y = this.y - this.movement_speed end
		if (btn(3)) then this.y = this.y + this.movement_speed end
	end
}

function _init()
	player:init()
end

function _update()
	player:update()
end

function _draw()
	cls(4)
	print(player.x, 2, 2, 0)
	circfill(player.x, player.y, 5, 3)
end