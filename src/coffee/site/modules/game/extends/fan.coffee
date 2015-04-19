define [

	"site/modules/game/extends/obj"

] , (

	Obj

) ->

	class Fan extends Obj

		angle: 0

		init: ->

			@.build(
				src: "models/json/fan/base.js",
				color: 0xE6F3F7
				scale:
					x: 100 , y: 100 , z: 100
				position:
					x: 0 , y: -120 , z: 0
				callback: ( mesh ) =>
					@.ready( mesh , "base" )
			)

			@.build(
				src: "models/json/fan/blades.js",
				color: 0xD65555
				scale:
					x: 100 , y: 100 , z: 100
				position:
					x: 0 , y: 0 , z: 0
				callback: ( mesh ) =>
					@.ready( mesh , "blades" )
			)

		ready: ( mesh , name ) =>
			@[name] = mesh

		loop: =>
			@.blades?.rotation.y -= 0.15


