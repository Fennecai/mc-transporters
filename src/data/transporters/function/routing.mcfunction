blockpositions = [("north","~ ~ ~-1"),("south","~ ~ ~1"),("east","~1 ~ ~"),("west","~-1 ~ ~")]

maximum_routes = 32



#python function to power or unpower redstone repeaters around "this" position
def powerredstone(on):
    for dir,pos in blockpositions:
        if on == true:
            if block pos minecraft:redstone_wire:
                setblock pos minecraft:redstone_block
        if on == false:
            if block pos minecraft:redstone_block:
                setblock pos minecraft:redstone_wire
        

for dir,pos in blockpositions:
    for route in range(0,maximum_routes):
        execute as @e[type=#transporters:carts] at @s if block ~ ~ ~ minecraft:rail:
            if data block pos {Page:route}:
                scoreboard players set @s transporters_route route



for dir,pos in blockpositions:
    for route in range(0,maximum_routes):
        execute as @e[type=#transporters:carts] at @s if score @s transporters_route matches route if block ~ ~ ~ minecraft:detector_rail[powered=true]:
            if block pos minecraft:lectern:
                if data block pos {Page:route}:
                    positioned pos:
                        powerredstone(true)
                unless data block pos {Page:route}:
                    positioned pos:
                        powerredstone(false)
