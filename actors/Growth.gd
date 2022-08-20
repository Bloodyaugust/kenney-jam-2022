extends Node2D

const FOLIAGE_SPRITES: Array = [
  preload("res://sprites/foliage/foliagePack_001.png"),
  preload("res://sprites/foliage/foliagePack_002.png"),
  preload("res://sprites/foliage/foliagePack_003.png"),
  preload("res://sprites/foliage/foliagePack_018.png"),
  preload("res://sprites/foliage/foliagePack_019.png"),
  preload("res://sprites/foliage/foliagePack_020.png"),
  preload("res://sprites/foliage/foliagePack_021.png"),
 ]
const FOLIAGE_SCALE_MODIFIER: Vector2 = Vector2(0.0005, 0.0005)

export var starting_asteroid: NodePath

var asteroid: Node2D

onready var _connections: Node2D = $"%Connections"

var _asteroid_data: AsteroidData
var _foliage: Node2D

func _process(delta):
  for _child in _foliage.get_children():
    _child.scale = _child.scale - (sin((Time.get_ticks_msec() as float + _child.get_meta("scale_offset")) / 512) * FOLIAGE_SCALE_MODIFIER)

  _connections.get_child(0).width = 10 - (sin((Time.get_ticks_msec() as float) / 512))

func _ready():
  if starting_asteroid:
    asteroid = get_node(starting_asteroid)
    
  _asteroid_data = asteroid.data as AsteroidData
  
  _foliage = asteroid.find_node("Foliage", true, false)
  
  var _num_foliage: int = (randi() % 6) + 1 + _asteroid_data.size
  for _i in range(_num_foliage):
    var _new_foliage: Sprite = Sprite.new()
    var _new_position: Vector2 = global_position + (Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized() * (_asteroid_data.size * rand_range(20.0, 25.0)))

    _new_foliage.texture = FOLIAGE_SPRITES[randi() % FOLIAGE_SPRITES.size()]
    _new_foliage.scale = Vector2(0.4, 0.4)
    _new_foliage.global_position = _new_position
    _new_foliage.rotation = global_position.angle_to_point(_new_position) - PI / 2
    _new_foliage.set_meta("scale_offset", rand_range(0, 10000))
    _foliage.add_child(_new_foliage)
