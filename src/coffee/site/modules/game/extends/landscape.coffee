define ->

	# make some ground until i can build
	# some levels or something
	class Landscape

		walls: []

		init: ->

			# make it larger than fog
			@.width = 50000
			@.height = 50000

			# define material
			geometry = new THREE.PlaneBufferGeometry(  @.width , @.height , 1 , 1 )
			material = new THREE.MeshBasicMaterial
				color: 0xF9FDFF

			# make a new mesh
			landscape = new THREE.Mesh geometry , material

			# position
			landscape.position.x = 0
			landscape.position.y = 0
			landscape.position.z = 0
			landscape.rotation.x = Math.radians( -90 )

			# save to class
			@.ground = landscape

			# add to the stage
			site.stage.scene.add @.ground

		loop: =>

			# make the ground follow the camera
			x = site.stage.camera.alpha.position.x
			z = site.stage.camera.alpha.position.z
			@.ground.position.x = x
			@.ground.position.z = z
