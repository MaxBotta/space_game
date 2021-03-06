extends Area2D

var bounce_power
var bounce_on = false
var parent
var direction
var collision_shape
export (float) var scale_factor = 1.16
var bodies_in_field = []
var explosion_timer = 0
var explosion_anim
export (float) var explosion_duration = 0.34
var is_exploding = false

func _ready():
	parent = get_parent()
	bounce_power = parent.get("bounce_power")
	explosion_anim = get_node("Explosion")
	collision_shape = get_child(0)
	
func _process(delta):
	if parent.get("bounce_on"):
		explosion_timer = explosion_duration
		self.visible = true
	explosion(delta)
		
func _on_Area2D_body_entered(body):
	bodies_in_field.push_back(body)
	
func _on_Area2D_body_exited(body):
	bodies_in_field.erase(body)
	
func _on_Area2D_area_shape_exited(shape, a,b,c):
	pass
	
	
func explosion(delta):
	if explosion_timer > 0:
		for item in bodies_in_field:
			direction = (item.get_global_transform().get_origin() - self.get_global_transform().get_origin()).normalized() * bounce_power
			item.apply_impulse(Vector2(0,0), direction)
		
		explosion_anim.visible = true
		explosion_anim.play()
		explosion_timer -= delta
		var scale = collision_shape.get_scale()
		collision_shape.set_scale(scale * scale_factor)
	else:
		explosion_timer = 0
		self.visible = false
		collision_shape.set_scale(Vector2(0.1, 0.1))
	
	
		
			
		
