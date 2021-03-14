extends StateMachine

#Constants
var STALKING = "stalking"
var FLEEING = "fleeing"
var APPROACHING = "approaching"
var WAITING = "waiting"
var TELEPORTING = "teleporting"
var RUNFORIT = "runforit"
var LAST = "last"

func _init():
	states = {
		"stalking": State.new(self, "stalking", [FLEEING, WAITING, APPROACHING]),
		"fleeing": UPState.new(self, "fleeing", [WAITING, APPROACHING]),
		"waiting": UPState.new(self, "waiting", [STALKING, FLEEING, APPROACHING, TELEPORTING]),
		"approaching": UPState.new(self, "approaching", [STALKING, FLEEING, TELEPORTING]),
		"runforit":UPState.new(self, "runforit", []),
		"teleporting": UPState.new(self, "teleporting", [LAST, TELEPORTING]),
	}
	status = {
		"confrontational":false,
		"rushing":false,
		"cautious":false,
		"afraid":false,
		
		"seen":false,
		"endangered":false,
		"safe":true,
		"detected":false,
		"detector_mid_blink":false,
		
		"locked_in":false,
		"cornered":false,
		"player_close":false,
		"player_near":false,
		"player_medium":false,
		"player_far":false,
	}
	params = {
		"recent_blinks":0,
	}

# Stalking

func state_stalking():
	up.dir.x = 1
	up.speed = up.sneak_speed
	up.limbs.animation = "Walking"
	up.set_flip_h(false)
	reset_param("recent_blinks")
	print("Stalking...")

# --> fleeing
func test_stalking_fleeing():
	return status.seen and status.player_close
func transition_stalking_fleeing():
	print("Fleeing!")
#	status.afraid = true
	start(FLEEING)

# --> waiting
func test_stalking_waiting():
	return status.seen and status.player_near
func transition_stalking_waiting():
	set_status("cautious", false)
	start(WAITING)

# --> approaching
func test_stalking_approaching():
	return status.seen and status.player_medium
func transition_stalking_approaching():
#	status.confrontational = true
	start(APPROACHING)


# Fleeing

func state_fleeing():
	up.dir.x = -1
	up.speed = up.sprint_speed
	up.limbs.animation = "Walking"
	up.set_flip_h(true)

# --> waiting
func test_fleeing_waiting():
	return not status.seen or status.player_far or status.cornered
func transition_fleeing_waiting():
	up.start_caution_timer()
	start(WAITING)

# --> approaching
func test_fleeing_approaching():
	return status.seen and status.cornered and status.player_close
func transition_fleeing_approaching():
#	status.confrontational = true
	start(APPROACHING)


# Waiting

func state_waiting():
	up.speed = 0
	up.limbs.animation = "Idle"
	up.set_flip_h(false)

# --> stalking
func test_waiting_stalking():
	return not status.seen and not status.cautious
func transition_waiting_stalking():
	start(STALKING)

# --> fleeing
func test_waiting_fleeing():
	return status.seen and (status.player_close or (status.cautious and status.player_far))
func transition_waiting_fleeing():
	start(FLEEING)

# --> approaching
func test_waiting_approaching():
	return status.seen and status.player_far and not status.cautious
func transition_waiting_approaching():
	start(APPROACHING)

# --> teleporting
func test_waiting_teleporting():
	return status.seen and status.detector_mid_blink
func transition_waiting_teleporting():
	start(TELEPORTING)


# Approaching

func state_approaching():
	up.dir.x = up.player_dir().x
	up.limbs.animation = "Walking"
	if (up.dir.x < 0):
		up.speed = up.back_speed
	elif (up.dir.x > 0):
		up.speed = up.forward_speed
	else:
		up.limbs.animation = "Idle"
	up.set_flip_h(false)

# --> stalking
func test_approaching_stalking():
	return not status.seen or status.player_far
func transition_approaching_stalking():
	status.confrontational = false
	start(STALKING)

# --> fleeing
func test_approaching_fleeing():
	return status.seen and status.player_close and not status.confrontational
func transition_approaching_fleeing():
	start(FLEEING)

# --> teleporting
func test_approaching_teleporting():
	return status.seen and status.detector_mid_blink
func transition_approaching_teleporting():
	status.confrontational = true
	start(TELEPORTING)


# RunForIt

func state_runforit():
	up.dir.x = 1.5
	up.speed = up.forward_speed
	up.limbs.animation = "Running"
	up.set_flip_h(false)


# Teleporting

func state_teleporting():
	var rand = randi()
	var mod_close = 4 if status.player_close else 1
	var mod_near = 2 if status.player_near else 1
	if not rand % clamp(5 - (params.recent_blinks * mod_close * mod_near), 1, 100):
		if not status.player_close:
			up.spooky_approach()
		else:
			up.leap_frog()
			start(RUNFORIT)
	else:
		up.speed = 0
		up.limbs.animation = "Idle"
		up.set_flip_h(false)

# --> last state
func test_teleporting_last():
	return status.seen and not status.detector_mid_blink and not status.player_close
func transition_teleporting_last():
	start_last()

# --> self
func test_teleporting_teleporting():
	return status.seen and not status.detector_mid_blink and status.player_close
func transition_teleporting_teleporting():
	print("Teleport Again")
	start(TELEPORTING)
