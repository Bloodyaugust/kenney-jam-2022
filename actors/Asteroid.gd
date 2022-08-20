extends Node2D

export var data_resource: Resource

var data: AsteroidData
var growth

onready var _area2d: Area2D = $"Area2D"
onready var _collision_shape: CollisionShape2D = $"Area2D/CollisionShape2D"
onready var _sprite: Sprite = $"Sprite"

var _resources: float
var _resource_ratios: Dictionary
var _selected: bool
var _spin_rate: float

func collect_resources(amount) -> Dictionary:
  var _collected_resources = clamp(_resources - amount, 0, amount)

  _resources -= _collected_resources

  return {
    "nitrogen": _resource_ratios.nitrogen * _collected_resources,
    "potassium": _resource_ratios.potassium * _collected_resources,
    "phosphates": _resource_ratios.phosphates * _collected_resources,
    "water": _resource_ratios.water * _collected_resources,
    "total": _collected_resources
  }

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
  
  _resources = data.size * 1000
  _resource_ratios = data.get_resource_ratios()
  
  var _greatest_resource: String = "water"
  for _resource in Constants.RESOURCE_TYPES:
    if data[_resource] > data[_greatest_resource]:
      _greatest_resource = _resource
      
  _sprite.modulate = _sprite.modulate.linear_interpolate(Constants.RESOURCE_COLORS[_greatest_resource], 0.8)

func _on_Area2D_input_event(viewport, event: InputEvent, shape_idx):
  if event is InputEventMouseButton and event.is_pressed():
    Store.emit_signal("asteroid_selected", self)
