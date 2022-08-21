extends Control

onready var _growth: Control = $"%Growth"
onready var _growth_progress: Control = $"%GrowthProgress"
onready var _growth_progressbar: ProgressBar = $"%GrowthProgressbar"
onready var _growth_status: Label = $"%GrowthStatus"
onready var _growth_type: Label = $"%GrowthType"
onready var _nitrogen: ProgressBar = $"%NitrogenAmount"
onready var _potassium: ProgressBar = $"%PotassiumAmount"
onready var _phosphates: ProgressBar = $"%PhosphatesAmount"
onready var _propagation: Control = $"%Propagation"
onready var _propagate: Button = $"%Propagate"
onready var _resources: Label = $"%ResourcesRemaining"
onready var _water: ProgressBar = $"%WaterAmount"

func _on_asteroid_selected(asteroid):
  if asteroid:
    var _asteroid_data: AsteroidData = asteroid.data as AsteroidData
    visible = true
    
    var _resource_ratios: Dictionary = _asteroid_data.get_resource_ratios()
    _nitrogen.value = _resource_ratios.nitrogen * 100
    _potassium.value = _resource_ratios.potassium * 100
    _phosphates.value = _resource_ratios.phosphates * 100
    _water.value = _resource_ratios.water * 100

    if asteroid.growth:
      _update_growth_details(asteroid)
    else:
      _growth.visible = false
    
  else:
    visible = false
    _propagation.visible = false

func _on_propagate_pressed():
  Store.emit_signal("propagate", Store.selected_asteroid)

func _process(delta):
  if visible:
    _resources.text = "Resources remaining: %d" % Store.selected_asteroid._resources

    if Store.selected_asteroid.growth:
      _propagation.visible = false
      _update_growth_details(Store.selected_asteroid)
    elif Store.selected_asteroid in GrowthController.growable_asteroids:
      _propagation.visible = true
      _update_propagation()

func _ready():
  Store.connect("asteroid_selected", self, "_on_asteroid_selected")
  _propagate.connect("pressed", self, "_on_propagate_pressed")
  
  visible = false

func _update_propagation():
  var _can_propagate: bool = true
  for _resource_key in Constants.PROPAGATION_COST.keys():
    if Store.resources[_resource_key] < Constants.PROPAGATION_COST[_resource_key]:
      _can_propagate = false
      break

  _propagate.disabled = !_can_propagate

func _update_growth_details(asteroid):
  var _growth_details: Dictionary = asteroid.growth.get_growth_details()

  _growth_status.text = "Status: %s" % _growth_details.status
  _growth_type.text = "Type: %s" % _growth_details.type

  if _growth_details.complete:
    _growth_progress.visible = false
  else:
    _growth_progress.visible = true

    _growth_progressbar.value = _growth_details.growth_progress * 100

  _growth.visible = true
