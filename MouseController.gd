extends Node
class_name MouseController

@export var spotlights: Array[SweepingSpotlight] = []
@export var camera: Camera3D

var _actionToIndexList = ["North", "East", "South", "West"]

func getNumberOfSpotlights():
	return spotlights.size()
	
func getSpotlightPosition(index):
	return spotlights[index].global_position
	
func getSpotlightTarget(index):
	return spotlights[index].getTargetPosition()	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed == true:
			var from = camera.project_ray_origin(event.position)
			var to = from + camera.project_ray_normal(event.position) * 100
			var cursorPos = Plane(Vector3.UP, 0).intersects_ray(from, to)
			
			for actionIndex in range(_actionToIndexList.size()):
				var action = _actionToIndexList[actionIndex]
				if Input.is_action_pressed(action):
					spotlights[actionIndex].setNewPosition(cursorPos)
			
			#print("Mouse Click/Unclick at: ", cursorPos)
