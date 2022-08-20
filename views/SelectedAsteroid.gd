extends Control

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
    
  else:
    visible = false

func _process(delta):
  if visible:
    _resources.text = "Resources remaining: %s" % Store.selected_asteroid._resources

func _ready():
  Store.connect("asteroid_selected", self, "_on_asteroid_selected")
  
  visible = false
