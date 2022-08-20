extends Control

onready var _nitrogen: Label = $"%NitrogenCollected"
onready var _potassium: Label = $"%PotassiumCollected2"
onready var _phosphates: Label = $"%PhosphatesCollected3"
onready var _water: Label = $"%WaterCollected4"

func _process(delta):
  _nitrogen.text = "Nitrogen: %d" % Store.resources.nitrogen
  _potassium.text = "Potassium: %d" % Store.resources.potassium
  _phosphates.text = "Phosphates: %d" % Store.resources.phosphates
  _water.text = "Water: %d" % Store.resources.water
