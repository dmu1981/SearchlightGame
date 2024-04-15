extends Node3D
class_name SweepingSpotlight

@onready var controlledLight = $"SpotLight3D"
@export var biasDistance: float = 0.05
@export var movementSpeed: float = 1.8

var _targetPos: Vector3 = Vector3(-2,0,0)
var _currentTarget: Vector3 = Vector3(0,0,0)

func setNewPosition(targetPos):
	_targetPos = targetPos
	
func getTargetPosition():
	return _targetPos

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var deltaVector =  (_targetPos - _currentTarget)
	if deltaVector.length() > biasDistance:
		_currentTarget = _currentTarget + deltaVector.normalized() * delta * movementSpeed
	
	controlledLight.look_at_from_position(controlledLight.global_position, _currentTarget, Vector3(0,1,0))
	
	pass
