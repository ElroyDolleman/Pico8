pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
snake = {}
food = 0

dir_x = 1
dir_y = 0
new_dir_x = 1
new_dir_y = 0

dead = false

cols = 16
rows = 16

update_rate = 3
wait = 0

function to_grid_index(x,y)
	return y * rows + x
end

function to_world_x(i)
	return i - flr(i / rows) * rows
end

function to_world_y(i)
	return flr(i / rows)
end

function _update()

	if dead then return end
	
	if btn(0) and dir_x == 0 then
		new_dir_x = -1
		new_dir_y = 0
	elseif btn(1) and dir_x == 0 then
		new_dir_x = 1
		new_dir_y = 0
	elseif btn(2) and dir_y == 0 then
		new_dir_x = 0
		new_dir_y = -1
	elseif btn(3) and dir_y == 0 then
		new_dir_x = 0
		new_dir_y = 1
	end
	
	if wait < update_rate then
		wait = wait + 1
		return 
	end
	wait = 0
	
	dir_x = new_dir_x
	dir_y = new_dir_y
	
	-- calculate next pos
	x = to_world_x(snake[1])+dir_x
	y = to_world_y(snake[1])+dir_y
	
	-- chekk if snake dies
	if x >= rows or	y >= cols or 
		x < 0 or y < 0 
		then
			dead = true
			return
	end
	
	newpos = to_grid_index(x,y)
	
	-- check if died
	for i = #snake,3,-1 do
		if snake[i-1] == newpos then
			dead = true
		end
	end
	
	-- dont update pos if dead
	if dead then return end
	
	if newpos == food then
		randomize_food_pos(newpos)
		add(snake, snake[#snake])
	end
	
	-- update tail
	for i = #snake,2,-1 do
		snake[i] = snake[i-1]
	end
	
	-- update snake pos
	snake[1] = newpos
end

function randomize_food_pos(nextpos)
	food = flr(rnd(rows * cols))
	
	if food == nextpos then
		randomize_food_pos(nextpos)
		return
	end
	
	for i = 1,#snake do
		if food == snake[i] then
			randomize_food_pos(nextpos)
			return
		end
	end
	
	x = to_world_x(nextpos)+dir_x
	y = to_world_y(nextpos)+dir_y
	nextpos2 = to_grid_index(x,y)
	
	if food == nextpos2 then
		randomize_food_pos(nextpos)
		return
	end
	
end

function _draw()
	cls()
	-- border
	rect(0,0,127,127,1)
	
	-- snake color
	col = 11
	if dead then col = 8 end
	
	for i = 1,#snake do
		x = to_world_x(snake[i]) * 8
		y = to_world_y(snake[i]) * 8
		
		rectfill(x,y,x+8,y+8,col)
	end
	
	x = to_world_x(food) * 8
	y = to_world_y(food) * 8
	
	rectfill(x+3,y+3,x+5,y+5,7)
end

randomize_food_pos(5)
--add(snake, to_grid_index(6,8))
--add(snake, to_grid_index(5,8))
add(snake, to_grid_index(4,8))
add(snake, to_grid_index(3,8))
add(snake, to_grid_index(2,8))
add(snake, to_grid_index(1,8))
add(snake, to_grid_index(0,8))
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
