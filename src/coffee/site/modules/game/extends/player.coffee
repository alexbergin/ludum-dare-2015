define [

	"site/modules/game/extends/obj"

] , (

	Obj

) ->

	class Player extends Obj

		# what velocity values get multiplied
		# by on each loop
		friction: 0.98

		# added to the y axis each loop
		gravity: 0.15

		# makes things appear a little windy
		simAngle: 0
		simMult: 0.01

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
					x: 0 , y: 300 , z: 0

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

				# update the mesh
				@.updateMesh()

		updateVelocity: ->

			# properties of velocity
			vertices = [ "x" , "y" , "z" ]

			# make up simulated wind force
			@.simAngle += 0.1
			force = @.velocity.y * @.simMult

			# add that to the x & z
			@.velocity.x += Math.sin( @.simAngle ) * force
			@.velocity.z += Math.cos( @.simAngle ) * force

			# apply friction
			for vertex in vertices

				# make sure we don't kill memory
				if Math.abs( @.velocity[ vertex ] ) > 0.01
					@.velocity[ vertex ] *= @.friction

				else
					@.velocity[ vertex ] = 0

			# apply gravity
			if site.stage.player.isDead is false
				@.velocity.y += @.gravity

			else
				@.velocity.y -= @.gravity * 10
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