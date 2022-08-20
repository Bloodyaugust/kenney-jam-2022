extends Control

onready var _growth: Control = $"%Growth"
onready var _growth_progress: Control = $"%GrowthProgress"
onready var _growth_progressbar: ProgressBar = $"%GrowthProgressbar"
onready var _growth_status: Label = $"%GrowthStatus"
onready var _growth_type: Label = $"%GrowthType"
onready var _nitrogen: ProgressBar = $"%NitrogenAmount"
onready var _potassium: ProgressBar = $"%PotassiumAmount"
onready var _phosphates: ProgressBar = $"%PhosphatesAmount"
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

func _process(delta):
  if visible:
    _resources.text = "Resources remaining: %s" % Store.selected_asteroid._resources

    if Store.selected_asteroid.growth:
      _update_growth_details(Store.selected_asteroid)

func _ready():
  Store.connect("asteroid_selected", self, "_on_asteroid_selected")
  
  visible = false

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
