
#place lime wool under the tracks to turn the cart's engine on. the cart will travel on rails constantly in the direction it is facing once this happens. naming an armor stand "pointer" and placing it near a cart can help to debug the direction.
#place red wool under the tracks to make the cart's engine "turn off". this will not stop the cart, but will prevent it being infinitely powered.
#place purple wool under the tracks to make the cart begin to fly towards the nearest armor stand named "endpoint." Armor stands named "endpoint" will float in place. once the cart arrives, it will stop trying to fly towards the armor stand.
# place pink wool under the trakcs to force entities nearby the cart to mount it.
# magenta wool does the same as pink wool, but only for players.



# power the carts based on direction
#0
execute as @e[type=#minecraft:carts,tag=transporter] if entity @s[y_rotation=0] run data merge entity @s {Motion: [-2.054d, 0.0d, 0.0d]}
#45
execute as @e[type=#minecraft:carts,tag=transporter] if entity @s[y_rotation=44..46] run data merge entity @s {Motion: [-2.054d, 0.0d, -2.054d]}
#90
execute as @e[type=#minecraft:carts,tag=transporter] if entity @s[y_rotation=90] run data merge entity @s {Motion: [0.0d, 0.0d, -2.054d]}
#135
execute as @e[type=#minecraft:carts,tag=transporter] if entity @s[y_rotation=134..136] run data merge entity @s {Motion: [2.054d, 0.0d, -2.054d]}
#180
execute as @e[type=#minecraft:carts,tag=transporter] if entity @s[y_rotation=180] run data merge entity @s {Motion: [2.054d, 0.0d, 0.0d]}
#225
execute as @e[type=#minecraft:carts,tag=transporter] if entity @s[y_rotation=224..226] run data merge entity @s {Motion: [2.054d, 0.0d, 2.054d]}
#270
execute as @e[type=#minecraft:carts,tag=transporter] if entity @s[y_rotation=270] run data merge entity @s {Motion: [0.0d, 0.0d, 2.054d]}
#315
execute as @e[type=#minecraft:carts,tag=transporter] if entity @s[y_rotation=314..316] run data merge entity @s {Motion: [-2.054d, 0.0d, 2.054d]}






# start / stop engine
execute as @e[type=#minecraft:carts] at @s if block ~ ~-1 ~ red_wool run tag @s remove transporter
execute as @e[type=#minecraft:carts] at @s unless block ~ ~-1 ~ #rails run execute as @s at @s unless block ~ ~ ~ #rails run tag @s remove transporter
execute as @e[type=#minecraft:carts] at @s if block ~ ~-1 ~ lime_wool run tag @s add transporter


#from all my testing; i've realised that carts will always travel as such:
# 1. carts start off facing in positive Z (north). they then face the direction they are moving as soon as they actually move.
# 2. carts always travel south or east when coming to a junction. they travel in whichever direction is parralel to the rail they are coming onto.
# 3. this is difficult to understand in-game without toggling hitboxes (f3+b), so thats why i added the pointers- simply name an armor stand "pointer", and when a cart passes nearby, it'll turn into a block display that shows the cart's front at all times.

execute at @e[type=#minecraft:carts] as @e[type=minecraft:armor_stand,name="pointer",distance=0..4] run tp @s ^-0.5 ^ ^ ~ ~
execute at @e[type=#minecraft:carts] as @e[type=minecraft:armor_stand,name="pointer",distance=0..4] run function transporters:pointerplacer
execute as @e[type=block_display,tag=cartpointer] at @s run function transporters:pointer


#the function that enebles the purple wool behavior.
function transporters:airship


#-----
# new 1.20 functionality
#-----

#pink wool forcibly mounts nearby entities into the minecart
execute as @e[type=#minecraft:carts] at @s if block ~ ~-1 ~ minecraft:pink_wool run ride @e[type=!#minecraft:carts,type=!item,type=!item_frame,type=!falling_block,limit=1,distance=..2,sort=nearest] mount @s

#magenta wool does the same as pink wool, but only for players
execute as @e[type=#minecraft:carts] at @s if block ~ ~-1 ~ minecraft:magenta_wool run ride @e[type=player,limit=1,distance=..2,sort=nearest] mount @s