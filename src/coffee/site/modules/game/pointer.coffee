define ->

	# gets the grid position of the cursor
	class Pointer

		# the cursor position on the screen
		screen:
			x: 0 , y: 0

		# the vector of the cursor
		position:
			x: 0 , y: 0 , z: 0

		init: ->

			# listen for pointer changes
			@.addListeners()

			# setup the raycaster
			@.buildElements()

		addListeners: ->

			# listen for a mouse move on desktop and a touch on mobile
			window.addEventListener "mousemove" , @.onMouseMove
			window.addEventListener "touchstart" , @.onTouchStart

		buildElements: ->

			# save the raycaster for later
			@.raycaster = new THREE.Raycaster()
			@.screen = new THREE.Vector2()

		onMouseMove: ( e ) =>

			# send the x + y to update
			@.update e.clientX , e.clientY

		onTouchStart: ( e ) =>

			# send the x + y to update
			@.update e.touches[0].clientX , e.touches[0].clientY

		update: ( x , y ) ->

			# get the camera we're casting from
			camera = site.stage.camera.alpha

			# store the cursor x + y
			@.screen.x = ( x / window.innerWidth ) * 2 - 1
			@.screen.y = -( y / window.innerHeight ) * 2 + 1

			# cast some rays and get the intersect
			@.raycaster.setFromCamera @.screen , camera

			# get the objects we're testing
			objects = site.stage.scene.children

			# get the collision point
			@.check objects

		check: ( objects ) ->

			# check all objects on screen
			intersects = @.raycaster.intersectObjects objects

			# only run if there is an intersect
			if intersects.length > 0

				# loop through the intersects until we hit the first mesh
				intersect = intersects[0]
				i = 0
				while intersect.object.type isnt "Mesh" and i < intersects.length
					intersect = intersects[i]
					i++

				# save the point if the intersection isnt null
				if intersect.object.type is "Mesh" then @.setPosition intersect

		setPosition: ( intersect ) ->

			# save the position
			@.position = intersect.point


