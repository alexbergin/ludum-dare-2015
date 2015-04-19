define ->

	class Wall

		colors: [
			0xF2F5F7
			0xEAEEEF
			0xEDF0F2
			0xE8EBED
		]

		sections: []

		init: ->

			surfaces = [
				vertical: "x"
				direction: 1
				position:
					x: 150 , y: 300 , z: 150
			,
				vertical: "x"
				direction: -1
				position:
					x: -150 , y: 300 , z: -150
			,
				vertical: "y"
				direction: 1
				position:
					x: 0 , y: 450 , z: 0
			,
				vertical: "y"
				direction: -1
				position:
					x: 0 , y: 150 , z: 0
			,
				vertical: "z"
				direction: 1
				position:
					x: 150 , y: 300 , z: 150
			,
				vertical: "z"
				direction: -1
				position:
					x: -150 , y: 300 , z: -150
			]

			for surface in surfaces
				wall =
					vertical: surface.vertical
					direction: surface.direction
					position: surface.position
					height: 300
					width: 300

				@.build wall

		build: ( props ) ->

			# make the wall
			geometry = new THREE.PlaneBufferGeometry( props.width , props.height , 10 , 10 )
			material = new THREE.MeshBasicMaterial
				color: @.colors[ Math.floor( Math.random() * @.colors.length )]

			# make the mesh
			section = new THREE.Mesh geometry , material
			@.sections.push section

			# add it to the scene
			site.stage.scene.add section

			# position the mesh
			verticies = [ "x" , "y" , "z" ]
			for vertex in verticies
				section.position[ vertex ] = props.position[ vertex ]

			# rotate the mesh
			# i'm sorry again
			switch props.vertical

				when "x"
					if props.direction < 0
						section.rotation.y = Math.radians( 180 )

				when "y"
					if props.direction < 0
						section.rotation.x = Math.radians( 90 )
					else
						section.rotation.x = Math.radians( -90 )

				when "z"
					if props.direction < 0
						section.rotation.y = Math.radians( 90 )
					else
						section.rotation.y = Math.radians( -90 )

			# apply shadows
			section.castShadow = true
			section.receiveShadow = true


