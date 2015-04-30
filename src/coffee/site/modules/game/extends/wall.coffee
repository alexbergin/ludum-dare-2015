define ->

	class Wall

		colors: [
			0xE8F2F7
		]

		sections: []

		build: ( props ) =>

			# whoops more garbage
			self = @

			# make the wall
			geometry = new THREE.BoxGeometry( 1 , 1 , 1)
			material = new THREE.MeshBasicMaterial
				color: 0xffffff
				vertexColors: THREE.FaceColors
				transparent: true
				opacity: 1

			# make the mesh
			section = new THREE.Mesh geometry , material
			@.sections.push section

			red = 230 / 255
			green = 239 / 255
			blue = 244 / 255

			# jesus christ, this uses "north" as the facing direction
			# of the camera. shade value is multiplied by the rgb to return
			# the final value
			shade = [ 
				1.015 # west
				1.015 # east
				1.050 # top 
				0.985 # bottom
				1.030 # north
				1.000 # south
			]

			i = 0
			while i < 12
				faces = section.geometry.faces
				r = red * shade[ Math.floor( i / 2 )]
				g = green * shade[ Math.floor( i / 2 )]
				b = blue * shade[ Math.floor( i / 2 )]
				faces[ i + 0 ].color.setRGB( r , g , b )
				faces[ i + 1 ].color.setRGB( r , g , b )
				i += 2

			section.geometry.colorsNeedUpdate = true

			# position the mesh
			verticies = [ "x" , "y" , "z" ]
			for vertex in verticies
				section.position[ vertex ] = props.position[ vertex ]
				section.scale[ vertex ] = props.scale[ vertex ]

			# build the collision box
			x1 = section.position.x + ( section.scale.x / 2 ) + 30
			x2 = section.position.x - ( section.scale.x / 2 ) - 30
			y1 = section.position.y + ( section.scale.y / 2 ) + 40
			y2 = section.position.y - ( section.scale.y / 2 ) - 40
			z1 = section.position.z + ( section.scale.z / 2 ) + 30
			z2 = section.position.z - ( section.scale.z / 2 ) - 30

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
			section.castShadow = true
			section.receiveShadow = true

			# add it to the scene
			site.stage.scene.add section

			return section

		loop: =>
			for section in @.sections
				opacity = 1 # Math.min( Math.max( ((( section.position.y ) - ( site.stage.player.balloon.position.y )) / 300 ) , 0.1 ) , 1 )
				section.material.opacity = opacity
				section.needsUpdate = true

		destroy: ( section ) ->
			exists = true
			i = 0
			while exists
				if @.sections[i] is section
					site.stage.scene.remove @.sections[i]
					@.sections.splice( i , 1 )
					exists = false
				i++

		onCollision: ( object ) ->
		
			player = site.stage.player 
			direction = 0
			axis = "y"

			xDis = Math.min( Math.abs( player.balloon.position.x - ( object.position.x + object.scale.x / 2 + 30 )) , Math.abs( player.balloon.position.x - ( object.position.x - object.scale.x / 2 - 30 )))
			yDis = Math.min( Math.abs( player.balloon.position.y - ( object.position.y + object.scale.y / 2 + 40 )) , Math.abs( player.balloon.position.y - ( object.position.y - object.scale.y / 2 - 40 )))
			zDis = Math.min( Math.abs( player.balloon.position.z - ( object.position.z + object.scale.z / 2 + 30 )) , Math.abs( player.balloon.position.z - ( object.position.z - object.scale.z / 2 - 30 )))

			if Math.min( xDis , yDis , zDis ) is xDis
				if player.balloon.position.x > object.position.x then direction = 0.5 else direction = -0.5
				axis = "x"

			if Math.min( xDis , yDis , zDis ) is yDis
				if player.balloon.position.y > object.position.y then direction = 1.2 else direction = -1.2
				axis = "y"

			if Math.min( xDis , yDis , zDis ) is zDis
				if player.balloon.position.z > object.position.z then direction = 0.5 else direction = -0.5
				axis = "z"

			player.velocity[ axis ] = direction * Math.abs( player.velocity[ axis ]) * 1.01
			player.balloon.position[ axis ] += player.velocity[ axis ]