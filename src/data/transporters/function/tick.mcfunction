from nbtlib import Byte

blockpositions = [("north","~ ~ ~-1"),("south","~ ~ ~1"),("east","~1 ~ ~"),("west","~-1 ~ ~")]



#python function to power carts forward depending on direction
def powercartsforward():
    # power the carts based on direction (comments are the rotation in degrees)
    #0
    if entity @s[y_rotation=0] run data merge entity @s {Motion: [-8.0d, 0.0d, 0.0d]}
    #45
    if entity @s[y_rotation=44..46] run data merge entity @s {Motion: [-8.0d, 0.0d, -8.0d]}
    #90
    if entity @s[y_rotation=90] run data merge entity @s {Motion: [0.0d, 0.0d, -8.0d]}
    #135
    if entity @s[y_rotation=134..136] run data merge entity @s {Motion: [8.0d, 0.0d, -8.0d]}
    #180
    if entity @s[y_rotation=180] run data merge entity @s {Motion: [8.0d, 0.0d, 0.0d]}
    #225
    if entity @s[y_rotation=224..226] run data merge entity @s {Motion: [8.0d, 0.0d, 8.0d]}
    #270
    if entity @s[y_rotation=270] run data merge entity @s {Motion: [0.0d, 0.0d, 8.0d]}
    #315
    if entity @s[y_rotation=314..316] run data merge entity @s {Motion: [-8.0d, 0.0d, 8.0d]}

#python function to power or unpower redstone repeaters around "this" position
def powerredstone(on):
    for dir,pos in blockpositions:
        if on == true:
            if block pos minecraft:redstone_wire:
                setblock pos minecraft:redstone_block
        if on == false:
            if block pos minecraft:redstone_block:
                setblock pos minecraft:redstone_wire



# power carts forward if they have the "engine" started:
execute as @e[type=#transporters:carts,tag=transporter]:
    powercartsforward()

# start / stop engine
execute as @e[type=#transporters:carts] at @s:
    if block ~ ~-1 ~ #transporters:stop_if_present run tag @s remove transporter
    unless block ~ ~-1 ~ #minecraft:rails run execute as @s at @s unless block ~ ~ ~ #rails run tag @s remove transporter
    if block ~ ~-1 ~ #transporters:start_if_present run tag @s add transporter

#"Pointer" armor stands that indicate a cart's front direction
execute at @e[type=#transporters:carts] as @e[type=minecraft:armor_stand,name="pointer",distance=0..2]:
    tp @s ^-0.5 ^ ^ ~ ~
    data merge entity @s {Marker: 1b}
    execute at @s run summon minecraft:block_display ~-0.5 ~-0.5 ~-0.5 {Tags: ["cartpointer"], Passengers: [{id: "minecraft:block_display", block_state: {Name: "minecraft:hopper", Properties: {}}, transformation: [0.5000f, 0.0000f, 0.0000f, 0.2500f, 0.0000f, 0.0000f, -0.0625f, 0.5000f, 0.0000f, 0.5000f, 0.0000f, 0.2500f, 0.0000f, 0.0000f, 0.0000f, 1.0000f], Tags: ["cartpointer"]}]}
    kill @s
execute as @e[type=minecraft:block_display,tag=cartpointer] at @s:
    execute unless entity @e[type=#transporters:carts,distance=..3,limit=1] run kill @s
    execute at @e[type=#transporters:carts,distance=..3,limit=1] run tp @s ^ ^0.5 ^0.5 ~-90 ~0

# Flying carts behavior
execute as @e[type=#transporters:carts] at @s:
    if block ~ ~-1 ~ #transporters:fly_if_present run tag @s add airship
    if block ~ ~-1 ~ #transporters:stop_if_present run tag @s remove airship
execute as @e[tag=airship,type=#transporters:carts] at @s:
    if entity @e[type=minecraft:armor_stand,name="endpoint",distance=..7,sort=nearest,limit=1]:
        facing entity @e[type=minecraft:armor_stand,name="endpoint",limit=1,sort=nearest] feet run tp @s ^ ^0.1 ^0.3 facing entity @e[type=minecraft:armor_stand,name="endpoint",limit=1,sort=nearest]
    unless entity @e[type=minecraft:armor_stand,name="endpoint",distance=..7,sort=nearest,limit=1]:
        facing entity @e[type=minecraft:armor_stand,name="endpoint",limit=1,sort=nearest] feet run tp @s ^ ^0.2 ^0.7 facing entity @e[type=minecraft:armor_stand,name="endpoint",limit=1,sort=nearest]
# endpoint armor stands behavior
execute as @e[type=minecraft:armor_stand,name="endpoint"] at @s run tag @e[tag=airship,type=#transporters:carts,distance=0.1..0.2] remove airship
execute as @e[type=minecraft:armor_stand,name="endpoint"] run data merge entity @s {NoGravity: 1b}
execute as @e[type=minecraft:armor_stand,name="endpoint"] at @s align xyz run tp @s ~0.5 ~ ~0.5

#pink wool forcibly mounts nearby entities into the minecart
execute as @e[type=#transporters:carts] at @s if block ~ ~-1 ~ #transporters:mount_ents_if_present run ride @e[type=!#transporters:carts,type=!item,type=!item_frame,type=!falling_block,limit=1,distance=..2,sort=nearest] mount @s

#magenta wool does the same as pink wool, but only for players
execute as @e[type=#transporters:carts] at @s if block ~ ~-1 ~ #transporters:mount_players_if_present run ride @e[type=player,limit=1,distance=..2,sort=nearest] mount @s

#orange wool destroys carts
execute as @e[type=#transporters:carts] at @s if block ~ ~-1 ~ #transporters:destroy_if_present run kill @s

#carts climb ladders and shelves
execute as @e[type=#transporters:carts] at @s if block ~ ~ ~ #transporters:climb_if_present:
    data merge entity @s {Motion: [0.0d, 0.50d, 0.0d]}
execute as @e[type=#transporters:carts] at @s if block ~ ~-1 ~ #transporters:climb_if_present if block ~ ~ ~ #minecraft:air:
    powercartsforward()

#carts change direction when passing over a tripwire with magenta glazed terracotta underneath it
execute as @e[type=#transporters:carts] at @s if block ~ ~ ~ minecraft:tripwire:
    execute as @e[type=#transporters:carts] at @s if block ~ ~-1 ~ minecraft:magenta_glazed_terracotta[facing=north]:
        tp @s ~ ~ ~ -90 ~
        data merge entity @s {rotation:[-90,0]}
    execute as @e[type=#transporters:carts] at @s if block ~ ~-1 ~ minecraft:magenta_glazed_terracotta[facing=south]:
        tp @s ~ ~ ~ 90 ~
        data merge entity @s {rotation:[180,0]}
    execute as @e[type=#transporters:carts] at @s if block ~ ~-1 ~ minecraft:magenta_glazed_terracotta[facing=east]:
        tp @s ~ ~ ~ 0 ~
        data merge entity @s {rotation:[0,0]}
    execute as @e[type=#transporters:carts] at @s if block ~ ~-1 ~ minecraft:magenta_glazed_terracotta[facing=west]:
        tp @s ~ ~ ~ 180 ~
        data merge entity @s {rotation:[180,0]}
    powercartsforward()

#item frame entity detector rails
entities = [(0,@a[distance=0..0.5,sort=nearest,limit=1],"Players"),(1,@e[type=!player,type=!#transporters:carts,distance=0..0.5],"Non-players"),(2,@e[type=#minecraft:undead,distance=0..0.5],"Undead"),(3,@e[type=#minecraft:illager,distance=0..0.5],"Illagers"),(4,@e[type=minecraft:villager,distance=0..0.5],"Villagers"),(5,@e[type=#transporters:animals,distance=0..0.5],"Animals"),(6,@e[type=minecart,distance=0..0.5,predicate=!transporters:passengers],"Empty Carts"),(7,@e[type=chest_minecart,distance=0..0.5],"Chest Carts")]

for coordname,coords in blockpositions:
    for rot,sel,name in entities:
        execute as @e[type=item_frame,nbt={Item:{count:1,id:"minecraft:detector_rail"},ItemRotation:Byte(rot)}] at @s:
            if entity @e[type=text_display,limit=1,sort=nearest,distance=0..0.5,tag=routing_frame_text]:
                if entity @e[type=text_display,limit=1,sort=nearest,distance=0..0.5,nbt=!{text:f"{name}"}]:
                    data merge entity @e[type=minecraft:text_display,limit=1,sort=nearest,distance=0..0.5] {text:f"{name}"}
            unless entity @e[type=text_display,limit=1,sort=nearest,distance=0..0.5,tag=routing_frame_text]:
                summon minecraft:text_display ~ ~0.25 ~ {Tags:["routing_frame_text"], alignment: "center", background: 0, billboard: "center", brightness: {block: 15, sky: 15}, default_background: 0b, line_width: 200, see_through: 0b, shadow: 1b, text: f"{name}", text_opacity: -1b}
            positioned coords if block ~ ~ ~ minecraft:detector_rail[powered=true] 
                if entity sel:
                    scoreboard players set @s detector_frame_score 20

execute as @e[type=text_display,tag=routing_frame_text] at @s unless entity @e[type=item_frame,sort=nearest,distance=0..0.5,nbt={Item:{id:"minecraft:detector_rail",count:1}}]:
    kill @s

execute as @e[type=item_frame,nbt={Item:{count:1,id:"minecraft:detector_rail"}}] at @s if score @s detector_frame_score matches 1..20:
    powerredstone(true)
    scoreboard players remove @s detector_frame_score 1
execute as @e[type=item_frame,nbt={Item:{count:1,id:"minecraft:detector_rail"}}] at @s if score @s detector_frame_score matches -3..0:
    powerredstone(false)

#routing using lecterns
function transporters:routing