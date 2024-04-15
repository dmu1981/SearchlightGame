extends Node3D
class_name Creeper

const _healthThreshold = 0.01
const _distanceThreshold = 0.5

@export var controller: MouseController
var _targetPosition : Vector3 = Vector3(2.5,0.0, -2.5)
@onready var body = $"CharacterBody3D"

var _heat = 0
var _health = 1

func setup(sourcePos: Vector3, targetPos: Vector3, cntrl: MouseController):
	body.position = sourcePos
	_targetPosition = targetPos
	controller = cntrl

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _calculatellumination():
	var bestProduct = 0.0
	var openingAngleDegrees = 10
	var openingAngleThreshold = cos(openingAngleDegrees * PI / 180)
	
	for spotlightIndex in range(controller.getNumberOfSpotlights()):
		var spotlightPosition = controller.getSpotlightPosition(spotlightIndex)
		var spotlightTarget = controller.getSpotlightTarget(spotlightIndex)
		
		var spotlightDirection = (spotlightTarget - spotlightPosition).normalized()
		var creeperDirection   = (body.global_position - spotlightPosition).normalized()
		var dotProduct 		   = spotlightDirection.dot(creeperDirection)
		bestProduct = max(bestProduct, dotProduct)
	
	var illumination = max((bestProduct - openingAngleThreshold) / (1.0 - openingAngleThreshold), 0)
	illumination = pow(illumination, 5)
	return illumination
	
func _updateHeat(delta):
	# Decrease heat by a constant velocity
	_heat = clamp(_heat + (0.0 - _heat) * delta * 0.8, 0.0, 1.0)
	
	# Accumulate heat by illumination
	_heat = clamp(_heat + _calculatellumination() * 3.0 * delta, 0.0, 1.0)
		
func _updateHealth(delta):
	# Substract current heat from health
	_health = clamp(_health - _heat * delta, 0.0, 1.0)
	
	if _health < _healthThreshold:
		SignalHub.onCreeperKilled.emit()
		queue_free()
		
func _calculateVelocity():	
	var totalW = 1.0
	var movementDirection = (_targetPosition - body.global_position).normalized()
	
	for spotlightIndex in range(controller.getNumberOfSpotlights()):
		var spotlightTarget = controller.getSpotlightTarget(spotlightIndex)
		var avoidanceVelocity = (body.global_position - spotlightTarget)
		avoidanceVelocity.y = 0
		avoidanceVelocity = avoidanceVelocity.normalized()
		
		var w = 1.0 / (2.5 * (body.global_position - spotlightTarget).length() + 0.1)
		movementDirection += w * avoidanceVelocity
		totalW += w
		
	var maxVelocity = 0.9 * (1.0 - _heat)			
	body.velocity = movementDirection / totalW * maxVelocity

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# First, check if we reached our targer
	var distance = (body.global_position - _targetPosition).length()
	if distance < _distanceThreshold:
		SignalHub.onCreeperEscaped.emit()
		#print("Creeper reached Target")
		queue_free()
	
	_updateHeat(delta)
	_updateHealth(delta)	
	
	var phase = randf() * 6.28
	var angle = -0.5 + randf() * 1.0
	var axis = Vector3(cos(phase), 0.0, sin(phase))
	body.transform.basis = body.transform.basis.slerp(Basis(axis, angle), min(delta * 15.0 * _heat, 0.8)).orthonormalized()
	
	# Move body physically
	_calculateVelocity()
	body.move_and_slide()
	pass
