GLOBAL_LIST_EMPTY(ritualslist)

/datum/antagonist/zizocultist
	name = "Cultist"
	roundend_category = "cultists"
	antagpanel_category = "Cult"
	job_rank = ROLE_ZIZOIDCULTIST
	antag_hud_type = ANTAG_HUD_TRAITOR
	antag_hud_name = "cultist"
	confess_lines = list(
		"DEATH TO THE SUCCESSORS!",
		"PRAISE LEVISHTH!",
		"THE GODHEAD FAVORS ME!",
	)
	var/islesser = TRUE
	rogue_enabled = TRUE

/datum/antagonist/zizocultist/leader
	name = "Heresiarch"
	islesser = FALSE

/proc/iszizolackey(mob/living/M)
	return istype(M) && M.mind && M.mind.has_antag_datum(/datum/antagonist/zizocultist)

/proc/iszizocultist(mob/living/M)
	return istype(M) && M.mind && M.mind.has_antag_datum(/datum/antagonist/zizocultist/leader)

/datum/antagonist/zizocultist/examine_friendorfoe(datum/antagonist/examined_datum, mob/examiner, mob/examined)
	if(istype(examined_datum, /datum/antagonist/zizocultist/leader))
		return span_boldnotice("OUR LEADER!")
	if(istype(examined_datum, /datum/antagonist/zizocultist))
		return span_boldnotice("An expendable follower.")

/datum/antagonist/zizocultist/on_gain()
	. = ..()
	var/datum/game_mode/chaosmode/C = SSticker.mode
	var/mob/living/carbon/human/H = owner.current
	C.cultists |= owner
	H.patron = GLOB.patronlist[/datum/patron/inhumen/levishth]

	owner.special_role = "Cultist"
	H.cmode_music = 'sound/music/combatcult.ogg'
	owner.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
	owner.current.playsound_local(get_turf(owner.current), 'sound/music/maniac.ogg', 80, FALSE, pressure_affected = FALSE)
	owner.current.verbs |= /mob/living/carbon/human/proc/praise
	owner.current.verbs |= /mob/living/carbon/human/proc/communicate
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)

	H.change_stat("strength", 2)

	if(islesser)
		add_objective(/datum/objective/zizoserve)
		owner.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
		H.change_stat("intelligence", -2)
		greet()
	else
		add_objective(/datum/objective/zizo)
		owner.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		owner.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
		H.change_stat("strength", 1)
		H.change_stat("endurance", 2)
		H.change_stat("constitution", 2)
		H.change_stat("speed", 1)
		greet()
		owner.special_role = ROLE_ZIZOIDCULTIST
		owner.current.verbs |= /mob/living/carbon/human/proc/draw_sigil
		owner.current.verbs |= /mob/living/carbon/human/proc/release_minion

/datum/antagonist/zizocultist/greet()
	to_chat(owner, span_danger("I'm a Cultist of Zizo, under the orders of the Heresiarch."))
	owner.announce_objectives()

/datum/antagonist/zizocultist/leader/greet()
	to_chat(owner, span_danger("I'm a Heresiarch of Zizo. I must form a great cult and follow her footsteps. My ascension will be glorious."))

	owner.announce_objectives()

/datum/antagonist/zizocultist/can_be_owned(datum/mind/new_owner)
	. = ..()
	if(.)
		if(new_owner.current == SSticker.rulermob)
			return FALSE
		if(new_owner.assigned_role in GLOB.church_positions)
			return FALSE
		if(new_owner.unconvertable)
			return FALSE
		if(new_owner.current && HAS_TRAIT(new_owner.current, TRAIT_MINDSHIELD))
			return FALSE

/datum/antagonist/zizocultist/proc/add_cultist(datum/mind/cult_mind)
	cult_mind.add_antag_datum(/datum/antagonist/zizocultist)
	return TRUE

/datum/objective/zizo
	name = "ASCEND"
	explanation_text = "Ensure that I ascend."
	team_explanation_text = "Ensure that I ascend."
	triumph_count = 5

/datum/objective/zizo/check_completion()
	var/datum/game_mode/chaosmode/C = SSticker.mode
	if(C.cultascended)
		return TRUE

/datum/objective/zizoserve
	name = "Serve your Leader"
	explanation_text = "Serve your leader and ensure that they ascend."
	team_explanation_text = "Serve your leader and ensure that they ascend."
	triumph_count = 3

/datum/objective/zizoserve/check_completion()
	var/datum/game_mode/chaosmode/C = SSticker.mode
	if(C.cultascended)
		return TRUE

/datum/antagonist/zizocultist/proc/add_objective(datum/objective/O)
	var/datum/objective/V = new O
	objectives += V

/datum/antagonist/zizocultist/proc/remove_objective(datum/objective/O)
	objectives -= O

/datum/antagonist/zizocultist/roundend_report()
	var/traitorwin = TRUE

	printplayer(owner)

	var/count = 0
	if(islesser) // don't need to spam up the chat with all spawn
		if(objectives.len)//If the traitor had no objectives, don't need to process this.
			for(var/datum/objective/objective in objectives)
				objective.update_explanation_text()
				if(objective.check_completion())
					to_chat(owner, "<B>Goal #[count]</B>: [objective.explanation_text] " + span_green("TRIUMPH!"))
				else
					to_chat(owner, "<B>Goal #[count]</B>: [objective.explanation_text] " + span_red("Failure."))

					traitorwin = FALSE
				count += objective.triumph_count
	else
		if(objectives.len)//If the traitor had no objectives, don't need to process this.
			for(var/datum/objective/objective in objectives)
				objective.update_explanation_text()
				if(objective.check_completion())
					to_chat(owner, "<B>Goal #[count]</B>: [objective.explanation_text] " + span_green("TRIUMPH!"))
				else
					to_chat(owner, "<B>Goal #[count]</B>: [objective.explanation_text] " + span_red("Failure."))

					traitorwin = FALSE
				count += objective.triumph_count

	var/special_role_text = lowertext(name)
	if(traitorwin)
		if(count)
			if(owner)
				owner.adjust_triumphs(count)
		to_chat(world, span_green("The [special_role_text] has TRIUMPHED!"))
		if(owner?.current)
			owner.current.playsound_local(get_turf(owner.current), 'sound/misc/triumph.ogg', 100, FALSE, pressure_affected = FALSE)
		else
			to_chat(world, span_red("The [special_role_text] has FAILED!"))

		if(owner?.current)
			owner.current.playsound_local(get_turf(owner.current), 'sound/misc/fail.ogg', 100, FALSE, pressure_affected = FALSE)

// VERBS

/mob/living/carbon/human/proc/praise()
	set name = "Praise the Godhead!"
	set category = "LEVISHTH"
	audible_message("[src] praises " + span_bold("Levishth") + "!")
	playsound(src.loc, 'sound/vo/cult/praise.ogg', 45, 1)

/mob/living/carbon/human/proc/communicate()
	set name = "Communicate"
	set category = "LEVISHTH"

	var/datum/game_mode/chaosmode/C = SSticker.mode
	var/speak = input("What do you speak of?", "DREAMKEEP") as text|null
	if(!speak)
		return
	whisper("O schlet'a ty'schkotot ty'skvoro...")
	whisper("[speak]")

	for(var/datum/mind/V in C.cultists)
		to_chat(V, span_boldnotice("A message from [src.real_name]: \"[speak]\""))
		playsound_local(V.current, 'sound/vo/cult/skvor.ogg', 100)

/obj/effect/decal/cleanable/sigil
	name = "sigils"
	desc = "Strange runics."
	icon_state = "center"
	icon = 'icons/obj/sigils.dmi'
	var/sigil_type

/obj/effect/decal/cleanable/sigil/examine(mob/user)
	. = ..()
	if(!sigil_type)
		return

	if(iszizocultist(user) || iszizolackey(user))
		to_chat(user, "It is of the [sigil_type] circle.")

/obj/effect/decal/cleanable/sigil/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	if(!LAZYLEN(GLOB.ritualslist))
		testing("initializing ritualslist")
		GLOB.ritualslist = list()
		var/static/list/rituals = subtypesof(/datum/ritual)
		for(var/path in rituals)
			var/datum/ritual/G = path
			testing("now initializing: [path]")
			testing("[G.name]")
			GLOB.ritualslist[G.name] = G

/obj/effect/decal/cleanable/sigil/proc/consume_ingredients(datum/ritual/R)

	for(var/atom/A in get_step(src, NORTH))
		if(istype(A, R.n_req) && !ishuman(A))
			playsound(src, 'sound/foley/flesh_rem2.ogg', 30)
			qdel(A)

	for(var/atom/A in get_step(src, SOUTH))
		if(istype(A, R.s_req) && !ishuman(A))
			playsound(src, 'sound/foley/flesh_rem2.ogg', 30)
			qdel(A)

	for(var/atom/A in get_step(src, EAST))
		if(istype(A, R.e_req) && !ishuman(A))
			playsound(src, 'sound/foley/flesh_rem2.ogg', 30)
			qdel(A)

	for(var/atom/A in get_step(src, WEST))
		if(istype(A, R.w_req) && !ishuman(A))
			playsound(src, 'sound/foley/flesh_rem2.ogg', 30)
			qdel(A)

	for(var/atom/A in loc.contents)
		if(istype(A, R.center_requirement) && !ishuman(A))
			playsound(src, 'sound/foley/flesh_rem2.ogg', 30)
			qdel(A)

/obj/effect/decal/cleanable/sigil/attack_hand(mob/living/user)
	. = ..()
	testing("clicked by [user]")
	var/list/rituals = list()
	if(icon_state != "center") // fucking awful but it has to be this way
		return
	if(iszizocultist(user) || iszizolackey(user))
		for(var/G in GLOB.ritualslist)
			var/datum/ritual/path = GLOB.ritualslist[G]
			if(path.circle == sigil_type)
				rituals |= path.name

		var/ritualnameinput = input(user, "Rituals", "DREAMKEEP") as null|anything in rituals
		testing("ritualnameinput [ritualnameinput]")
		var/datum/ritual/pickritual

		pickritual = GLOB.ritualslist[ritualnameinput]
		testing("pickritual [pickritual]")

		var/cardinal_success = FALSE
		var/center_success = FALSE

		if(!pickritual)
			return

		var/dews = 0

		if(pickritual.e_req)
			for(var/atom/A in get_step(src, EAST))
				if(istype(A, pickritual.e_req))
					dews++
					break
				else
					continue
		else
			dews++

		if(pickritual.s_req)
			for(var/atom/A in get_step(src, SOUTH))
				if(istype(A, pickritual.s_req))
					dews++
					break
				else
					continue
		else
			dews++

		if(pickritual.w_req)
			for(var/atom/A in get_step(src, WEST))
				if(istype(A, pickritual.w_req))
					dews++
					break
				else
					continue
		else
			dews++

		if(pickritual.n_req)
			for(var/atom/A in get_step(src, NORTH))
				if(istype(A, pickritual.n_req))
					dews++
					break
				else
					continue
		else
			dews++

		if(dews >= 4)
			cardinal_success = TRUE
			testing("CARDINAL SUCCESS!")

		for(var/atom/A in loc.contents)
			if(!istype(A, pickritual.center_requirement))
				continue
			else
				center_success = TRUE
				testing("CENTER SUCCESS!")
				break

		var/badritualpunishment = FALSE
		if(cardinal_success != TRUE)
			if(badritualpunishment)
				return
			to_chat(user.mind, span_danger("\"That's not how you do it, fool.\""))
			user.electrocute_act(10, src)
			return

		if(center_success != TRUE)
			if(badritualpunishment)
				return
			to_chat(user.mind, span_danger("\"That's not how you do it, fool.\""))
			user.electrocute_act(10, src)
			return

		testing("Now calling proc")
		consume_ingredients(pickritual)
		user.playsound_local(user, 'sound/vo/cult/tesa.ogg', 25)
		user.whisper("O'vena tesa...")
		call(pickritual.function)(user, loc)

/obj/effect/decal/cleanable/sigil/N
	icon_state = "N"

/obj/effect/decal/cleanable/sigil/NE
	icon_state = "NE"

/obj/effect/decal/cleanable/sigil/E
	icon_state = "E"

/obj/effect/decal/cleanable/sigil/SE
	icon_state = "SE"

/obj/effect/decal/cleanable/sigil/S
	icon_state = "S"

/obj/effect/decal/cleanable/sigil/SW
	icon_state = "SW"

/obj/effect/decal/cleanable/sigil/W
	icon_state = "W"

/obj/effect/decal/cleanable/sigil/NW
	icon_state = "NW"

/turf/open/floor/proc/generateSigils(mob/M, input)
	var/turf/T = get_turf(M.loc)
	for(var/obj/A in T)
		if(istype(A, /obj/effect/decal/cleanable/sigil))
			to_chat(M, span_warning("There is already a sigil here."))
			return
		if(A.density && !(A.flags_1 & ON_BORDER_1))
			to_chat(M, span_warning("There is already something here!"))
			return
	if(do_after(M, 5 SECONDS))
		M.bloody_hands--
		M.update_inv_gloves()
		var/obj/effect/decal/cleanable/sigil/C = new(src)
		C.sigil_type = input
		playsound(M, 'sound/items/write.ogg', 100)
		var/list/sigilsPath = list(
			/obj/effect/decal/cleanable/sigil/N,
			/obj/effect/decal/cleanable/sigil/S,
			/obj/effect/decal/cleanable/sigil/E,
			/obj/effect/decal/cleanable/sigil/W,
			/obj/effect/decal/cleanable/sigil/NE,
			/obj/effect/decal/cleanable/sigil/NW,
			/obj/effect/decal/cleanable/sigil/SE,
			/obj/effect/decal/cleanable/sigil/SW
		)

		for(var/i = 1; i <= GLOB.alldirs.len; i++)
			var/turf/floor = get_step(src, GLOB.alldirs[i])
			var/sigil = sigilsPath[i]

			new sigil(floor)

/mob/living/carbon/human/proc/draw_sigil()
	set name = "Draw Sigil"
	set category = "LEVISHTH"

	var/list/runes = list("Servantry", "Transmutation", "Fleshcrafting")

	if(!bloody_hands)
		to_chat(src, span_danger("My hands aren't bloody enough."))
		return

	var/input = input("Sigil Type", "DREAMKEEP") as null|anything in runes
	if(!input)
		return

	var/turf/open/floor/T = get_turf(src.loc)
	T.generateSigils(src, input)

/mob/living/carbon/human/proc/release_minion()
	set name = "Release follower"
	set category = "LEVISHTH"

	var/datum/game_mode/chaosmode/C = SSticker.mode
	var/list/mob/living/carbon/human/possible = list()
	for(var/datum/mind/V in C.cultists)
		if(V.special_role == "Cultist")
			possible |= V.current

	var/mob/living/carbon/human/choice = input(src, "Whom do you no longer have use for?", "ROGUETOWN") as null|anything in possible
	if(choice)
		var/alert = alert(src, "Are you sure?", "DREAMKEEP", "Yes", "Cancel")
		if(alert == "Yes")
			visible_message(span_danger("[src] reaches out, ripping up [choice]'s soul!"))
			to_chat(choice, span_userdanger("I HAVE FAILED MY LEADER! I HAVE FAILED LEVISHTH! NOTHING ELSE BUT DEATH REMAINS FOR ME NOW!"))
			sleep(20)
			choice.gib() // Cooler than dusting.
			C.cultists -= choice.mind

// RITUAL DATUMS

/datum/ritual
	var/name = "DARK AND EVIL RITVAL"
	var/circle = null // Servantry, Transmutation, Fleshcrafting
	var/center_requirement = /obj/item
	// This is absolutely fucking terrible. I tried to do it with lists but it just didn't work and
	//kept runtiming. Something something, can't access list inside a datum.
	//I couldn't find a more efficient solution to do this, I'm sorry. -7
	var/n_req = null
	var/e_req = null
	var/s_req = null
	var/w_req = null
	var/function // a proc


// SERVANTRY

/datum/ritual/convert
	name = "Convert"
	circle = "Servantry"
	center_requirement = /mob/living/carbon/human

	function = /proc/convert

/proc/convert(mob/user, turf/C)
	var/datum/game_mode/chaosmode/M = SSticker.mode
	testing("NOW TESTING CONVERT")

	for(var/mob/living/carbon/human/H in C.contents)
		if(H != user)
			if(iszizocultist(H) || iszizolackey(H))
				return
			if(!H.client)
				return
			if(H.anchored) // a way to bind the person to the rune if they choose to resist converting
				return
			if(istype(H.wear_neck, /obj/item/clothing/neck/roguetown/psicross))
				to_chat(user.mind, span_danger("\"They are wearing my bane...\""))
				return
			if(M.cultists.len >= 10)
				to_chat(user.mind, span_danger("\"The veil is too strong to support more than ten cultists.\""))
				return
			var/datum/antagonist/zizocultist/PR = user.mind.has_antag_datum(/datum/antagonist/zizocultist)
			var/alert = alert(H, "YOU WILL BE SHOWN THE TRUTH. DO YOU RESIST? (Resisting: 1 TRI)", "DREAMKEEP", "Yield", "Resist")
			H.anchored = TRUE
			if(alert == "Yield")
				to_chat(H.mind, span_notice("I see the truth now! It all makes so much sense! They aren't HERETICS! They want the BEST FOR US!"))
				PR.add_cultist(H.mind)
				H.praise()
				H.anchored = FALSE
			else
				H.adjust_triumphs(-1)
				H.visible_message(span_danger("\The [H] thrashes around, unyielding!"))
				to_chat(H.mind, span_danger("\"Yield.\""))
				if(H.electrocute_act(10, C))
					H.emote("painscream")
				sleep(20)
				H.anchored = FALSE

/datum/ritual/skeletaljaunt
	name = "Skeletal Jaunt"
	circle = "Servantry"
	center_requirement = /mob/living/carbon/human

	n_req = /obj/item/organ/heart

	function = /proc/skeletaljaunt

/proc/skeletaljaunt(mob/user, turf/C)
	for(var/mob/living/carbon/human/H in C.contents)
		if(H == user)
			return
		if(iszizocultist(H))
			to_chat(H.mind, span_danger("\"I'm not gonna let my strongest follower become a mindless brute.\""))
			return
		if(H.mind)
			H.mind.special_role = "Cult Summon"
			H.mind.assigned_role = "Cult Summon"
			H.mind.current.job = null
		H.dna.species.species_traits |= NOBLOOD
		H.dna.species.soundpack_m = new /datum/voicepack/skeleton()
		H.dna.species.soundpack_f = new /datum/voicepack/skeleton()
		var/obj/item/bodypart/O = H.get_bodypart(BODY_ZONE_R_ARM)
		if(O)
			O.drop_limb()
			qdel(O)
		O = H.get_bodypart(BODY_ZONE_L_ARM)
		if(O)
			O.drop_limb()
			qdel(O)
		H.regenerate_limb(BODY_ZONE_R_ARM)
		H.regenerate_limb(BODY_ZONE_L_ARM)
		for(var/obj/item/bodypart/BP in H.bodyparts)
			BP.skeletonize()
		H.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB, /datum/intent/simple/claw)
		H.update_a_intents()
		H.cmode_music = 'sound/music/combatcult.ogg'
		H.patron = GLOB.patronlist[/datum/patron/inhumen/levishth]
		var/obj/item/organ/eyes/eyes = H.getorganslot(ORGAN_SLOT_EYES)
		if(eyes)
			eyes.Remove(H,1)
			QDEL_NULL(eyes)
		eyes = new /obj/item/organ/eyes/night_vision/zombie
		eyes.Insert(H)
		H.ambushable = FALSE
		H.underwear = "Nude"
		if(H.charflaw)
			QDEL_NULL(H.charflaw)
		H.update_body()
		H.mob_biotypes = MOB_UNDEAD
		H.faction = list("undead")

		H.STASPD = rand(7,10)
		H.STAINT = 1
		H.STACON = 3
		H.STASTR = rand(8,17)

		H.verbs |= /mob/living/carbon/human/proc/praise
		H.verbs |= /mob/living/carbon/human/proc/communicate

		ADD_TRAIT(H, TRAIT_NOMOOD, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_NOROGSTAM, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_NOLIMBDISABLE, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_NOHUNGER, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_NOBREATH, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_NOPAIN, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_NOSLEEP, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_SHOCKIMMUNE, TRAIT_GENERIC)
		to_chat(H, span_userdanger("I am returned to serve. I will obey, so that I may return to rest."))
		to_chat(H, span_userdanger("My master is [user]."))
		break

/datum/ritual/thecall
	name = "The Call"
	circle = "Servantry"
	center_requirement = /obj/item/bedsheet/rogue

	w_req = /obj/item/bodypart/l_leg
	e_req = /obj/item/bodypart/r_leg

	function = /proc/thecall

/proc/thecall(mob/user, turf/C)
	for(var/obj/item/paper/P in C.contents)
		if(!user.mind || !user.mind.do_i_know(name=P.info))
			to_chat(user.mind, span_warning("I don't know anyone by that name."))
			return
		for(var/mob/living/carbon/human/HL in GLOB.human_list)
			if(HL.real_name == P.info)
				if(HL.IsSleeping())
					if(HL.mind.assigned_role in GLOB.church_positions)
						to_chat(HL.mind, span_warning("I sense an unholy presence loom near my soul."))
						return
					if(HL == SSticker.rulermob)
						return
					if(istype(HL.wear_neck, /obj/item/clothing/neck/roguetown/psicross))
						return
					if(HAS_TRAIT(HL, TRAIT_NOROGSTAM))
						return
					HL.apply_status_effect(/datum/status_effect/debuff/sleepytime)
					to_chat(HL.mind, span_warning("This isn't my bed... Where am I?!"))
					HL.forceMove(C)
					HL.playsound_local(C, pick('sound/misc/jumphumans (1).ogg','sound/misc/jumphumans (2).ogg','sound/misc/jumphumans (3).ogg'), 100)
					qdel(P)

/datum/ritual/falseappearance
	name = "Falsified Appearance"
	circle = "Servantry"
	center_requirement = /mob/living/carbon/human

	n_req = /obj/item/bodypart/head
	s_req = /obj/item/shard
	e_req = /obj/item/shard
	w_req = /obj/item/shard

	function = /proc/falseappearance

/proc/falseappearance(mob/user, turf/C)
	for(var/mob/living/carbon/human/H in C.contents)
		var/datum/preferences/A = new()//Randomize appearance for the guy
		var/first_names = GLOB.first_names
		if(H.gender == FEMALE)
			first_names = GLOB.first_names_female
		else
			first_names = GLOB.first_names_male
		A.real_name = "[pick(first_names)]"
		A.copy_to(H)
		H.dna.update_dna_identity()
		break

/datum/ritual/pactofunity
	name = "Pact of Unity"
	circle = "Servantry"
	center_requirement = /obj/item/paper

	n_req = /obj/item/organ/eyes

	function = /proc/pactofunity

/obj/item/pactofunity // Not paper because I don't fuck with that.
	name = "pact of unity"
	desc = "Write down your name and about your fiendish ways."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "confession"
	var/mob/living/carbon/human/signed

/obj/item/pactofunity/examine(mob/user)
	. = ..()
	if(signed)
		to_chat(user, "It is bound to [signed.real_name].")

/obj/item/pactofunity/attack_self(mob/user)
	. = ..()
	var/alert = alert(user, "Rip up the pact of unity?", "DREAMKEEP", "RIP", "Cancel")
	if(alert == "RIP")
		user.playsound_local(user, 'sound/foley/cloth_rip.ogg', 50)
		to_chat(signed.mind, span_userdanger("I FAILED! MY LIFE DWINDLES!"))
		sleep(2 MINUTES)
		if(istype(signed.wear_neck, /obj/item/clothing/neck/roguetown/psicross))
			return
		signed.dust(drop_items=TRUE)

/obj/item/pactofunity/attack(mob/living/M, mob/living/user)
	. = ..()
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	if(signed)
		return ..()
	if(!H.get_bleed_rate())
		to_chat(user, span_warning("No. They must be bleeding."))
		return
	if(!H.stat)
		to_chat(user, span_info("I courteously offer \the [src] to [H]."))
		if(alert(H, "Sign the pact with your blood?", "DREAMKEEP", "Yes", "No") != "Yes")
			return
		if(H.stat)
			return
		if(signed)
			return
		to_chat(H, span_info("I signed the paper, hopefully I won't regret this."))
		signed = H

/proc/pactofunity(mob/user, turf/C)
	new /obj/item/pactofunity(C)
	to_chat(user.mind, span_notice("The Pact of Unity. When a person willingly signs their name on this they become my pawn. When I rip up the paper their soul is good as dead."))

// TRANSMUTATION

/datum/ritual/allseeingeye
	name = "All-seeing Eye"
	circle = "Transmutation"
	center_requirement = /obj/item/organ/eyes

	function = /proc/allseeingeye

/proc/allseeingeye(mob/user, turf/C)
	new /obj/item/scrying/eye(C)

/datum/ritual/criminalstool
	name = "Criminal's Tool"
	circle = "Transmutation"
	center_requirement = /obj/item/natural/cloth

	function = /proc/criminalstool

/proc/criminalstool(mob/user, turf/C)
	new /obj/item/soap/cult(C)
	to_chat(user.mind, span_notice("The Criminal's Tool. Could be useful for hiding tracks or getting rid of sigils."))

/datum/ritual/propaganda
	name = "Propaganda"
	circle = "Transmutation"
	center_requirement = /obj/item/natural/worms/leech
	n_req = /obj/item/paper
	s_req = /obj/item/natural/feather

	function = /proc/propaganda

/proc/propaganda(mob/user, turf/C)
	new /obj/item/natural/worms/leech/propaganda(C)
	to_chat(user.mind, span_notice("A leech to make their minds wrangled. They'll be in bad spirits."))

/datum/ritual/falseidol
	name = "False Idol"
	circle = "Transmutation"
	center_requirement = /mob/living/carbon/human
	w_req = /obj/item/paper
	s_req = /obj/item/natural/feather

	function = /proc/falseidol

/obj/effect/dummy/falseidol
	name = "false idol"
	icon = 'icons/effects/effects.dmi'
	icon_state = "static"
	desc = "Through lies interwine from blood into truth."

/obj/effect/dummy/falseidol/Crossed(atom/movable/AM, oldloc)
	. = ..()
	qdel(src)

/proc/falseidol(mob/user, turf/C)
	for(var/mob/living/carbon/human/H in C.contents)
		var/obj/effect/dummy/falseidol/idol = new(C)
		var/datum/icon_snapshot/entry = new
		entry.name = H.name
		entry.icon = H.icon
		entry.icon_state = H.icon_state
		entry.overlays = H.get_overlays_copy(list(HANDS_LAYER))	//ugh
		sleep(10)
		idol.name = entry.name
		idol.icon = entry.icon
		idol.icon_state = entry.icon_state
		idol.add_overlay(entry.overlays)
		break

/datum/ritual/invademind
	name = "Invade Mind"
	circle = "Transmutation"
	center_requirement = /obj/item/natural/feather

	function = /proc/invademind

/proc/invademind(mob/user, turf/C)
	for(var/obj/item/paper/P in C.contents)
		var/info = ""
		info = sanitize(P.info)
		var/input = stripped_input(user, "To whom do we send this message?", "DREAMKEEP")
		if(!input)
			return
		for(var/mob/living/carbon/human/HL in GLOB.human_list)
			if(HL.real_name == input)
				qdel(P)
				to_chat(HL, "<i>You hear a voice in your head... <b>[info]</i></b>")
		break

/datum/ritual/summonweapons
	name = "Summon Weaponry"
	circle = "Transmutation"
	center_requirement = /obj/item/ingot/steel

	function = /proc/summonweapons

/proc/summonweapons(mob/user, turf/C)
	var/datum/effect_system/spark_spread/S = new(C)
	S.set_up(1, 1, C)
	S.start()

	new /obj/item/rogueweapon/sword(C)
	new /obj/item/rogueweapon/huntingknife(C)
	new /obj/item/rogueweapon/huntingknife(C)

	new /obj/item/rope/chain(C)
	new /obj/item/rope/chain(C)

	playsound(C,pick('sound/items/bsmith1.ogg','sound/items/bsmith2.ogg','sound/items/bsmith3.ogg','sound/items/bsmith4.ogg'), 100, FALSE)

// FLESH CRAFTING

/datum/ritual/bunnylegs
	name = "Saliendo Pedes"
	circle = "Fleshcrafting"
	center_requirement = /mob/living/carbon/human

	w_req = /obj/item/bodypart/l_leg
	e_req = /obj/item/bodypart/r_leg
	n_req = /obj/item/reagent_containers/food/snacks/rogue/meat

	function = /proc/bunnylegs

/proc/bunnylegs(mob/user, turf/C)
	for(var/mob/living/carbon/human/H in C.contents)
		ADD_TRAIT(H, TRAIT_ZJUMP, TRAIT_GENERIC)
		to_chat(H.mind, span_notice("I feel like my legs have become stronger."))
		break

/datum/ritual/darkeyes
	name = "Darkened Eyes"
	circle = "Fleshcrafting"
	center_requirement = /mob/living/carbon/human

	w_req = /obj/item/organ/eyes
	e_req = /obj/item/organ/eyes
	n_req = /obj/item/reagent_containers/food/snacks/rogue/meat

	function = /proc/darkeyes

/proc/darkeyes(mob/user, turf/C)
	for(var/mob/living/carbon/human/H in C.contents)
		var/obj/item/organ/eyes/eyes = H.getorganslot(ORGAN_SLOT_EYES)
		if(eyes)
			eyes.Remove(H,1)
			QDEL_NULL(eyes)
		eyes = new /obj/item/organ/eyes/night_vision/zombie
		eyes.Insert(H)
		to_chat(H.mind, span_notice("I no longer fear the dark."))
		break

/datum/ritual/nopain
	name = "Painless Battle"
	circle = "Fleshcrafting"
	center_requirement = /mob/living/carbon/human

	w_req = /obj/item/organ/heart
	e_req = /obj/item/organ/brain
	n_req = /obj/item/reagent_containers/food/snacks/rogue/meat

	function = /proc/nopain

/proc/nopain(mob/user, turf/C)
	for(var/mob/living/carbon/human/H in C.contents)
		ADD_TRAIT(user, TRAIT_NOPAIN, TRAIT_GENERIC)
		to_chat(H.mind, span_notice("I no longer feel pain, but it has come at a terrible cost."))
		H.change_stat("strength", -2)
		H.change_stat("constitution", -2)
		if(H.gender == FEMALE)
			H.change_stat("constitution", -1)
		else
			ADD_TRAIT(user, TRAIT_LIMPDICK, TRAIT_GENERIC)
		break

/datum/ritual/fleshform
	name = "Stronger Form"
	circle = "Fleshcrafting"
	center_requirement = /mob/living/carbon/human

	w_req = /obj/item/organ/guts
	e_req = /obj/item/organ/guts
	n_req = /obj/item/reagent_containers/food/snacks/rogue/meat
	s_req = /obj/item/reagent_containers/food/snacks/rogue/meat

	function = /proc/fleshform

/proc/fleshform(mob/user, turf/C)
	for(var/mob/living/carbon/human/H in C.contents)
		if(iszizocultist(H))
			to_chat(H.mind, span_danger("\"I'm not letting my strongest follower become a mindless brute.\""))
			return
		to_chat(user.mind, span_danger("SOON I WILL BECOME A HIGHER FORM!!!"))
		sleep(5 SECONDS)
		var/mob/living/trl = new /mob/living/simple_animal/hostile/retaliate/rogue/troll/blood(H)
		trl.forceMove(H)
		trl.ckey = H.ckey
		H.gib()

/datum/ritual/gutted
	name = "Gutted Fish"
	circle = "Fleshcrafting"
	center_requirement = /mob/living/carbon/human // One to be gutted.human

	function = /proc/guttedlikeafish

/proc/guttedlikeafish(mob/user, turf/C)
	for(var/mob/living/carbon/human/H in C.contents)
		if(H.stat == DEAD)
			H.take_overall_damage(500)
			C.visible_message(span_danger("[H.real_name] is lifted up into the air and multiple scratches, incisions and deep cuts start etching themselves into their skin as all of their internal organs spill on the floor below!"))

			var/atom/drop_location = H.drop_location()
			for(var/obj/item/organ/organ as anything in H.internal_organs)
				organ.Remove(H)
				organ.forceMove(drop_location)
			var/obj/item/bodypart/chest/cavity = H.get_bodypart(BODY_ZONE_CHEST)
			if(cavity.cavity_item)
				cavity.cavity_item.forceMove(drop_location)
				cavity.cavity_item = null

/datum/ritual/ascend
	name = "ASCEND!"
	circle = "Fleshcrafting"
	center_requirement = /mob/living/carbon/human // cult leader

	n_req = /mob/living/carbon/human // virgin
	s_req = /mob/living/carbon/human // anyone
	e_req = /mob/living/carbon/human // anyone
	w_req = /mob/living/carbon/human // anyone

	function = /proc/ascend

/proc/ascend(mob/user, turf/C)
	var/datum/game_mode/chaosmode/CM = SSticker.mode

	for(var/mob/living/carbon/human/H in C.contents)
		if(!iszizocultist(H))
			return
		for(var/mob/living/carbon/human/VIRGIN in get_step(C, NORTH))
			if(!VIRGIN.virginity && VIRGIN.stat != DEAD)
				break
			VIRGIN.gib()
		for(var/mob/living/carbon/human/SOMEDUDE in get_step(C, EAST))
			if(SOMEDUDE.stat != DEAD)
				break
			SOMEDUDE.gib()
		for(var/mob/living/carbon/human/SOMEDUDE in get_step(C, SOUTH))
			if(SOMEDUDE.stat != DEAD)
				break
			SOMEDUDE.gib()
		for(var/mob/living/carbon/human/SOMEDUDE in get_step(C, WEST))
			if(SOMEDUDE.stat != DEAD)
				break
			SOMEDUDE.gib()
		CM.cultascended = TRUE
		addomen("ascend")
		to_chat(user.mind, span_danger("I HAVE DONE IT! Now I will die... BUT THE REFLECTION OF -ME- AS A NEW GOD WILL RISE!!!"))
		var/mob/living/trl = new /mob/living/simple_animal/hostile/retaliate/rogue/troll/blood/ascended(C)
		trl.name = "[user.real_name] the NEW GOD of ULTRAVIOLENCE"
		trl.ckey = H.ckey
		H.gib()
		for(var/mob/living/carbon/V in GLOB.human_list)
			if(!(V.mind in CM.cultists))
				to_chat(V, span_danger("I CAN --FEEL-- SOMETHING -HORRIBLE- HAS AWAKENED...!!"))
				V.do_freakout_scream()
				V.add_stress(/datum/stressevent/hatezizo)
		GLOB.todoverride = "night"
		settod()
		spawn(6000)
			GLOB.todoverride = null
		priority_announce("The Sun is torn from the sky!", "Terrible Omen", 'sound/misc/astratascream.ogg')
		addomen(OMEN_SUNSTEAL)
		for(var/mob/living/carbon/human/astrater in GLOB.human_list)
			if(!istype(astrater.patron, /datum/patron/divine/elysius) || !length(astrater.mind?.antag_datums))
				continue
			to_chat(astrater, span_userdanger("You feel the pain of [astrater.patron.name]!"))
			astrater.emote_scream()
		break
