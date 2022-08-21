extends Control

onready var _nitrogen: Label = $"%NitrogenCollected"
onready var _potassium: Label = $"%PotassiumCollected2"
onready var _phosphates: Label = $"%PhosphatesCollected3"
onready var _water: Label = $"%WaterCollected4"

func _process(delta):
  var _net_resource_income: Dictionary = {
    "nitrogen": 0,
    "potassium": 0,
    "phosphates": 0,
    "water": 0,
  }

  for _growth in GrowthController.growths:
    var _growth_net = _growth.get_growth_resources_net()

    _net_resource_income.nitrogen += _growth_net.nitrogen
    _net_resource_income.potassium += _growth_net.potassium
    _net_resource_income.phosphates += _growth_net.phosphates
    _net_resource_income.water += _growth_net.water

  _nitrogen.text = "Nitrogen: %d (%.2f/sec)" % [Store.resources.nitrogen, _net_resource_income.nitrogen]
  _potassium.text = "Potassium: %d (%.2f/sec)" % [Store.resources.potassium, _net_resource_income.potassium]
  _phosphates.text = "Phosphates: %d (%.2f/sec)" % [Store.resources.phosphates, _net_resource_income.phosphates]
  _water.text = "Water: %d (%.2f/sec)" % [Store.resources.water, _net_resource_income.water]

  if _net_resource_income.nitrogen <= 0:
    _nitrogen.modulate = Constants.COLOR_NITROGEN
  else:
    _nitrogen.modulate = Color.white
  if _net_resource_income.potassium <= 0:
    _potassium.modulate = Constants.COLOR_NITROGEN
  else:
    _potassium.modulate = Color.white
  if _net_resource_income.phosphates <= 0:
    _phosphates.modulate = Constants.COLOR_NITROGEN
  else:
    _phosphates.modulate = Color.white
  if _net_resource_income.water <= 0:
    _water.modulate = Constants.COLOR_NITROGEN
  else:
    _water.modulate = Color.white
