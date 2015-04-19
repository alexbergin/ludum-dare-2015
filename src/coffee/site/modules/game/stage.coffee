define [

	# game modules
	"site/modules/game/camera"
	"site/modules/game/input"
	"site/modules/game/light"
	"site/modules/game/collision"
	"site/modules/game/extends/landscape"
	"site/modules/game/extends/player"
	"site/modules/game/extends/wall"
	"site/modules/game/extends/fan"

] , (

	# game modules
	Camera
	Input
	Light
	Collision
	Landscape
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
			"camera"
			"collision"
			"landscape"
			"player"
			"input"
			"wall"
			"fan"
		]

		# what modules to call .loop() on
		loopTasks: [
			"fan"
			"player"
			"collision"
			"camera"
		]

		# scale the canvas based on touch ability i guess
		isTouch: false

		# game modules
		camera: new Camera
		collision: new Collision
		light: new Light
		landscape: new Landscape
		input: new Input
		fan: new Fan
		player: new Player
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

			# scene preferences
			@.scene.fog = new THREE.Fog 0xCDE6F2 , 1200 , 7500

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
			document.body.classList.add "is-touch"
			@.renderer.shadowMapEnabled = false
			@.camera.alpha.far = 5000
			@.light.spot.castShadow = false
			@.isTouch = true
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


