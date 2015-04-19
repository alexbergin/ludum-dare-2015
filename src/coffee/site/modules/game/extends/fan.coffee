define [

	"site/modules/game/extends/obj"

] , (

	Obj

) ->

	class Fan extends Obj

		blades: []
		base: []

		init: ->

			x = -1500
			while x < 1500

				y = -1500
				while y < 1500

					@.make
						rotationAxis:
							x: -0.08

						position:
							x: x , y: 0 , z: y

						rotation:
							x: 0 , y: 90 , z: 0

					y += 600

				x += 600

		make: ( props ) =>

			self = @
			pos = props.position
			rot = props.rotation

			collision =
				onCollision: self.onCollisionBase
				x1: pos.x - 90
				x2: pos.x + 90
				y1: pos.y + pos.y
				y2: pos.y + pos.y + 90
				z1: pos.z - 90
				z2: pos.z + 90

			@.build(
				src: "models/json/fan/base.js",
				color: 0xE6F3F7
				scale:
					x: 60 , y: 60 , z: 60
				position:
					x: pos.x , y: pos.y , z: pos.z
				collision: collision
				callback: ( mesh ) =>
					@.ready( mesh , "base" )
			)

			collision =
				onCollision: self.onCollisionBlades
				x1: pos.x - 90
				x2: pos.x + 90
				y1: pos.y + 75
				y2: pos.y + 600
				z1: pos.z - 90
				z2: pos.z + 90

			@.build(
				src: "models/json/fan/blades.js",
				color: 0xD65555
				scale:
					x: 60 , y: 60 , z: 60
				position:
					x: pos.x , y: pos.y + 75 , z: pos.z
				rotation:
					x: 0 , y: 360 * Math.random() , z: 0
				collision: collision
				callback: ( mesh ) =>
					@.ready( mesh , "blades" )
			)

		ready: ( mesh , name ) =>
			@[name].push mesh


		loop: =>
			i = 0
			while i < @.blades.length
				blade = @.blades[ i ]
				base = @.base[ i ]
				blade.rotation.y += 0.08
				i++

		onCollisionBlades: ( object ) ->
			console.log "fan is pushing"

		onCollisionBase: ( object ) ->
			console.log "balloon is popping"