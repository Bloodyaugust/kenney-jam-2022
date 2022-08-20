extends Node2D

export var data_resource: Resource

var data: AsteroidData

onready var _area2d: Area2D = $"Area2D"
onready var _collision_shape: CollisionShape2D = $"Area2D/CollisionShape2D"
onready var _sprite: Sprite = $"Sprite"

var _resources: float
var _selected: bool
var _spin_rate: float

func _draw():
  if _selected:
    draw_arc(Vector2.ZERO, _collision_shape.shape.radius, 0, 2 * PI, 32, Color.green)

func _on_asteroid_selected(asteroid):
  if asteroid == self:
    _selected = true
  else:
    _selected = false
    
  update()

func _process(delta):
  rotate(_spin_rate * delta)
  
  if _selected:
    update()
  
func _ready():
  Store.connect("asteroid_selected", self, "_on_asteroid_selected")
  
  data = data_resource as AsteroidData
  
  _collision_shape.shape.radius = (data.size * 25) + 5
  _spin_rate = rand_range(-1, 1)
  _sprite.scale = _sprite.scale * data.size

func _on_Area2D_input_event(viewport, event: InputEvent, shape_idx):
  if event is InputEventMouseButton and event.is_pressed():
    Store.emit_signal("asteroid_selected", self)
