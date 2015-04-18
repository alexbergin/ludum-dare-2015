define [

	# game modules
	"site/modules/game/camera"
	"site/modules/game/extends/fan"

] , (

	# game modules
	Camera
	Fan

) ->

	class Stage

		# controls what gets done in the render task
		loop: false

		# what modules to call .init() on
		setupTasks: [
			"camera"
			"fan"
		]

		# what modules to call .loop() on
		loopTasks: [
			"fan"
		]

		# scale the canvas based on touch ability i guess
		isTouch: false

		# game modules
		camera: new Camera
		fan: new Fan

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
			@.renderer.setClearColor 0xF9FDFF

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


