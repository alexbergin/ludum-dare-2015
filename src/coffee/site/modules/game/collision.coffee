define ->

	class Collision

		# multiply initial velocity by this
		rebound: 1.1

		# objects we're testing
		objects: []

		init: ->

			# store the player
			@.player = site.stage.player

		add: ( object ) =>

			# add to the obejcts array
			@.objects.push object

		loop: =>

			# do the landscape collision
			@.landscape()

			# test all objects
			for object in @.objects
				@.test object

		test: ( object ) ->

			# balloon dimensions
			w = d = 50
			h = 90

			# balloon position
			x = @.player.balloon.position.x
			y = @.player.balloon.position.y + 45
			z = @.player.balloon.position.z

			# points that define the box
			x1 = object.collision.x1
			x2 = object.collision.x2
			y1 = object.collision.y1
			y2 = object.collision.y2
			z1 = object.collision.z1
			z2 = object.collision.z2

			# vertex collision states
			xCollide = false
			yCollide = false
			zCollide = false

			# check for collisions, RIP
			if ( x + w / 2 ) > x1 and ( x - w / 2 ) < x2 or ( x + w / 2 ) > x2 and ( x - w / 2 ) < x1 then xCollide = true
			if ( y + h / 2 ) > y1 and ( y - h / 2 ) < y2 or ( y + h / 2 ) > y2 and ( y - h / 2 ) < y1 then yCollide = true
			if ( z + d / 2 ) > z1 and ( z - d / 2 ) < z2 or ( z + d / 2 ) > z2 and ( z - d / 2 ) < z1 then zCollide = true

			# do the right thing if colliding
			if xCollide is true and yCollide is true and zCollide is true then object.collision.onCollision?( object )
		
		landscape: ->

			# walls
			width = site.stage.landscape.width
			height = site.stage.landscape.height

			if @.player.balloon.position.x <= -width / 2 
				@.collide "x" , 1

			if @.player.balloon.position.x >= width / 2 
				@.collide "x" , -1

			if @.player.balloon.position.z <= -height / 2 
				@.collide "z" , 1

			if @.player.balloon.position.z >= height / 2 
				@.collide "z" , -1



		collide: ( axis , direction ) ->
			@.player.velocity[ axis ] = direction * Math.abs( @.player.velocity[ axis ]) * @.rebound
			@.player.balloon.position[ axis ] += @.player.velocity[ axis ]