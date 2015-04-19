define ->

	# make some ground until i can build
	# some levels or something
	class Landscape

		init: ->

			# temp wall
			geometry = new THREE.PlaneBufferGeometry( 500000 , 500000 , 500 , 500 )
			material = new THREE.MeshBasicMaterial
				color: 0xF9FDFF
			@.landscape = new THREE.Mesh geometry , material
			site.stage.scene.add @.landscape
			@.landscape.rotation.x = -90 * ( Math.PI / 180 )
			@.landscape.position.y = 0

			# shadows
			@.landscape.castShadow = true
			@.landscape.receiveShadow = true