/mob/living/simple_animal/hostile/retaliate/rogue/orc
	name = "Savage Orc"
	desc = ""
	icon = 'modular_hearthstone/icons/mob/simple_orcs.dmi'
	icon_state = "savageorc"
	icon_living = "savageorc"
	icon_dead = "savageorc_dead"
	gender = MALE
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID|MOB_BEAST
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	robust_searching = 1
	speak_chance = 5
	turns_per_move = 1
	move_to_delay = 3
	STACON = 9
	STASTR = 14
	STASPD = 13
	maxHealth = 100
	health = 100
	harm_intent_damage = 15
	melee_damage_lower = 25
	melee_damage_upper = 30
	vision_range = 7
	aggro_vision_range = 9
	retreat_distance = 0
	minimum_distance = 0
	base_intents = list(/datum/intent/simple/axe)
	attack_verb_continuous = "hacks"
	attack_verb_simple = "hack"
	attack_sound = 'sound/blank.ogg'
	canparry = TRUE
	d_intent = INTENT_PARRY
	defprob = 50
	defdrain = 20
	obj_damage = 1
	speak_emote = list("grunts")
	speak = list("WAAAGH!", "KRUSH AND KILL!", "Never should have come here!", "Slaughter them all!", "Kill everything!", "Hahaha! Die!")
	loot = list(/obj/item/rogueweapon/stoneaxe/boneaxe,
			/obj/effect/decal/cleanable/blood)
	faction = list("orcs")
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	del_on_death = FALSE
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 3,
						/obj/item/natural/hide = 2, /obj/item/natural/bundle/bone/full = 1)
	aggressive = 1
	patron = /datum/patron/inhumen/nyrnhe		//Flavor + recognized as hostile if preformed miracles on instead of as faithless.

/mob/living/simple_animal/hostile/retaliate/rogue/orc/orc2
	icon_state = "savageorc2"
	icon_living = "savageorc2"
	icon_dead = "savageorc2_dead"
	loot = list(/obj/item/rogueweapon/stoneaxe/boneaxe,
			/obj/effect/decal/cleanable/blood)

/mob/living/simple_animal/hostile/retaliate/rogue/orc/orc_marauder
	name = "Orc Marauder"
	icon_state = "orcmarauder"
	icon_living = "orcmarauder"
	icon_dead = "orcmarauder_dead"
	melee_damage_lower = 30
	melee_damage_upper = 35
	armor_penetration = 35
	maxHealth = 200
	health = 200
	loot = list(/obj/item/rogueweapon/sword/iron/messer,
			/obj/effect/decal/cleanable/blood)

/mob/living/simple_animal/hostile/retaliate/rogue/orc/orc_marauder/spear
	icon_state = "orcmarauder_spear"
	icon_living = "orcmarauder_spear"
	icon_dead = "orcmarauder_spear_dead"
	base_intents = list(/datum/intent/simple/spear)
	loot = list(/obj/item/rogueweapon/spear,
			/obj/effect/decal/cleanable/blood)

/mob/living/simple_animal/hostile/retaliate/rogue/orc/orc_marauder/ravager
	icon_state = "orcravager"
	icon_living = "orcravager"
	icon_dead = "orcravager_dead"
	melee_damage_lower = 40
	melee_damage_upper = 50
	armor_penetration = 40
	maxHealth = 500
	health = 500
	loot = list(/obj/item/rogueweapon/halberd/bardiche,
			/obj/effect/decal/cleanable/blood)

/mob/living/simple_animal/hostile/retaliate/rogue/orc/spear
	icon_state = "savageorc_spear"
	icon_living = "savageorc_spear"
	icon_dead = "savageorc_spear_dead"
	base_intents = list(/datum/intent/simple/spear)
	melee_damage_lower = 30
	melee_damage_upper = 30
	armor_penetration = 35
	attack_verb_continuous = list("stabs", "slashes", "skewers")
	attack_verb_simple = "stab"
	attack_sound = 'sound/blank.ogg'
	loot = list(/obj/item/rogueweapon/spear/bonespear,
			/obj/effect/decal/cleanable/blood)


	footstep_type = FOOTSTEP_MOB_BAREFOOT

/mob/living/simple_animal/hostile/retaliate/rogue/orc/spear2
	icon_state = "savageorc_spear2"
	icon_living = "savageorc_spear2"
	icon_dead = "savageorc_spear2_dead"
	loot = list(/obj/item/rogueweapon/spear/bonespear,
			/obj/effect/decal/cleanable/blood)

/mob/living/simple_animal/hostile/retaliate/rogue/orc/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/simple_orcs/orc_yell.ogg','sound/vo/mobs/simple_orcs/orc_yell2.ogg','sound/vo/mobs/simple_orcs/orc_yell3.ogg', 'sound/vo/mobs/simple_orcs/orc_yell4.ogg')
		if("pain")
			return pick('sound/vo/mobs/simple_orcs/orc_pain.ogg','sound/vo/mobs/simple_orcs/orc_pain2.ogg','sound/vo/mobs/simple_orcs/orc_pain3.ogg', 'sound/vo/mobs/simple_orcs/orc_pain4.ogg')
		if("death")
			return pick('sound/vo/mobs/simple_orcs/orc_death.ogg','sound/vo/mobs/simple_orcs/orc_death2.ogg','sound/vo/mobs/simple_orcs/orc_death3.ogg','sound/vo/mobs/simple_orcs/orc_death4.ogg','sound/vo/mobs/simple_orcs/orc_death5.ogg',
			'sound/vo/mobs/simple_orcs/orc_death6.ogg')
		if("idle")
			return pick('sound/vo/mobs/simple_orcs/orc_idle.ogg','sound/vo/mobs/simple_orcs/orc_idle2.ogg','sound/vo/mobs/simple_orcs/orc_idle3.ogg','sound/vo/mobs/simple_orcs/orc_idle4.ogg')


/mob/living/simple_animal/hostile/retaliate/rogue/orc/Life()
	. = ..()
	if(!target)
		if(prob(3))
			emote(pick("idle"), TRUE)


/mob/living/simple_animal/hostile/retaliate/rogue/orc/taunted(mob/user)
	emote("aggro")
	GiveTarget(user)
	return


/mob/living/simple_animal/hostile/retaliate/rogue/orc/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_PRECISE_R_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_L_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_NOSE)
			return "nose"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "mouth"
		if(BODY_ZONE_PRECISE_SKULL)
			return "head"
		if(BODY_ZONE_PRECISE_EARS)
			return "head"
		if(BODY_ZONE_PRECISE_NECK)
			return "neck"
		if(BODY_ZONE_PRECISE_L_HAND)
			return "foreleg"
		if(BODY_ZONE_PRECISE_R_HAND)
			return "foreleg"
		if(BODY_ZONE_PRECISE_L_FOOT)
			return "leg"
		if(BODY_ZONE_PRECISE_R_FOOT)
			return "leg"
		if(BODY_ZONE_PRECISE_STOMACH)
			return "stomach"
		if(BODY_ZONE_PRECISE_GROIN)
			return "tail"
		if(BODY_ZONE_HEAD)
			return "head"
		if(BODY_ZONE_R_LEG)
			return "leg"
		if(BODY_ZONE_L_LEG)
			return "leg"
		if(BODY_ZONE_R_ARM)
			return "foreleg"
		if(BODY_ZONE_L_ARM)
			return "foreleg"
	return ..()

//hopefully no longer spams the shit out of em outta npcs since its not reusable.
/obj/projectile/bullet/arrow/npc
	name = "arrow"
	damage = 20
	damage_type = BRUTE
	armor_penetration = 40
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "arrow_proj"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow/npc
	range = 15
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'
	embedchance = 100
	woundclass = BCLASS_STAB
	flag = "bullet"
	speed = 2

/obj/item/ammo_casing/caseless/rogue/arrow/npc
	name = "arrow"
	desc = "A wooden shaft with a pointy iron end."
	projectile_type = /obj/projectile/bullet/arrow/npc
	caliber = "arrow"
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "arrow"
	force = 7
	dropshrink = 0.6
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/thrust)
	max_integrity = 1
	w_class = WEIGHT_CLASS_SMALL

/mob/living/simple_animal/hostile/retaliate/rogue/orc/ranged
	name = "savage orc archer"
	desc = ""
	icon_state = "orcbow"
	icon_living = "orcbow"
	icon_dead = "orcbow_dead"
	projectiletype = /obj/projectile/bullet/arrow/npc
	projectilesound = 'sound/combat/Ranged/flatbow-shot-01.ogg'
	ranged = 1
	retreat_distance = 2
	minimum_distance = 5
	ranged_cooldown_time = 60
	check_friendly_fire = 1
	loot = list(/obj/effect/decal/cleanable/blood)
	maxHealth = 50
	health = 50

/mob/living/simple_animal/hostile/retaliate/orc/death(gibbed)
	..()
	update_icon()

// GOBLIN



/mob/living/simple_animal/hostile/retaliate/rogue/goblin
	name = "goblin"
	desc = ""
	icon = 'modular_hearthstone/icons/mob/simple_orcs.dmi'
	icon_state = "goblinarcher"
	icon_living = "goblinarcher"
	icon_dead = "goblinarcher_dead"
	gender = MALE
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID|MOB_BEAST
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	robust_searching = 1
	speak_chance = 5
	turns_per_move = 1
	move_to_delay = 3
	STACON = 9
	STASTR = 14
	STASPD = 13
	maxHealth = 70
	health = 70
	harm_intent_damage = 15
	melee_damage_lower = 25
	melee_damage_upper = 30
	vision_range = 7
	aggro_vision_range = 9
	projectiletype = /obj/projectile/bullet/arrow/npc
	projectilesound = 'sound/combat/Ranged/flatbow-shot-01.ogg'
	ranged = 1
	retreat_distance = 2
	minimum_distance = 5
	check_friendly_fire = 1
	base_intents = list(/datum/intent/simple/axe)
	attack_verb_continuous = "hacks"
	attack_verb_simple = "hack"
	attack_sound = 'sound/blank.ogg'
	canparry = TRUE
	d_intent = INTENT_PARRY
	defprob = 50
	defdrain = 20
	obj_damage = 1
	speak_emote = list("grunts")
	loot = list(/obj/effect/decal/cleanable/blood)
	faction = list("orcs")
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	del_on_death = FALSE
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 3,
						/obj/item/natural/hide = 2, /obj/item/natural/bundle/bone/full = 1)
	aggressive = 1
	patron = /datum/patron/inhumen/nyrnhe


/mob/living/simple_animal/hostile/retaliate/rogue/goblin/cave
	icon_state = "goblinarcher2"
	icon_living = "goblinarcher2"
	icon_dead = "goblinarcher2_dead"
	loot = list(/obj/effect/decal/cleanable/blood)

/mob/living/simple_animal/hostile/retaliate/rogue/goblin/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_PRECISE_R_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_L_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_NOSE)
			return "nose"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "mouth"
		if(BODY_ZONE_PRECISE_SKULL)
			return "head"
		if(BODY_ZONE_PRECISE_EARS)
			return "head"
		if(BODY_ZONE_PRECISE_NECK)
			return "neck"
		if(BODY_ZONE_PRECISE_L_HAND)
			return "foreleg"
		if(BODY_ZONE_PRECISE_R_HAND)
			return "foreleg"
		if(BODY_ZONE_PRECISE_L_FOOT)
			return "leg"
		if(BODY_ZONE_PRECISE_R_FOOT)
			return "leg"
		if(BODY_ZONE_PRECISE_STOMACH)
			return "stomach"
		if(BODY_ZONE_PRECISE_GROIN)
			return "tail"
		if(BODY_ZONE_HEAD)
			return "head"
		if(BODY_ZONE_R_LEG)
			return "leg"
		if(BODY_ZONE_L_LEG)
			return "leg"
		if(BODY_ZONE_R_ARM)
			return "foreleg"
		if(BODY_ZONE_L_ARM)
			return "foreleg"
	return ..()

/mob/living/simple_animal/hostile/retaliate/rogue/goblin/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/gob/aggro (1).ogg','sound/vo/mobs/gob/aggro (2).ogg','sound/vo/mobs/gob/aggro (3).ogg', 'sound/vo/mobs/gob/aggro (4).ogg')
		if("pain")
			return pick('sound/vo/mobs/gob/pain (1).ogg','sound/vo/mobs/gob/pain (2).ogg','sound/vo/mobs/gob/pain (3).ogg', 'sound/vo/mobs/gob/pain (4).ogg', 'sound/vo/mobs/gob/pain (5).ogg')
		if("death")
			return pick('sound/vo/mobs/gob/gobdeath.ogg','sound/vo/mobs/gob/gobdeath2.ogg','sound/vo/mobs/gob/gobdeath3.ogg','sound/vo/mobs/gob/gobdeath4.ogg')
		if("idle")
			return pick('sound/vo/mobs/gob/idle (1).ogg','sound/vo/mobs/gob/idle (2).ogg', 'sound/vo/mobs/gob/idle (3).ogg','sound/vo/mobs/gob/idle (4).ogg', 'sound/vo/mobs/gob/idle (5).ogg')


/mob/living/simple_animal/hostile/retaliate/rogue/goblin/Life()
	. = ..()
	if(!target)
		if(prob(3))
			emote(pick("idle"), TRUE)


/mob/living/simple_animal/hostile/retaliate/rogue/goblin/taunted(mob/user)
	emote("aggro")
	GiveTarget(user)
	return
