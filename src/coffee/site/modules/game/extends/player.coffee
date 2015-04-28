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

		# death state, duh
		isDead: false

		init: ->

			@.born = new Date().getTime() / 1000

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

				# move the camera to its new position
				@.updateCamera()

				# update the mesh
				@.updateMesh()

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
			if site.stage.player.isDead is false
				@.velocity.y += 0.1

			else
				@.velocity.y -= 1.5
				if @.velocity.y > 0 then @.velocity.y = 0
				if @.balloon.position.y < 2
					@.velocity.y = 0
					@.balloon.position.y = 1

		updatePosition: ->

			# properties of velocity + mesh
			vertices = [ "x" , "y" , "z" ]

			# update position + rotate
			for vertex in vertices
				@.balloon.position[ vertex ] += @.velocity[ vertex ]

		updateCamera: ->

			# store the camera & light
			camera = site.stage.camera
			light = site.stage.light.spot

			# get the position of the balloon
			x = @.balloon.position.x
			y = @.balloon.position.y
			z = @.balloon.position.z

			# update light position
			light.position.set( x , y + 1000 , z )
			light.target = @.balloon

			# get camera bounds
			width = site.stage.landscape.width
			height = site.stage.landscape.height

			maxX = ( width / 2 ) - 10
			minX = -maxX

			maxZ = ( height / 2 ) - 10
			minZ = -maxZ

			# position the camera
			camera.position.x = Math.min( Math.max( x + ( Math.sin( Math.radians( @.angle )) * @.distance ) , minX ) , maxX )
			camera.position.z = Math.min( Math.max( z + ( Math.cos( Math.radians( @.angle )) * @.distance ) , minZ ) , maxZ )
			camera.position.y = y - ( Math.min( Math.max( @.velocity.y * 60 , -@.distance / 2 ) , @.distance / 2 ))

			# look at the balloon
			camera.alpha.lookAt x: x , y: y , z: z
			light.lookAt x: x , y: y , z: z

		die: =>
			@.isDead = true

			seconds = new Date().getTime() / 1000
			seconds = seconds - @.born
			seconds = Math.round seconds

			document.getElementsByClassName("score")[0].innerHTML = "
				<h2>you lived for</h2>
				<h1>#{seconds}</h1>
				<h2>seconds</h2>
			"
			document.getElementsByClassName("score")[0].classList.add "visible"
			clearTimeout @.deathTimer
			@.deathTimer = setTimeout =>

				@.isDead = false
				@.born = new Date().getTime() / 1000
				document.getElementsByClassName("score")[0].classList.remove "visible"
				@.balloon.position.x = 800
				@.balloon.position.y = 600
				@.balloon.position.z = 800

			, 3000


		updateMesh: ->

			vertices = [ "x" , "y" , "z" ]

			# scale the balloon in case of death
			if @.isDead

				for vertex in vertices
					@.balloon.scale[ vertex ] = 0

			else

				for vertex in vertices
					@.balloon.scale[ vertex ] = 30