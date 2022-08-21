extends Node2D

const GROWTH_SCENE: PackedScene = preload("res://actors/Growth.tscn")

onready var asteroids = get_tree().get_nodes_in_group("asteroids")
onready var growths = get_tree().get_nodes_in_group("growths")
onready var growths_container = get_tree().get_root().find_node("GrowthsContainer", true, false)

var growable_asteroids: Array

func _evaluate_asteroid_growability(growth):
  if growth:
    growths.append(growth)

  growable_asteroids = []
  
  for _asteroid in asteroids:
    if _asteroid.growth:
      continue
    
    for _growth in growths:
      if _asteroid.global_position.distance_to(_growth.global_position) <= _growth.growth_radius:
        growable_asteroids.append(_asteroid)
        continue

func _on_propagate(asteroid: Node2D):
  var _new_growth: Node2D = GROWTH_SCENE.instance()

  _new_growth.global_position = asteroid.global_position
  _new_growth.starting_type = 0
  _new_growth.asteroid = asteroid
  growths_container.add_child(_new_growth)

  for _resource_key in Constants.PROPAGATION_COST.keys():
    Store.resources[_resource_key] -= Constants.PROPAGATION_COST[_resource_key]

func _ready():
  Store.connect("growth_finished", self, "_evaluate_asteroid_growability")
  Store.connect("propagate", self, "_on_propagate")
  
  _evaluate_asteroid_growability(null)
