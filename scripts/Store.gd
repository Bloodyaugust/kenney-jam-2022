extends Node2D

signal asteroid_selected(asteroid)

var selected_asteroid
var resources: Dictionary = {
  "nitrogen": 0,
  "potassium": 0,
  "phosphates": 0,
  "water": 0,
}

func _on_asteroid_selected(asteroid):
  selected_asteroid = asteroid

func _ready():
  connect("asteroid_selected", self, "_on_asteroid_selected")

func _unhandled_input(event):
  if event is InputEventMouseButton and event.is_pressed():
    emit_signal("asteroid_selected", null)
