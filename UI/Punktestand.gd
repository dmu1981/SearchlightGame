extends Control

@export var prefix: String
@export var displayTotalKilled: bool
@onready var label = $"CenterContainer/Label"

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalHub.onNewPoints.connect(onNewPoints)
	onNewPoints(0,0)
	pass # Replace with function body.

func onNewPoints(totalEscaped, totalKilled):
	if displayTotalKilled:
		label.text = prefix + ": " + str(totalKilled)
	else:
		label.text = prefix + ": " + str(totalEscaped)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
