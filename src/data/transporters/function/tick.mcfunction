
# power the carts based on direction (comments are the rotation in degrees)
#0
execute as @e[type=#minecraft:carts,tag=transporter]:
    if entity @s[y_rotation=0] run data merge entity @s {Motion: [-2.054d, 0.0d, 0.0d]}
#45
    if entity @s[y_rotation=44..46] run data merge entity @s {Motion: [-2.054d, 0.0d, -2.054d]}
#90
    if entity @s[y_rotation=90] run data merge entity @s {Motion: [0.0d, 0.0d, -2.054d]}
#135
    if entity @s[y_rotation=134..136] run data merge entity @s {Motion: [2.054d, 0.0d, -2.054d]}
#180
    if entity @s[y_rotation=180] run data merge entity @s {Motion: [2.054d, 0.0d, 0.0d]}
#225
    if entity @s[y_rotation=224..226] run data merge entity @s {Motion: [2.054d, 0.0d, 2.054d]}
#270
    if entity @s[y_rotation=270] run data merge entity @s {Motion: [0.0d, 0.0d, 2.054d]}
#315
    if entity @s[y_rotation=314..316] run data merge entity @s {Motion: [-2.054d, 0.0d, 2.054d]}

# start / stop engine
execute as @e[type=#minecraft:carts] at @s:
    if block ~ ~-1 ~ red_wool run tag @s remove transporter
    unless block ~ ~-1 ~ #rails run execute as @s at @s unless block ~ ~ ~ #rails run tag @s remove transporter
    if block ~ ~-1 ~ lime_wool run tag @s add transporter

#"Pointer" armor stands that indicate a cart's front direction
execute at @e[type=#minecraft:carts] as @e[type=minecraft:armor_stand,name="pointer",distance=0..2]:
    tp @s ^-0.5 ^ ^ ~ ~
    data merge entity @s {Marker: 1b}
    execute at @s run summon block_display ~-0.5 ~-0.5 ~-0.5 {Tags: ["cartpointer"], Passengers: [{id: "minecraft:block_display", block_state: {Name: "minecraft:hopper", Properties: {}}, transformation: [0.5000f, 0.0000f, 0.0000f, 0.2500f, 0.0000f, 0.0000f, -0.0625f, 0.5000f, 0.0000f, 0.5000f, 0.0000f, 0.2500f, 0.0000f, 0.0000f, 0.0000f, 1.0000f], Tags: ["cartpointer"]}]}
    kill @s
execute as @e[type=block_display,tag=cartpointer] at @s:
    execute unless entity @e[type=#minecraft:carts,distance=..3,limit=1] run kill @s
    execute at @e[type=#minecraft:carts,distance=..3,limit=1] run tp @s ^ ^0.5 ^0.5 ~-90 ~0

# Flying carts behavior
execute as @e[type=#minecraft:carts] at @s:
    if block ~ ~-1 ~ purple_wool run tag @s add airship
    if block ~ ~-1 ~ red_wool run tag @s remove airship
execute as @e[tag=airship,type=#minecraft:carts] at @s facing entity @e[type=minecraft:armor_stand,name="endpoint",limit=1,sort=nearest] feet run tp @s ^ ^0.1 ^0.3 facing entity @e[type=minecraft:armor_stand,name="endpoint",limit=1,sort=nearest]
# endpoint armor stands behavior
execute as @e[type=minecraft:armor_stand,name="endpoint"] at @s run tag @e[tag=airship,type=#minecraft:carts,distance=0.1..0.2] remove airship
execute as @e[type=minecraft:armor_stand,name="endpoint"] run data merge entity @s {NoGravity: 1b}
execute as @e[type=minecraft:armor_stand,name="endpoint"] at @s align xyz run tp @s ~0.5 ~ ~0.5

#pink wool forcibly mounts nearby entities into the minecart
execute as @e[type=#minecraft:carts] at @s if block ~ ~-1 ~ minecraft:pink_wool run ride @e[type=!#minecraft:carts,type=!item,type=!item_frame,type=!falling_block,limit=1,distance=..2,sort=nearest] mount @s

#magenta wool does the same as pink wool, but only for players
execute as @e[type=#minecraft:carts] at @s if block ~ ~-1 ~ minecraft:magenta_wool run ride @e[type=player,limit=1,distance=..2,sort=nearest] mount @s