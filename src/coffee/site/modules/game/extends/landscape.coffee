define ->

	# make some ground until i can build
	# some levels or something
	class Landscape

		width: 2000
		height: 2000

		walls: []

		init: ->

			pos = [
					x: -@.width / 2,
					s: @.height
					z: 0
					r: Math.radians( 90 )
				,
					x: @.width / 2
					s: @.height
					z: 0
					r: Math.radians( 270 )
				,
					x: 0
					s: @.width
					z: -@.height / 2
					r: Math.radians( 0 )
				,
					x: 0
					s: @.width
					z: @.height / 2
					r: Math.radians( 180 )
			]

			# temp wall

			max = Math.max( @.width , @.height )

			for placement in pos

				# define material
				geometry = new THREE.PlaneBufferGeometry(  placement.s , max * 5 , 1 , 1 )
				material = new THREE.MeshBasicMaterial
					color: 0xF9FDFF

				# make a new mesh
				landscape = new THREE.Mesh geometry , material

				# position
				landscape.position.x = placement.x
				landscape.position.z = placement.z
				landscape.rotation.y = placement.r

				# add to array to update
				@.walls.push landscape

				# add to the stage
				site.stage.scene.add landscape

		loop: =>

			# place all the walls at the same y height,
			# instant infinite tunnel
			y = site.stage.player.balloon.position.y
			for wall in @.walls
				wall.position.y = y
