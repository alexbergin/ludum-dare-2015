define ->

	class Wall

		colors: [
			0xEDFAFF
			0xEAF8FC
			0xDEEBEF
			0xD5E1E5
			0xDAE6EA
		]

		sections: []

		init: ->

			width = 1800
			height = 900
			x = -width / 2
			while x < width / 2

				y = 150
				while y < 150 + height
					wall =
						vertical: "x"
						direction: 1
						position: 
							x: x + 150 , y: y , z: -width / 2
						height: 300
						width: 300

					@.build wall

					y += 300

				x += 300

			x = -width / 2
			while x < width / 2

				y = 150
				while y < 150 + height
					wall =
						vertical: "x"
						direction: -1
						position: 
							x: x + 150 , y: y , z: width / 2
						height: 300
						width: 300

					@.build wall

					y += 300

				x += 300

			x = -width / 2
			while x < width / 2

				y = 150
				while y < 150 + height
					wall =
						vertical: "z"
						direction: 1
						position: 
							z: x + 150 , y: y , x: -width / 2
						height: 300
						width: 300

					@.build wall

					y += 300

				x += 300

			x = -width / 2
			while x < width / 2

				y = 150
				while y < 150 + height
					wall =
						vertical: "z"
						direction: -1
						position: 
							z: x + 150 , y: y , x: width / 2
						height: 300
						width: 300

					@.build wall

					y += 300

				x += 300

			x = -width / 2
			while x < width / 2

				y = -width / 2
				while y < width / 2

					wall =
						vertical: "y"
						direction: -1
						position: 
							x: x + 150 , y: height , z: y + 150
						height: 300
						width: 300

					@.build wall

					y += 300

				x += 300

		build: ( props ) =>

			# whoops more garbage
			self = @

			# make the wall
			geometry = new THREE.PlaneBufferGeometry( props.width , props.height , 10 , 10 )
			material = new THREE.MeshBasicMaterial
				color: @.colors[ Math.floor( Math.random() * @.colors.length )]

			# make the mesh
			section = new THREE.Mesh geometry , material
			@.sections.push section

			# add face info
			section.vertical = props.vertical
			section.direction = props.direction

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
					if props.direction > 0
						section.rotation.y = Math.radians( 90 )
					else
						section.rotation.y = Math.radians( -90 )

			# build the collision box
			x1 = section.position.x
			x2 = section.position.x
			y1 = section.position.y
			y2 = section.position.y
			z1 = section.position.z
			z2 = section.position.z


			switch props.vertical
				when "x"
					y1 -= props.height / 2
					y2 += props.height / 2
					x1 -= props.width / 2
					x2 += props.width / 2

				when "y"
					z1 -= props.height / 2
					z2 += props.height / 2
					x1 -= props.width / 2
					x2 += props.width / 2

				when "z"
					y1 -= props.height / 2
					y2 += props.height / 2
					z1 -= props.width / 2
					z2 += props.width / 2

			collision =
				onCollision: self.onCollision
				x1: x1
				x2: x2
				y1: y1
				y2: y2
				z1: z1
				z2: z2

			# apply the collision
			section.collision = collision
			site.stage.collision.add section

			# apply shadows
			section.castShadow = false
			section.receiveShadow = false

			# add it to the scene
			site.stage.scene.add section

		onCollision: ( object ) ->
		
			player = site.stage.player
			direction = object.direction
			switch object.vertical
				when "x" then axis = "z"
				when "y" then axis = "y"
				when "z" then axis = "x"

			player.velocity[ axis ] = direction * Math.abs( player.velocity[ axis ]) * 1.1
			player.balloon.position[ axis ] += player.velocity[ axis ]