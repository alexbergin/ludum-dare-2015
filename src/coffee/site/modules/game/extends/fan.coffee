define [

	"site/modules/game/extends/obj"

] , (

	Obj

) ->

	class Fan extends Obj

		blades: []
		base: []

		init: ->

		
			@.make
				direction: -1
				vertical: "y"

				position:
					x: 0 , y: 890 , z: 0

				rotation:
					x: 0 , y: 0 , z: 0

		make: ( props ) =>

			# this whole function is trash
			self = @

			pos = props.position
			rot = props.rotation

			# collision box vars
			x1 = pos.x
			x2 = pos.x
			y1 = pos.y
			y2 = pos.y
			z1 = pos.z
			z2 = pos.z

			# i'm so sorry
			# this sets the container for the collision box
			# based on the vertical axis and direction
			switch props.vertical

				when "x"
					y1 -= 90
					y2 += 90
					z1 -= 90
					z2 += 90

					if props.direction > 0
						x2 += 600
					else
						x2 -= 600

				when "y"
					x1 -= 90
					x2 += 90
					z1 -= 90
					z2 += 90

					if props.direction > 0
						y2 += 600
					else
						y2 -= 600

				when "z"
					x1 -= 90
					x2 += 90
					y1 -= 90
					y2 += 90

					if props.direction > 0
						z2 += 600
					else
						z2 -= 600

			# define the base of the fan
			base =
				src: "models/json/fan/base.js",
				color: 0xE6F3F7
				vertical: props.vertical
				direction: props.direction
				scale:
					x: 60 , y: 60 , z: 60
				position:
					x: pos.x , y: pos.y , z: pos.z
				rotation:
					x: 0 , y: 0 , z: 0
				callback: ( mesh ) =>
					@.ready( mesh , "base" )

			# store the colllison area
			collision =
				onCollision: self.onCollisionBlades
				x1: x1
				x2: x2
				y1: y1
				y2: y2
				z1: z1
				z2: z2

			# define the blades of the fan
			blades =
				src: "models/json/fan/blades.js",
				color: 0xD65555
				vertical: props.vertical
				direction: props.direction
				scale:
					x: 60 , y: 60 , z: 60
				position:
					x: pos.x , y: pos.y , z: pos.z
				rotation:
					x: 0 , y: 0 , z: 0
				collision: collision
				callback: ( mesh ) =>
					@.ready( mesh , "blades" )

			# position and rotate based on vertical axis
			blades.position[ props.vertical ] += 75 * props.direction

			if props.vertical is "x"
				blades.rotation.z += Math.radians( 90 * props.direction )
				base.rotation.z -= Math.radians( 90 * props.direction )

			if props.vertical is "y"
				if props.direction > 0
					base.rotation.x = Math.radians( 0 )
				else
					base.rotation.x = Math.radians( 180 )

			if props.vertical is "z"
				blades.rotation.x -= Math.radians( 90 * props.direction )
				base.rotation.x += Math.radians( 90 * props.direction )

			@.build blades
			@.build base

		ready: ( mesh , name ) =>
			@[name].push mesh


		loop: =>
			i = 0
			while i < @.blades.length
				blade = @.blades[ i ]
				base = @.base[ i ]
				axis = "y"
				if blade.vertical is "x" then axis = "x"
				if blade.vertical is "z" then axis = "y"
				blade.rotation[ axis ] += 0.08 * blade.direction
				i++

		onCollisionBlades: ( object ) ->
			
			# get the player
			player = site.stage.player

			# get the vertical axis + direction
			vertical = object.vertical
			direction = object.direction

			# get their x + y + z diffs
			diffX = object.position.x - player.balloon.position.x
			diffY = object.position.y - player.balloon.position.y
			diffZ = object.position.z - player.balloon.position.z

			if vertical is "x" then diffVert = diffX
			if vertical is "y" then diffVert = diffY
			if vertical is "z" then diffVert = diffZ

			# get the strength we apply everything with
			strength = 1 - ( Math.max( Math.min( diffVert / 512 , 1 ) , 0 ))

			if Math.abs( diffVert ) < 90 and site.stage.player.isDead is false then site.stage.player.die()
			
			# apply lateral movement
			# if site.stage.player.isDead is false
			# 	if vertical isnt "x" then player.velocity.x += ( diffX * 0.015 + (( Math.random() - 0.5 ) * 0.1 )) * strength
			# 	if vertical isnt "y" then player.velocity.y += ( diffY * 0.015 + (( Math.random() - 0.5 ) * 0.1 )) * strength
			# 	if vertical isnt "z" then player.velocity.z += ( diffZ * 0.015 + (( Math.random() - 0.5 ) * 0.1 )) * strength

			# # not as much bouncing, please
			# if vertical isnt "x" then player.velocity.x *= 1 - ( strength / 9 )
			# if vertical isnt "y" then player.velocity.y *= 1 - ( strength / 9 )
			# if vertical isnt "z" then player.velocity.z *= 1 - ( strength / 9 )

			# apply vertical movement
			if site.stage.player.isDead is false
				if vertical is "x" then player.velocity.x += direction * 1.0 * strength
				if vertical is "y" then player.velocity.y += direction * 1.0 * strength
				if vertical is "z" then player.velocity.z += direction * 1.0 * strength