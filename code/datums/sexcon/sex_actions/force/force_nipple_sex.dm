/datum/sex_action/force_ear_sex
	name = "Force fuck their nipple"
	require_grab = TRUE
	stamina_cost = 1.0

/datum/sex_action/force_ear_sex/shows_on_menu(mob/living/user, mob/living/target)
	if(user == target)
		return FALSE
	if(!target.getorgan(/obj/item/organ/breasts).breast_size > 4)
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	return TRUE

/datum/sex_action/force_ear_sex/can_perform(mob/living/user, mob/living/target)
	if(user == target)
		return FALSE
	if(ishuman(user))
		var/mob/living/carbon/human/userhuman = user
		if(userhuman.wear_pants)
			var/obj/item/clothing/under/roguetown/pantsies = userhuman.wear_pants
			if(pantsies.flags_inv == HIDECROTCH) 
				if(pantsies.genitalaccess == FALSE) 
					return FALSE
	if(ishuman(target))
		var/mob/living/carbon/human/targethuman = target
		if(targethuman.wear_shirt)
			var/obj/item/clothing/suit/roguetown/shirtsies = targethuman.wear_shirt
			if(shirtsies.flags_inv == HIDEBOOB)
				if(shirtsies.genitalaccess == FALSE)
					return FALSE
	if(!user.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	if(!user.sexcon.can_use_penis())
		return
	return TRUE

/datum/sex_action/force_ear_sex/on_start(mob/living/user, mob/living/target)
	user.visible_message(span_warning("[user] grabs [target]'s tits and shoves their cock into a nipple!"))
	playsound(target, list('sound/misc/mat/insert (1).ogg','sound/misc/mat/insert (2).ogg'), 20, TRUE, ignore_walls = FALSE)

/datum/sex_action/force_ear_sex/on_perform(mob/living/user, mob/living/target)
	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] fucks [target]'s nipple forcibly."))
	target.make_sucking_noise()

	user.sexcon.perform_sex_action(user, 2, 4, TRUE)
	if(user.sexcon.check_active_ejaculation())
		user.visible_message(span_love("cums into [target]'s nipple!"))
		user.sexcon.cum_into()

	if(user.sexcon.considered_limp())
		user.sexcon.perform_sex_action(target, 1.2, 3, FALSE)
	else
		user.sexcon.perform_sex_action(target, 2.4, 7, FALSE)
	target.sexcon.handle_passive_ejaculation()

/datum/sex_action/force_ear_sex/on_finish(mob/living/user, mob/living/target)
	user.visible_message(span_warning("[user] pulls their cock out of [target]'s nipple."))

/datum/sex_action/force_ear_sex/is_finished(mob/living/user, mob/living/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
