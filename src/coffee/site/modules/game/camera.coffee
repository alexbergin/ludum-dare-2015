define ->

	class Camera

		position:
			x: 0
			y: 0
			z: 0

		init: ->

			@.build()
			@.addListeners()

		build: ->

			# store the camera in the alpha property
			@.alpha = new THREE.PerspectiveCamera 66 , window.innerWidth / window.innerHeight , 1 , 15000

			# position it
			@.alpha.position.x = @.alpha.position.y = @.alpha.position.z = 250
			@.alpha.lookAt x: 0 , y: 0 , z: 0

		addListeners: ->

			# listen for a resize to update the camera
			window.addEventListener "resize" , @.onResize

		onResize: =>

			# update the apsect ratio and camera
			@.alpha.aspect = window.innerWidth / window.innerHeight
			@.alpha.updateProjectionMatrix()

		loop: =>

			# vertices the camera can move on
			vertices = [ "x" , "y" , "z" ]

			for vertex in vertices

				# find how far the camera is from its goal
				diff = @.alpha.position[ vertex ] - @.position[ vertex ]
				
				# ease to its new position
				if Math.abs( diff ) > 0.00001
					@.alpha.position[ vertex ] -= diff * 0.1

				# don't kill the memory
				else
					@.alpha.position[ vertex ] = @.position[ vertex ]