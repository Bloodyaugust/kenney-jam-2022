extends Node2D

enum GROWTH_STATUSES {GROWING, HEALTHY, WITHERED, INFECTED}
enum GROWTH_TYPES {COLLECTOR, DEFENDER, LEAF}

const COLLECTION_RATE: float = 1.0
const CONNECTION_SCENE: PackedScene = preload("res://doodads/Connection.tscn")
const CONNECTION_WIDTH: float = 20.0
const GROWTH_RADIUS_BASE: float = 75.0
const GROWTH_RADIUS_SCALAR: float = 2.0
const GROWTH_STATUS_NAMES: Dictionary = {
  GROWTH_STATUSES.GROWING: 'Growing',
  GROWTH_STATUSES.HEALTHY: 'Healthy',
  GROWTH_STATUSES.WITHERED: 'Withered',
  GROWTH_STATUSES.INFECTED: 'Infected'
}
const GROWTH_TIME: float = 4.0
const GROWTH_TYPE_NAMES: Dictionary = {
  GROWTH_TYPES.COLLECTOR: 'Collector',
  GROWTH_TYPES.DEFENDER: 'Defender',
  GROWTH_TYPES.LEAF: 'Leaf'
}
const FOLIAGE_SPRITES: Array = [
  preload("res://sprites/foliage/foliagePack_001.png"),
  preload("res://sprites/foliage/foliagePack_002.png"),
  preload("res://sprites/foliage/foliagePack_003.png"),
  preload("res://sprites/foliage/foliagePack_018.png"),
  preload("res://sprites/foliage/foliagePack_019.png"),
  preload("res://sprites/foliage/foliagePack_020.png"),
  preload("res://sprites/foliage/foliagePack_021.png"),
 ]
const FOLIAGE_SCALE: Vector2 = Vector2(0.4, 0.4)
const FOLIAGE_SCALE_MODIFIER: Vector2 = Vector2(0.0005, 0.0005)

export var starting_asteroid: NodePath
export(GROWTH_TYPES) var starting_type: int

var asteroid: Node2D
var growth_radius: float

onready var _connections: Node2D = $"%Connections"

var _asteroid_data: AsteroidData
var _foliage: Node2D
var _growth_time: float
var _status: int = GROWTH_STATUSES.GROWING
var _type: int

func get_growth_details() -> Dictionary:
  return {
    "complete": _growth_time == GROWTH_TIME,
    "growth_progress": _growth_time / GROWTH_TIME,
    "status": GROWTH_STATUS_NAMES[_status],
    "type": GROWTH_TYPE_NAMES[_type]
  }

func _draw():
  if Store.selected_asteroid == asteroid:
    draw_arc(Vector2.ZERO, growth_radius, 0, 2 * PI, 32, Color.red)

func _process(delta):
  if _status == GROWTH_STATUSES.GROWING:
    _growth_time = clamp(_growth_time + delta, 0.0, GROWTH_TIME)

    if _growth_time >= GROWTH_TIME:
      _status = GROWTH_STATUSES.HEALTHY
      Store.emit_signal("growth_finished", self)
  
  for _child in _foliage.get_children():
    _child.scale = _child.scale - (sin((Time.get_ticks_msec() as float + _child.get_meta("scale_offset")) / 512) * FOLIAGE_SCALE_MODIFIER)

  if _status != GROWTH_STATUSES.GROWING:
    for _connection in _connections.get_children():
      _connection.width = CONNECTION_WIDTH - (sin((Time.get_ticks_msec() as float) / 512))

  if _type == GROWTH_TYPES.COLLECTOR && (_status == GROWTH_STATUSES.HEALTHY || _status == GROWTH_STATUSES.INFECTED):
    var _collected_resources: Dictionary = asteroid.collect_resources(COLLECTION_RATE * delta)

    Store.resources.nitrogen += _collected_resources.nitrogen
    Store.resources.potassium += _collected_resources.potassium
    Store.resources.phosphates += _collected_resources.phosphates
    Store.resources.water += _collected_resources.water

  update()

func _ready():
  if starting_asteroid:
    asteroid = get_node(starting_asteroid)

  if starting_type:
    _type = starting_type

  asteroid.growth = self
  _asteroid_data = asteroid.data as AsteroidData

  growth_radius = (_asteroid_data.size * GROWTH_RADIUS_BASE) * GROWTH_RADIUS_SCALAR
  
  _foliage = asteroid.find_node("Foliage", true, false)
  
  var _num_foliage: int = (randi() % 6) + 1 + (_asteroid_data.size * _asteroid_data.size * _asteroid_data.size) as int
  for _i in range(_num_foliage):
    var _new_foliage: Sprite = Sprite.new()
    var _new_position: Vector2 = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized() * (_asteroid_data.size * rand_range(20.0, 25.0))
    var _tween: SceneTreeTween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)

    _new_foliage.texture = FOLIAGE_SPRITES[randi() % FOLIAGE_SPRITES.size()]
    _new_foliage.scale = Vector2(0.0, 0.0)
    _new_foliage.global_position = _new_position
    _new_foliage.rotation = Vector2.ZERO.angle_to_point(_new_position) - PI / 2
    _new_foliage.set_meta("scale_offset", rand_range(0, 10000))
    _foliage.add_child(_new_foliage)
    
    _tween.tween_property(_new_foliage, "scale", FOLIAGE_SCALE, rand_range(GROWTH_TIME / 2, GROWTH_TIME))

  for _growth in GrowthController.growths:
    if _growth != self && _growth.global_position.distance_to(global_position) <= _growth.growth_radius:
      var _new_connection: Line2D = CONNECTION_SCENE.instance()
      var _connection_tween: SceneTreeTween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)

      _connections.add_child(_new_connection)
      _new_connection.global_position = Vector2.ZERO
      _new_connection.points[0] = global_position
      _new_connection.points[1] = global_position.linear_interpolate(_growth.global_position, 0.5)
      _new_connection.points[2] = _growth.global_position

      _connection_tween.tween_property(_new_connection, "width", CONNECTION_WIDTH, rand_range(GROWTH_TIME / 2, GROWTH_TIME / 1.5))
