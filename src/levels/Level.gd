extends Node2D

onready var enemySpawnTimer = get_node("enemySpawnTimer")
onready var playerOneTrail = get_node("LineTrailPlayerOne")
onready var playerTwoTrail = get_node("LineTrailPlayerTwo")
onready var the_world = get_node("WorldEnvironment")
onready var line_effect_container = get_node("lineEffectContainer")
onready var camera = get_node('Camera')


export (PackedScene) var enemy
export (PackedScene) var LineEffectNode

export var useThreads :=bool(0)
export var baseMonsterHealth = 20
export var maxEnemies = 500
export var spawnMod = 1000000000 #
export var spawnTimeMod = 20
export var desiredFPS = 60
export var disableEnemies = true

var totalPlayerScore = 0
var totalEnemies = 0
var createEnemySpawnthread
var spawnEnemyOnDeathSpawnthread
var spawnEnemiesArray : Array = []
var spawnEnemiesChildrenArray : Array = []
var worldLevel = 0
var framesSinceSpawn = 0
var currentFrame = 0
var arcCoolDown = 0
var currentEffect = 0
var shakeCount = 0
var shakeMode = false
var touchMode = false
var enalbeShakeMode = true
#var elapsedTime := float(0.0)
#var isRecording = false
var isPlaying = false
#var isPausePlay = false
#var isPlayingAll = false
#var currentTrack = 0
#var recordedData = []
#var playingData = []
#var lastPlayedData = []
#var recordedTracks = [recordedData,recordedData,recordedData,recordedData]
#var playingTracks = [playingData,playingData,playingData,playingData] 
#var sixtyFPS = 0
#var lastSixtyFPS = 0


func _ready():
	camera = get_node('Camera')
	Engine.set_target_fps(60)
	updateBarColors()
	generateLineBeams()
	if get_node("Touch/touchMode"):
		for i in range(get_node("Touch/touchMode").get_child_count()):
			get_node("Touch/touchMode").get_child(i).visible = !get_node("Touch/touchMode").get_child(i).visible
			touchMode = false
	#playerOneTrail.position = Vector2.ZERO
	#playerOneTrail.global_position = Vector2.ZERO

func updateBarColors():
	get_node("HUD/playerOneBar").setColor(get_node("player").playerColor)
	get_node("HUD/playerTwoBar").setColor(get_node("player2").playerColor)

func getNextColorInArray(isPositive = true):
	if isPositive:
		return get_node("player").getNextColorInArray(true)
	else:
		return get_node("player2").getNextColorInArray(true)
	

func updateBars():
	get_node("HUD/playerOneBar").setPower(get_node("player").playerLevel)
	get_node("HUD/playerTwoBar").setPower(get_node("player2").playerLevel)
	
func _process(delta):
	if Input.is_action_just_pressed("touch_toggle"):
		if (get_node("HUD/touch/Label").get_text()=='TOUCH OFF'):
			get_node("HUD/touch/Label").set_text('TOUCH ON')
			touchMode = false
		else:
			get_node("HUD/touch/Label").set_text('TOUCH OFF')
			touchMode = true
		for i in range(get_node("Touch/touchMode").get_child_count()):
			get_node("Touch/touchMode").get_child(i).visible = !get_node("Touch/touchMode").get_child(i).visible
	if Input.is_action_just_pressed("shake_toggle"):
		camera.set_offset(Vector2.ZERO)
		shakeCount = 0
		shakeMode = false
		if (get_node("HUD/shake/Label").get_text()=='SHAKE OFF'):
			enalbeShakeMode = false
			get_node("HUD/shake/Label").set_text('SHAKE ON')
		else:
			enalbeShakeMode = true
			get_node("HUD/shake/Label").set_text('SHAKE OFF')
	if Input.is_action_just_pressed("glow_toggle"):
		the_world.toggle_glow()
		if (get_node("HUD/glow/Label").get_text()=='GLOW OFF'):
			get_node("HUD/glow/Label").set_text('GLOW ON')
		else:
			get_node("HUD/glow/Label").set_text('GLOW OFF')
	if Input.get_action_strength("help_screen")>0:
		if(get_node("splashscreen").rect_size==Vector2.ZERO):
			get_node("splashscreen").rect_size=Vector2(1366,768)
		else:
			get_node("splashscreen").rect_size=Vector2.ZERO
	
	if Input.is_action_pressed("player_pause_game"):
		if(get_node("splashscreen").rect_size==Vector2.ZERO):
			get_node("splashscreen").rect_size=Vector2(1366,768)
		else:
			get_node("splashscreen").rect_size=Vector2.ZERO
		
	currentFrame += 1 * delta
	if Input.is_action_pressed("player_restart_game"):
		get_tree().reload_current_scene()
		#level reset
	#if totalEnemies < get_node("worldArea").get_child_count():
	#fpsSpawnEnemies(delta)
	if currentFrame > 10:
		currentFrame = 0
		HUDUpadate()

func _physics_process(delta):
	isPlaying = get_node("GameEventManager").isPlaying || get_node("GameEventManager").isPlayingAll
	drawTrail()
	if arcCoolDown>0:
		arcCoolDown -= 1
	if Input.get_action_strength('player_special_0')>0:
		specialLineEffectGenerator()
	if enalbeShakeMode:
		if shakeMode == true:
			shakeCount -= 0.5
			if shakeCount <= 0:
				camera.set_offset(Vector2.ZERO)
				shakeMode = false
			else:
				camera.set_offset(Vector2(
					camera.get_offset().x + rand_range(-0.5, 0.5) * shakeCount,
					camera.get_offset().y + rand_range(-0.5, 0.5) * shakeCount
				))

func alerts(msg):
	get_node("HUD/alerts").set_text(get_node("HUD/alerts").get_text() + " " + msg)

	


func shakeScreen(shake_amount=10):
	if enalbeShakeMode:
		shakeCount = int(rand_range(1,shake_amount))
		shakeMode = true
		camera.set_offset(Vector2.ZERO)
		camera.set_offset(Vector2(
	        rand_range(-1.0, 1.0) * shake_amount,
	        rand_range(-1.0, 1.0) * shake_amount
	    ))
		
	
func generateLineBeams():
	for __ in range(400):
		var l = LineEffectNode.instance()
		#l.setTexture(playerTexture)
		l.deactivate()
		line_effect_container.add_child(l)
func setArcCoolDown():
	arcCoolDown = 0 #5 - clamp(int((Engine.get_frames_per_second()/60)*5),0,5)
	
func specialLineEffectGenerator():
	#if arcCoolDown <= 0 :
	#		setArcCoolDown()
	var l = line_effect_container.get_child(currentEffect)
	if get_node('player'):
		l.setColor(get_node('player').getNextColorInArray())
		l.activate()
	currentEffect = currentEffect + 1
	if currentEffect > line_effect_container.get_child_count()-1:
		currentEffect = 0
				
func drawTrail():
	if !get_node("player").isLineTrail:
		playerOneTrail.clear_points()
		playerTwoTrail.clear_points()
		return
	playerOneTrail.myColor = get_node("player").currentColor
	playerTwoTrail.myColor = get_node("player2").currentColor
	
	playerOneTrail.width = 20 + int(get_node("player").playerLevel/5)
	playerTwoTrail.width = 20 + int(get_node("player2").playerLevel/5)
	#playerOneTrail.global_position = get_node("player").global_position
	if playerOneTrail.get_point_count()  > 100 + int(get_node("player2").playerLevel/2):
		playerOneTrail.remove_point(0)
		playerTwoTrail.remove_point(0)
	#playerOneTrail.add_point(get_node("player").global_position)
	playerOneTrail.add_point(get_node("player").position)
	playerTwoTrail.add_point(get_node("player2").position)
	
	
func HUDUpadate():
	totalPlayerScore = get_node("player").currentScore + get_node("player2").currentScore
	if totalPlayerScore < 0:
		totalPlayerScore = 0
	if totalEnemies < 0:
		totalEnemies = 0
	
	updateBars()
	worldLevel = get_node("player2").playerLevel + get_node("player").playerLevel
	
	#get_node("HUD/TotalScore").set_text(str(totalPlayerScore)+" World Level : "+ str(worldLevel))
	#get_node("HUD/TotalEnemies").set_text(str(totalEnemies)+"/"+str(maxEnemies))
	
	#get_node("HUD/NextWaveCounter").set_text("Next Wave in : " + str(enemySpawnTimer.get_time_left()))
	#get_node("HUD/EnemiesBacklog").set_text("Enemies Backlog: "+ str(spawnEnemiesArray.size()))
	#get_node("HUD/ChildrenBacklog").set_text("Children Backlog: "+ str(spawnEnemiesChildrenArray.size()))
	get_node("HUD/fps").set_text("FPS: "+ str(Engine.get_frames_per_second()))
	
func fpsSpawnEnemies(delta):
	return
	totalEnemies =get_node("worldArea").get_child_count()
	#Spawn queued enemies based on FPS (helps with lag not for online multiplayer)
	if framesSinceSpawn > 5:
		if maxEnemies > desiredFPS:
			maxEnemies -= desiredFPS
		else:
			maxEnemies = desiredFPS + 10
		framesSinceSpawn = 0
		var scoreRegenRate = (1 - clamp(((totalEnemies+1)/abs(maxEnemies+1)),0.001,9.999))
		get_node("player").currentScore += 2*(worldLevel+1)*500000 * scoreRegenRate
		get_node("player2").currentScore += 2*(worldLevel+1)*500000 * scoreRegenRate
		var frameDeltaFrac = 1 - Engine.get_frames_per_second()/desiredFPS
		for __ in range(int(get_node("worldArea").get_child_count()*(frameDeltaFrac))):
			get_node("worldArea").get_child(__).queue_free()
	if disableEnemies:
		framesSinceSpawn += 1*delta	
		return
	if Engine.get_frames_per_second() > desiredFPS && totalEnemies < maxEnemies:
		if maxEnemies < (desiredFPS * 10):
			maxEnemies += 1
		var inverseFrameDeltaFrac = (Engine.get_frames_per_second()-desiredFPS)/desiredFPS
		var allowedEnemies = clamp(int((maxEnemies - totalEnemies)/2),0,(desiredFPS/2)*inverseFrameDeltaFrac)
		var spawnLooper = int((Engine.get_frames_per_second()-desiredFPS)/3)
		for __ in range(clamp(spawnLooper,0,allowedEnemies)):
			if (spawnEnemiesArray.size() > 0 && __%2==0) || (spawnEnemiesArray.size() > 0 && spawnEnemiesChildrenArray.size() == 0):
				get_node("worldArea").add_child(spawnEnemiesArray.pop_front())
			if (spawnEnemiesChildrenArray.size() > 0 && __%2==1) || (spawnEnemiesChildrenArray.size() > 0 && spawnEnemiesArray.size() == 0):
				get_node("worldArea").add_child(spawnEnemiesChildrenArray.pop_front())
	else:
		framesSinceSpawn += 1*delta	
	
	
func createEnemyThread(worldLevel):
	if disableEnemies:
		return
	createEnemy(worldLevel)
	createEnemySpawnthread.wait_to_finish()
	#thread.call_deferred("wait_to_finish")
	
	
func createEnemy(worldLevel):
	if disableEnemies:
		return
	var healthMod = baseMonsterHealth
	var spawnCount = (worldLevel+1)*10
	if  spawnCount + totalEnemies > maxEnemies:
		if totalEnemies < maxEnemies:
			healthMod = int((spawnCount * healthMod) / 1+(spawnCount /maxEnemies - totalEnemies))
			spawnCount = maxEnemies - totalEnemies			
		else:
			spawnCount = 1
			healthMod = int((spawnCount * healthMod))
			
	for __ in range(spawnCount):
		var e = enemy.instance()
		e.monsterLevel = worldLevel+10
		e.health = e.monsterLevel * healthMod
		e.maxHealth = e.health
		var spawnRangeX = range(40,200) +range(OS.get_screen_size().x-200,OS.get_screen_size().x-40)
		var spawnRangeY = range(40,200) +range(OS.get_screen_size().y-200,OS.get_screen_size().y-40)
		#40>200 -- max-22>max-40
		spawnRangeX.shuffle()
		spawnRangeY.shuffle()
		var x = spawnRangeX[0]
		var y = spawnRangeY[0] #1 + int(rand_range(0,OS.get_screen_size().y))
		e.position = Vector2(x,y)
		e.spawned()
		spawnEnemiesArray.push_back(e)
		if spawnEnemiesArray.size() > maxEnemies*2:
			spawnEnemiesArray.pop_front()
		#get_node("worldArea").add_child(e)

func spawnEnemyOnDeathThread(position,level):
	if disableEnemies:
		return
	spawnEnemyOnDeathSpawnthread = Thread.new()
	spawnEnemyOnDeathSpawnthread.start(self,"spawnEnemyOnDeath",position,level,true)
	
func spawnEnemyOnDeath(position,level):
	if disableEnemies:
		return
	var isThread=false
	var healthMod = baseMonsterHealth
	var spawnCount = level
	
	if  spawnCount > 8:
		healthMod = int((healthMod * spawnCount)/8)
		spawnCount = 8

	if  spawnCount + totalEnemies > maxEnemies:
		if totalEnemies < maxEnemies:
			healthMod = int((spawnCount * healthMod) / (spawnCount /maxEnemies - totalEnemies))
			spawnCount = maxEnemies - totalEnemies			
		else:
			spawnCount = 1
			healthMod = int((spawnCount * healthMod))
			
	for __ in range(spawnCount):
		var e = enemy.instance()
		e.position = position + Vector2(int(rand_range(-4,4)),int(rand_range(-4,4)))
		e.monsterLevel = int(level/10)+1
		e.health = 1+(e.monsterLevel * healthMod)
		#e.spawned()
		spawnEnemiesChildrenArray.push_back(e)
		if spawnEnemiesChildrenArray.size() > maxEnemies*2:
			spawnEnemiesChildrenArray.pop_front()
		#get_node("worldArea").add_child(e)
	if isThread && useThreads:
		spawnEnemyOnDeathSpawnthread.wait_to_finish()
	
func _exit_tree():
	if useThreads:
    	createEnemySpawnthread.wait_to_finish()

func _on_enemySpawnTimer_timeout():
	if useThreads:
		createEnemySpawnthread = Thread.new()
		createEnemySpawnthread.start(self, "createEnemyThread",int(totalPlayerScore/100))
	else:
		createEnemy(int(worldLevel/2)+1)
	enemySpawnTimer.start(spawnTimeMod * (totalEnemies+1)/maxEnemies)



