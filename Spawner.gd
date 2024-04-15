extends Node

@export var sourcePath: PathFollow3D
@export var targetPath: PathFollow3D
@export var controller: MouseController
@onready var timer = $"Timer"
@export var creeperScene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	sourcePath.progress_ratio = randf()
	targetPath.progress_ratio = randf()
	
	var creeper = creeperScene.instantiate() as Creeper
	get_parent().add_child(creeper)
	creeper.setup(sourcePath.global_position, targetPath.global_position, controller)
	
	timer.wait_time = 1.5 + 0.5 * randf()
	pass # Replace with function body.
