define ->

	class Camera

		hAngle: 0
		vAngle: 45
		distance: 2000
		anchor:
			x: 0
			y: 0
			z: 0

		facing:
			x: 0
			y: 0
			z: 0

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

		addListeners: ->

			# listen for a resize to update the camera
			window.addEventListener "resize" , @.onResize

		onResize: =>

			# update the apsect ratio and camera
			@.alpha.aspect = window.innerWidth / window.innerHeight
			@.alpha.updateProjectionMatrix()

		loop: =>

			@.getTargetPosition()
			@.updatePosition()

		getTargetPosition: ->

			# position the camera relative to the anchor
			# based on the angle + distance
			x = @.anchor.x + Math.sin( Math.radians( @.hAngle )) * @.distance
			y = @.anchor.y + Math.sin( Math.radians( @.vAngle )) * @.distance
			z = @.anchor.z + Math.cos( Math.radians( @.hAngle )) * @.distance
			@.position =
				x: x , y: y , z: z

		updatePosition: ->

			# vertices the camera can move on
			vertices = [ "x" , "y" , "z" ]

			for vertex in vertices

				# handle positioning the camera
				@.alpha.position[ vertex ] = @.ease( @.alpha.position[ vertex ] , @.position[ vertex ] , 0.1 )

				# handle where the camera is pointing
				@.facing[ vertex ] = @.ease( @.facing[ vertex ] , @.anchor[ vertex ] , 0.2 )

			# make the camera look at its target
			@.alpha.lookAt x: @.facing.x , y: @.facing.y , z: @.facing.z

			# position the light
			light = site.stage.light.spot
			light.position.set( @.alpha.position.x , @.alpha.position.y + 1000 , @.alpha.position.z )
			light.lookAt @.alpha.position

		ease: ( prop , target , rate ) ->

			# get the difference
			diff = prop - target

			# ease to its new position 
			if Math.abs( diff ) > rate / 10000
				prop -= diff * rate

			# don't kill the memory
			else
				prop = target

			return prop
