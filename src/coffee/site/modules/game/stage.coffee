define [

	# game modules
	"site/modules/game/camera"
	"site/modules/game/input"
	"site/modules/game/light"
	"site/modules/game/collision"
	"site/modules/game/level"
	"site/modules/game/extends/landscape"
	"site/modules/game/extends/spikes"
	"site/modules/game/extends/line"
	"site/modules/game/extends/player"
	"site/modules/game/extends/wall"
	"site/modules/game/extends/fan"

] , (

	# game modules
	Camera
	Input
	Light
	Collision
	Level
	Landscape
	Spikes
	Line
	Player
	Wall
	Fan

) ->

	class Stage

		# controls what gets done in the render task
		loop: false

		# what modules to call .init() on
		setupTasks: [
			"light"
			"landscape"
			"camera"
			"collision"
			"player"
			"line"
			"spikes"
			"input"
			"fan"
		]

		# what modules to call .loop() on
		loopTasks: [
			"fan"
			"player"
			"landscape"
			"line"
			"collision"
			"camera"
			"wall"
			"level"
		]

		# scale the canvas based on touch ability i guess
		isTouch: false

		# game modules
		camera: new Camera
		collision: new Collision
		fan: new Fan
		input: new Input
		landscape: new Landscape
		level: new Level
		light: new Light
		line: new Line
		player: new Player
		spikes: new Spikes
		wall: new Wall

		init: ->

			# setup
			@.getElements()
			@.addListeners()
			@.build()
			@.onResize()
			@.render()

		getElements: ->

			# save the page element for later
			@.page = document.getElementById "stage"

		addListeners: ->

			# resize the renderer to always match the window
			window.addEventListener "resize" , @.onResize
			window.addEventListener "touchstart" , @.onTouchStart

		build: ->

			# create the THREE elements
			@.scene = new THREE.Scene()
			@.renderer = new THREE.WebGLRenderer

			# get the landscape scale
			width = @.level.width * @.level.gridSize
			height = @.level.height * @.level.gridSize
			scale = ( width + height ) / 2
			mult = ( scale / 600  )

			# scene preferences
			@.scene.fog = new THREE.Fog 0xCDE6F2 , 750 *  mult , 1750 * mult

			# set renderer preferences
			@.renderer.setClearColor 0xCDE6F2
			@.renderer.shadowMapEnabled = true
			@.renderer.shadowMapType = THREE.PCFSoftShadowMap

			# append to the page
			@.page.appendChild @.renderer.domElement

			# setup sub modules
			for task in @.setupTasks
				@[task].init?()

		onResize: =>

			# set canvas scale
			if @.isTouch is true then mult = 2 else mult = 1

			# get the width + height
			@.height = window.innerHeight * mult
			@.width = window.innerWidth * mult

			# resize the renderer
			@.renderer.setSize @.width , @.height

		onTouchStart: =>

			# apply styles specific for touch devices
			document.body.classList.add "is-touch"

			# no shadows
			@.renderer.shadowMapEnabled = false
			@.light.spot.castShadow = false

			# make the camera distance lower
			@.camera.alpha.far = 5000

			# save the state for later
			@.isTouch = true

			# apply a resize
			@.onResize()

		render: =>

			# call this to check loop again
			requestAnimationFrame @.render

			# test to see if loop should be performed
			if @.loop

				# run the loop function on each task
				for task in @.loopTasks
					site.stage[ task ].loop?()

			# render the scene to the canvas
			@.renderer.render @.scene , @.camera.alpha


