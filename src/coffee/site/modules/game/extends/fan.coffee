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
				color: 0xF9FDFF
				scale:
					x: 100 , y: 100 , z: 100
				position:
					x: 0 , y: -120 , z: 0
				callback: ( mesh ) =>
					@.ready( mesh , "base" )
			)

			@.build(
				src: "models/json/fan/blades.js",
				color: 0xFF6666
				scale:
					x: 100 , y: 100 , z: 100
				position:
					x: 0 , y: 0 , z: 0
				callback: ( mesh ) =>
					@.ready( mesh , "blades" )
			)

			# temp wall
			geometry = new THREE.PlaneBufferGeometry( 500 , 500 , 500 , 500 )
			material = new THREE.MeshBasicMaterial
				color: 0xE6F3F7
			@.landscape = new THREE.Mesh geometry , material
			site.stage.scene.add @.landscape
			@.landscape.rotation.x = -90 * ( Math.PI / 180 )
			@.landscape.position.y = -90

		ready: ( mesh , name ) =>
			@[name] = mesh

		loop: =>
			@.blades?.rotation.y += 0.08
			@.angle -= 0.5

			site.stage.camera.alpha.position.x = Math.sin( @.angle * ( Math.PI / 180 )) * 380
			site.stage.camera.alpha.position.z = Math.cos( @.angle * ( Math.PI / 180 )) * 380
			site.stage.camera.alpha.lookAt( x:0 , y:0 , z: 0 )


