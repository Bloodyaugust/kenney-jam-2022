extends Node2D

export var data_resource: Resource

var data: AsteroidData

onready var _area2d: Area2D = $"Area2D"
onready var _collision_shape: CollisionShape2D = $"Area2D/CollisionShape2D"
onready var _sprite: Sprite = $"Sprite"

var _resources: float
var _spin_rate: float

func _draw():
  draw_arc(Vector2.ZERO, _collision_shape.shape.radius, 0, 2 * PI, 32, Color.green)

func _process(delta):
  rotate(_spin_rate * delta)
  update()
  
func _ready():
  data = data_resource as AsteroidData
  
  _collision_shape.shape.radius = (data.size * 25) + 5
  _spin_rate = rand_range(-1, 1)
  _sprite.scale = _sprite.scale * data.size
