
extends Character

class_name PassengerNew

export (float) var caution_time = 4

export (NodePath) var player_path = "../Player"
onready var player : Character = get_node(player_path)
onready var danger_radius : RayCast2D = $DangerRadius
onready var fear_radius : RayCast2D = $FearRadius
onready var caution_radius : RayCast2D = $CautionRadius
onready var caution_timer : Timer = $CautionTimer

const CLOSE = "close"
const NEAR = "near"
const FAR = "far"
const DISTANT = "distant"

var interactables = []
var num_detectors = 0
var detector_mid_blink = false
var detector_blinking = false

# Statuses
onready var status:Dictionary = {
	"confrontational":false,
	"rushing":false,
	"afraid":false,
	"seen":false,
	"endangered":false,
	"safe":true,
	"locked_in":false,
}

# Params
onready var params:Dictionary = {
	"recent_blinks":0,
}

var pass_state

func _ready():
	pass_state = PersistentState.new(self, PassFactory)
	add_child(pass_state)

# High Level

# how to move
func start_sprinting(): set_sprint(true)
func start_sneaking(): set_sneak(true)
func start_walking():
	set_sprint(false)
	set_sneak(false)

# which way to move
func stop_moving(): set_move_dir(Vector2())
func move_away_from_player(): set_move_dir(Vector2(-1, move_dir.y))
func move_toward_goal(): set_move_dir(Vector2(1, move_dir.y))

# complex moves
func leap_frog(): position.x = player.position.x + (player.position.x - position.x)
func spooky_approach(): position.x += (player.position.x - position.x) / 2
func stalk():
	move_dir.x = player_dir().x
	if (moving()):
		start_walking()
		if (moving_left()):
			strafe(sneak_speed)
	else:
		wait()

# info gathering
func is_cautious(): return not caution_timer.is_stopped()
func is_detected(): return num_detectors > 0
func is_cornered(): return is_on_wall() and in_player_range() and velocity.x < 0
func in_danger(): return player_detected(danger_radius)
func in_fear(): return player_detected(fear_radius)
func in_caution(): return player_detected(caution_radius)
func in_player_range(): return player_range() != DISTANT
func player_close(): return in_danger()
func player_near(): return in_fear() and not in_danger()
func player_far(): return in_caution() and not in_fear()
func player_distant(): return not in_caution()
func player_range():
	return CLOSE if in_danger() else (
		NEAR if in_fear() else (
			FAR if in_caution() else (
				DISTANT 
	)))

# Low Level

func set_status(status:String, enable:bool): self.status[status] = enable
func set_param(param:String, value:int): self.params[param] = value
func inc_param(param:String): self.params[param] += 1

func player_dir(): return player.move_dir
func player_detected(raycast : RayCast2D):
	if (raycast.is_colliding()):
		var collider = raycast.get_collider()
		if (collider.is_in_group("player")):
			return true
	return false

# Caution Timer

func start_caution_timer(): caution_timer.start(caution_time)
func _on_Caution_Timer_timeout(): caution_timer.stop()

# Interaction

func trigger_door(open=null):
	print("Triggered Door")
	for interactable in interactables:
		if interactable.is_in_group("door"):
			interactable.trigger(self, open)

func can_interact(): return interactables.size() > 0
func add_interactable(interactable): interactables.append(interactable)
func remove_interactable(interactable): interactables.erase(interactable)
func _on_Interactor_area_entered(area):
	if area.is_in_group("interactable"):
		pass_state.execute("_add_interactable", area)
func _on_Interactor_area_exited(area):
	if area.is_in_group("interactable"):
		pass_state.execute("_remove_interactable", area)

# Detection

func detect(): self.num_detectors += 1
func stop_detecting(): self.num_detectors -= 1
func _detector_blinking(blinking:bool):
#	print("Blinking? ", "Yes" if blinking else "No")
	detector_blinking = blinking
func _detector_mid_blink(is_mid_blink:bool):
#	print("Mid Blink? ", "Yes" if is_mid_blink else "No")
	pass_state.execute("_set_mid_blink", is_mid_blink)
	if is_mid_blink: inc_param("recent_blinks")
