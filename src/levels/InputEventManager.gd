extends Node

var elapsedTime := float(0.0)
var isRecording = false
var isPlaying = false
var isPausePlay = false
var isPlayingAll = false
var currentTrack = 0
var recordedData = []
var playingData = []
var lastPlayedData = []
var recordedTracks = [recordedData,recordedData,recordedData,recordedData]
var playingTracks = [playingData,playingData,playingData,playingData] 
onready var AudioStreamPlayer = get_node("AudioStreamPlayer")

func _physics_process(delta):
	if AudioStreamPlayer:
		if AudioStreamPlayer.is_playing():
			elapsedTime = AudioStreamPlayer.get_playback_position()
		else:
			elapsedTime += delta
		#print("Playing : " + str(AudioStreamPlayer.is_playing())+" : "+ str(AudioStreamPlayer.get_playback_position()))
	
	
	if Input.is_action_just_pressed("load_music"):
		get_node("loadSong").set_visible(true)
	if Input.is_action_just_pressed("save_track"):
		saveTrack()
	if Input.is_action_just_pressed("load_track"):
		loadTrack()
	if Input.is_action_just_pressed("record_track"):
		if isRecording == false:
			isRecording = true
			recordedTracks[currentTrack] = []
			elapsedTime = 0.0
			AudioStreamPlayer.play(0.0)
		else:
			elapsedTime = 0.0
			isRecording = false
		isPlaying = false
		isPlayingAll = false
	if Input.is_action_just_pressed("play_track"):
		if isPlaying == false:
			elapsedTime = 0.0
			playingTracks[currentTrack] = []
			for __ in range(recordedTracks[currentTrack].size()-1):
				playingTracks[currentTrack] .append(recordedTracks[currentTrack][__])
			isPlaying = true
			AudioStreamPlayer.play(0.0)
		else:
			isPlaying = false
		isRecording = false
		isPlayingAll = false
	if Input.is_action_just_pressed("play_all"):
		if isPlayingAll == false:
			elapsedTime = 0.0
			for t in range(recordedTracks.size()):
				playingTracks[t] = []
				for __ in range(recordedTracks[t].size()-1):
					playingTracks[t] .append(recordedTracks[t][__])
			isPlayingAll = true
			isRecording = false
			AudioStreamPlayer.play(0.0)
		else:
			isPlayingAll = false
		isPlaying = false
		isRecording = false
	if Input.is_action_just_pressed("pause_track"):
		isPausePlay = !isPausePlay
	if Input.is_action_just_pressed("next_track"):
		isPlaying = false
		isRecording = false
		isPlayingAll = false
		currentTrack += 1 
		if currentTrack > recordedTracks.size()-1:
			currentTrack = 0
	if isRecording:
		get_parent().get_node("HUD/TotalScore").set_text("RECORDING TRACK ("+str(currentTrack)+") : " + str(elapsedTime).pad_decimals(10))
	#	recordData(delta)
	if isPlaying && !isPausePlay:
		playData(delta)
	if isPlayingAll && !isPausePlay:
		playAllData(delta)
	if !isRecording && !isPlaying && !isPausePlay:
		get_parent().get_node("HUD/TotalScore").set_text("STOPPED TRACK ("+str(currentTrack)+"): "+ str(elapsedTime).pad_decimals(10))
	if  isPausePlay:
		get_parent().get_node("HUD/TotalScore").set_text("PAUSED : " + str(elapsedTime).pad_decimals(10))
	
func loadTrack():
	var save_game = File.new()
	var saveFile = get_parent().get_node("HUD/saveFile").text
	if not save_game.file_exists("user://"+saveFile+".json"):
		get_parent().alerts("SAVE ("+saveFile+") NOT FOUND")
		return # Error! We don't have a save to load.
	save_game.open("user://"+saveFile+".json", File.READ)
	while not save_game.eof_reached():
		var jsonLine = save_game.get_line()
		#print("JSONLINE " + str(jsonLine))
		var current_line = parse_json(jsonLine)
		if jsonLine:
			recordedTracks = current_line["recordedTracks"]
			get_parent().alerts("Tracks Loaded")
			break
	save_game.close()	

func playData(delta):
	var isSpecial5 = false
	var isSpecial2 = false
	var isSpecial1 = false
	var isSpecial0 = false
	var isSpecialSpace = false
	#AudioStreamPlayer.stop()
	
	if playingTracks[currentTrack].size()>0:
		#elapsedTime += delta
		get_parent().get_node("HUD/TotalScore").set_text("PLAYING TRACK ("+str(currentTrack)+") : " + str(elapsedTime).pad_decimals(10))
		var data =   playingTracks[currentTrack][0]
		if elapsedTime > data[0]:
			#if lastPlayedData:
			#	for __ in range(lastPlayedData.size()-2):
			#		Input.action_release(lastPlayedData[__+1])
			for __ in range(data.size()-1):
				var action = data[__+1]
				Input.action_press(action,1.0)
				if action == "player_special_0":
					isSpecial0 = true
				if action == "player_special_1":
					isSpecial1 = true
				if action == "player_special_2":
					isSpecial2 = true
				if action == "player_special_5":
					isSpecial5 = true
				if action == "player_primary_gun":
					isSpecialSpace = true
			lastPlayedData =  playingTracks[currentTrack].pop_front()
			#&& Input.get_action_strength("player_special_0")>0.5
		if isSpecial0 == false:
			Input.action_release("player_special_0")
		if isSpecial1 == false:
			Input.action_release("player_special_1")
		if isSpecial2 == false:
			Input.action_release("player_special_2")
		if isSpecial5 == false:
			Input.action_release("player_special_5")
		if isSpecialSpace == false:
			Input.action_release("player_primary_gun")
	else:
		isPlaying=false
		if isSpecial0 == false:
			Input.action_release("player_special_0")
		if isSpecial1 == false:
			Input.action_release("player_special_1")
		if isSpecial2 == false:
			Input.action_release("player_special_2")
		if isSpecial5 == false:
			Input.action_release("player_special_5")
		if isSpecialSpace == false:
			Input.action_release("player_primary_gun")
			
		#get_node("HUD/TotalScore").set_text("ENDED : " + str(elapsedTime).pad_decimals(10))
		
func playAllData(delta):
	var isSpecial5 = false
	var isSpecial2 = false
	var isSpecial1 = false
	var isSpecial0 = false
	var isSpecialSpace = false
	var totalSizes = 0
	get_parent().get_node("HUD/TotalScore").set_text("PLAYING ALL TRACKS : " + str(elapsedTime).pad_decimals(10))
	for t in range(playingTracks.size()):
		if playingTracks[t].size()>0:
			totalSizes += playingTracks[t].size()
			var data =   playingTracks[t][0]
			if elapsedTime > data[0]:
				for __ in range(data.size()-1):
					var action = data[__+1]
					Input.action_press(action)
					if action == "player_special_0":
						isSpecial0 = true
					if action == "player_special_1":
						isSpecial1 = true
					if action == "player_special_2":
						isSpecial2 = true
					if action == "player_special_5":
						isSpecial5 = true
					if action == "player_primary_gun":
						isSpecialSpace = true
				playingTracks[t].pop_front()
				#&& Input.get_action_strength("player_special_0")>0.5
	if totalSizes == 0:
		isPlayingAll=false
	if isSpecial0 == false:
		Input.action_release("player_special_0")
	if isSpecial1 == false:
		Input.action_release("player_special_1")
	if isSpecial2 == false:
		Input.action_release("player_special_2")
	if isSpecial5 == false:
		Input.action_release("player_special_5")
	if isSpecialSpace == false:
		Input.action_release("player_primary_gun")
			#get_node("HUD/TotalScore").set_text("ENDED : " + str(elapsedTime).pad_decimals(10))
			
func recordDatax(delta):
	#AudioStreamPlayer.stop()
	
	#elapsedTime += delta
	get_parent().get_node("HUD/TotalScore").set_text("RECORDING TRACK ("+str(currentTrack)+") : " + str(elapsedTime).pad_decimals(10))
	
	var currentFrame = []
	var isRecordedData = false
	currentFrame.append(elapsedTime)
	if Input.is_action_pressed("player_special_0"):
		currentFrame.append("player_special_0")
		isRecordedData = true
	if Input.is_action_pressed("player_special_1"):
		currentFrame.append("player_special_1")
		isRecordedData = true
	if Input.is_action_pressed("player_special_2"):
		currentFrame.append("player_special_2")
		isRecordedData = true
	if Input.is_action_just_pressed("player_special_3"):
		currentFrame.append("player_special_3")
		isRecordedData = true
	if Input.is_action_just_pressed("player_special_4"):
		currentFrame.append("player_special_4")
		isRecordedData = true
	if Input.is_action_pressed("player_special_5"):
		currentFrame.append("player_special_5")
		isRecordedData = true
	if Input.is_action_just_pressed("player_special_6"):
		currentFrame.append("player_special_6")
		isRecordedData = true
	if Input.is_action_just_pressed("player_special_7"):
		currentFrame.append("player_special_7")
		isRecordedData = true
	if Input.is_action_just_pressed("player_special_8"):
		currentFrame.append("player_special_8")
		isRecordedData = true
	if Input.is_action_just_pressed("player_special_9"):
		currentFrame.append("player_special_9")
		isRecordedData = true
	if Input.is_action_pressed("player_primary_gun"):
		currentFrame.append("player_primary_gun")
		isRecordedData = true
	if isRecordedData:
		recordedTracks[currentTrack].append(currentFrame)

func _input(event):
	if !isRecording:
		return
	var bypassedEvent = ["playing","player_restart_game","player_decrease_glow","player_increase_glow","player_toggle_glow","move_left","move_right","move_up","move_down","touch_toggle","help_screen","record_track","play_track","pause_track","next_track","play_all"]
	var currentFrame = []
	var isRecordedData = false
	
	for acc in bypassedEvent:
		if(event.is_action_pressed(acc)):
			return
				
	for action in InputMap.get_actions():
		if(event.is_action_pressed(action)):
			print("Recorded: " + action)
			isRecordedData = true
			currentFrame.append(elapsedTime)
			currentFrame.append(action)
			#break
	if isRecordedData:
		recordedTracks[currentTrack].append(currentFrame)
		print(currentFrame)
	pass
func saveTrack():
	var saveDict = {
		"recordedTracks":recordedTracks
	}
	var saveFile = get_parent().get_node("HUD/saveFile").text
	var save_game = File.new()
	save_game.open("user://"+saveFile+".json", File.WRITE)
	save_game.store_line(to_json(saveDict))
	save_game.close()
	get_parent().alerts("Tracks Saved")
	#print('Tracks Saved' + str(to_json(saveDict)))
		
func _on_loadSong_file_selected(path):
	
	AudioStreamPlayer.stop()
	#var path = filepath # "Z:\\godot_projects\\%s.ogg" % file
	var ogg_file = File.new()
	ogg_file.open(path, File.READ)
	var bytes = ogg_file.get_buffer(ogg_file.get_len())
	var stream = AudioStreamOGGVorbis.new()
	stream.data = bytes
	AudioStreamPlayer.stream = stream
	#$AudioStreamPlayer.stream = stream
	AudioStreamPlayer.play()
	print("playing")
	ogg_file.close()

func _on_AudioStreamPlayer_finished():
	isRecording = false
	isPlaying = false
	isPlayingAll = false
	elapsedTime = 0.0
	AudioStreamPlayer.play()