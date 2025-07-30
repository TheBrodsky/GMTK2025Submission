extends Component;
class_name HealthComponent;

signal on_hit(source);

@export var max_health_pointsM: int;
var current_health: int;
