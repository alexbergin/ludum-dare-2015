define [

	"site/modules/game/extends/obj"

] , (

	Obj

) ->

	class Player extends Obj

		# what distance + angle to hold the camera at
		distance: 250
		angle: 0

		# what velocity values get multiplied
		# by on each loop
		friction: 0.98

		# added to the y axis each loop
		gravity: 0.1

		# values that get added per loop
		velocity:
			x: 0
			y: 0
			z: 0

		# rotational velocity
		rotation:
			x: 0
			y: 0
			z: 0

		init: ->

			# make the balloon and add to scene
			@.build(
				src: "models/json/balloon.js",
				color: 0x9BE7FF
				scale:
					x: 30 , y: 30 , z: 30

				position: 
					x: 0 , y: 0 , z: 0

				callback: @.ready
			)

		ready: ( mesh ) =>

			# store the three js object to balloon
			@.balloon = mesh

		loop: =>

			# make sure our mesh is made
			if @.balloon isnt undefined

				# apply friction + gravity
				@.updateVelocity()

				# move the mesh
				@.updatePosition()

				# see what we're colliding with
				@.detectCollision()

				# move the camera to its new position
				@.updateCamera()

		updateVelocity: ->

			# properties of velocity
			vertices = [ "x" , "y" , "z" ]

			# apply friction
			for vertex in vertices

				# make sure we don't kill memory
				if Math.abs( @.velocity[ vertex ] ) > 0.01
					@.velocity[ vertex ] *= @.friction

				else
					@.velocity[ vertex ] = 0

			# apply gravity
			@.velocity.y += @.gravity

		updatePosition: ->

			# properties of velocity + mesh
			vertices = [ "x" , "y" , "z" ]

			# update position + rotate
			for vertex in vertices
				@.balloon.position[ vertex ] += @.velocity[ vertex ]


		detectCollision: ->

		updateCamera: ->

			# store the camera & light
			camera = site.stage.camera.alpha
			light = site.stage.light.spot

			# get the position of the balloon
			x = @.balloon.position.x
			y = @.balloon.position.y
			z = @.balloon.position.z

			# update light position
			light.position.set( x , y + 1000 , z )
			light.target = @.balloon

			# position the camera
			camera.position.x = x + ( Math.sin( Math.radians( @.angle )) * @.distance )
			camera.position.z = z + ( Math.cos( Math.radians( @.angle )) * @.distance )
			camera.position.y = y + ( @.distance * 0.5 )

			# look at the balloon
			camera.lookAt x: x , y: y , z: z
			light.lookAt x: x , y: y , z: z