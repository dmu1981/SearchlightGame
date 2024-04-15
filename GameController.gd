extends Node

var totalEscaped = 0
var totalKilled = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalHub.onCreeperEscaped.connect(_onCreeperEscaped)
	SignalHub.onCreeperKilled.connect(_onCreeperKilled)
	pass # Replace with function body.

func _onCreeperEscaped():
	totalEscaped += 1
	SignalHub.onNewPoints.emit(totalEscaped, totalKilled)
	
func _onCreeperKilled():
	totalKilled += 1
	SignalHub.onNewPoints.emit(totalEscaped, totalKilled)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
