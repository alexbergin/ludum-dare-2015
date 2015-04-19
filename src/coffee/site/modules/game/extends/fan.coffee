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

			pos = props.position
			rot = props.rotation

			@.build(
				src: "models/json/fan/base.js",
				color: 0xE6F3F7
				scale:
					x: 60 , y: 60 , z: 60
				position:
					x: pos.x , y: pos.y , z: pos.z
				callback: ( mesh ) =>
					@.ready( mesh , "base" )
			)

			@.build(
				src: "models/json/fan/blades.js",
				color: 0xD65555
				scale:
					x: 60 , y: 60 , z: 60
				position:
					x: pos.x , y: pos.y + 75 , z: pos.z
				rotation:
					x: 0 , y: 360 * Math.random() , z: 0

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