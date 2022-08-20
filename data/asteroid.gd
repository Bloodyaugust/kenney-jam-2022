extends Resource
class_name AsteroidData

export var nitrogen: float
export var potassium: float
export var phosphates: float
export var size: float
export var water: float

func get_resource_ratios() -> Dictionary:
  var total: float = nitrogen + potassium + phosphates + water
  
  return {
    "nitrogen": nitrogen / total,
    "potassium": potassium / total,
    "phosphates": phosphates / total,
    "water": water / total,
   }
