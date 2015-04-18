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

			# temp wall
			geometry = new THREE.PlaneBufferGeometry( 500000 , 500000 , 500 , 500 )
			material = new THREE.MeshBasicMaterial
				color: 0xF9FDFF
			@.landscape = new THREE.Mesh geometry , material
			site.stage.scene.add @.landscape
			@.landscape.rotation.x = -90 * ( Math.PI / 180 )
			@.landscape.position.y = -90

			# shadows
			@.landscape.castShadow = true
			@.landscape.receiveShadow = true

		ready: ( mesh , name ) =>
			@[name] = mesh

		loop: =>
			@.blades?.rotation.y -= 0.15


