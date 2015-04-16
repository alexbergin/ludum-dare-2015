define [

	# game modules
	"site/modules/game/camera"

] , (

	# game modules
	Camera

) ->

	class Stage

		# controls what gets done in the render task
		loop: false

		# what modules to call .init() on
		setupTasks: [
			"camera"
		]

		# what modules to call .loop() on
		loopTasks: []

		# game modules
		camera: new Camera

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

		build: ->

			# create the THREE elements
			@.scene = new THREE.Scene()
			@.renderer = new THREE.WebGLRenderer()

			# append to the page
			@.page.appendChild @.renderer.domElement

			# setup sub modules
			for task in @.setupTasks
				@[task].init?()

		onResize: =>

			# get the width + height
			@.height = window.innerHeight
			@.width = window.innerWidth

			# resize the renderer
			@.renderer.setSize @.width , @.height

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


