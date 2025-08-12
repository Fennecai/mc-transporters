#purple wool enables the carts to fly towards the nearest armor stand named "endpoint".. this causes the cart's "motor" to "turn off" (removal of the transporter tag) due to the strict rail detection previously set in place.
# note that carts will always go toward the NEAREST armor stand named "endpoint"; in a straight line, and pass through walls if necessary.


execute as @e[type=#minecraft:carts] at @s if block ~ ~-1 ~ purple_wool run tag @s add airship
execute as @e[type=#minecraft:carts] at @s if block ~ ~-1 ~ red_wool run tag @s remove airship
execute as @e[tag=airship,type=#minecraft:carts] at @s facing entity @e[type=minecraft:armor_stand,name="endpoint",limit=1,sort=nearest] feet run tp @s ^ ^0.1 ^0.3 facing entity @e[type=minecraft:armor_stand,name="endpoint",limit=1,sort=nearest]

execute as @e[type=minecraft:armor_stand,name="endpoint"] at @s run tag @e[tag=airship,type=#minecraft:carts,distance=0.1..0.2] remove airship
execute as @e[type=minecraft:armor_stand,name="endpoint"] run data merge entity @s {NoGravity: 1b}
execute as @e[type=minecraft:armor_stand,name="endpoint"] at @s align xyz run tp @s ~0.5 ~ ~0.5