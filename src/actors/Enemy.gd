extends Area2D

onready var waittime = get_node("waittime")
onready var walktime = get_node("walktime")
onready var lifeTime = get_node("lifeTime")


export var health = 100
export var maxScale = 1.0


var velocity:= Vector2.ZERO
var speedRange = 50
var minSpeed = 0
var maxSpeed = 50
var speed := Vector2(200.0,200.0)
var direction:= Vector2.ZERO 
var screen_size
var monsterLevel = 1
var canWallWarp := true
var newScale = 0
var healthScaleMod = 100
var maxHealth = 20
var myAge = 0


func _ready():
	#get_parent().get_parent().totalEnemies += 1
	screen_size = get_viewport_rect().size
	healthScale()
	
func ai():
	pass
	
func _physics_process(delta):
	#ai()
	if myAge < 500:
		myAge += 1*delta
	if speed != Vector2.ZERO:
		velocity = direction*speed
		position += velocity*delta
	warpWalls(delta)
	healthScale()
	rotation = direction.angle()

func warpWalls(delta):
	#stop if you touch the walls
	#what about spwan on otherside 
	if canWallWarp:
		if position.x < 40:
			position.x = screen_size.x-40 + (40 - position.x)
		elif position.x > screen_size.x-40:
			position.x = 45 + (position.x - (screen_size.x-40))
		
		if position.y < 40:
			position.y = screen_size.y-60 + (40 - position.y)
		elif position.y > screen_size.y-60:
			position.y = 45  + (position.y - (screen_size.y-60))
		
	position.x = clamp(position.x, 40, screen_size.x-40)
	position.y = clamp(position.y, 40, screen_size.y-60)	

func spawned():
	healthScale()
	#print(str(monsterLevel) +" : "+ str(health) +" : "+ str(maxHealth) +" : " + str(newScale)+" : " + str(scale.x))
	
func healthScale():
	#var iscale = ((clamp((health/maxHealth),0.01,maxScale/2)+(monsterLevel/100))*(maxScale)) + 0.5
	newScale = 0.5 + ((monsterLevel/100) * (maxScale-0.5)) *(health/maxHealth)
	#iscale = clamp(iscale,0.5,maxScale)
	scale = Vector2(newScale,newScale)
	

func _on_Enemy_area_entered(area):
	if area.is_in_group("playerBullet"):
		health = health - area.damage
		area.updatePlayerScore(area.damage*100)
		if area.canPiercing:
			if rand_range(0,1) > area.pierceChance:
				area.queue_free()
		checkHealth()
		
	if area.is_in_group("player"):
		area.updatePlayerScore(health)
		health = 0 #health - ((area.playerLevel+1)*10)
		checkHealth()
	
func checkHealth():
	if (health <= 0):
		if monsterLevel > 1 && myAge > 100 && rand_range(0,monsterLevel*2)<=monsterLevel:
			#get_parent().spawnEnemyOnDeath(position,monsterLevel)
			get_parent().get_parent().spawnEnemyOnDeath(position,monsterLevel)
			#get_parent().get_parent().get_parent().spawnEnemyOnDeath(position,monsterLevel)
		get_parent().get_parent().totalEnemies -= 1
		queue_free()

func _on_lifeTime_timeout():
	#upgrade monster
	maxHealth = int(maxHealth * 1.1)#(maxHealth/monsterLevel) * (monsterLevel+1)
	health = maxHealth
	speed.x = speed.x * 1.1
	speed.y = speed.y * 1.1
	speedRange = int(speedRange * 1.1) 
	lifeTime.start(10+monsterLevel)
	#get_parent().get_parent().totalEnemies -= 1
	#queue_free()

func _on_walktime_timeout():
	speed = Vector2.ZERO
	waittime.start(int(rand_range(1,3)))

func _on_waittime_timeout():
	walktime.start(int(rand_range(2,8)))
	minSpeed = speedRange + monsterLevel
	maxSpeed = (speedRange + monsterLevel) * 2
	speed = Vector2(rand_range(minSpeed,maxSpeed),rand_range(minSpeed,maxSpeed))
	if rand_range(0,10) > 2: #ceil((monsterLevel*2)/10):
		direction = Vector2(rand_range(-1,1),rand_range(-1,1))
	else:
		direction = (Vector2(OS.get_screen_size().x/2,OS.get_screen_size().y/2) - position).normalized()