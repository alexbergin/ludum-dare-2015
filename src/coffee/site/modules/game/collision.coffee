define ->

	class Collision

		# multiply initial velocity by this
		rebound: 0.75

		# objects we're testing
		objects: []

		init: ->

			# store the player
			@.player = site.stage.player

		loop: =>

			@.landscape()

			for object in @.objects
				@.test object

		test: ( object ) ->

			vertext = object.collision.vertext
			direction = object.collision.direction
			offset = object.collision.direction
			width = object.scale.x
			height = object.scale.y
			depth = object.scale.z

		landscape: ->

			if @.player.balloon.position.y <= 0
				@.collide "y" , 1

		collide: ( axis , direction ) ->
			@.player.velocity[ axis ] = direction * Math.abs( @.player.velocity[ axis ]) * @.rebound