define ->

	class Wall

		colors: [
			# 0xF9FDFF
			0xE8F2F7
		]

		sections: []

		init: ->

			scale = 300

			i = 0
			while i < 50

				x = Math.round(( -site.stage.landscape.width / 2 ) / 300 ) * 300
				while x < site.stage.landscape.width / 2

					y = Math.round(( -site.stage.landscape.height / 2 ) / 300 ) * 300
					while y < site.stage.landscape.height / 2

						if Math.random() > 0.75
							wall =
								position: 
									x: x , y: 600 * i , z: y
								scale:
									x: scale , y: scale , z: scale

							@.build wall

						y += 300

					x += 300

				i++

		build: ( props ) =>

			# whoops more garbage
			self = @

			# make the wall
			geometry = new THREE.BoxGeometry( 1 , 1 , 1)
			material = new THREE.MeshBasicMaterial
				color: @.colors[ Math.floor( Math.random() * @.colors.length )]
				transparent: true
				opacity: 1

			# make the mesh
			section = new THREE.Mesh geometry , material
			@.sections.push section

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

		loop: =>
			for section in @.sections
				opacity = Math.min( Math.max( ((( section.position.y + 300 ) - site.stage.player.balloon.position.y ) / 300 ) , 0 ) , 1 )
				section.material.opacity = opacity
				section.needsUpdate = true

		onCollision: ( object ) ->
		
			player = site.stage.player 
			direction = 0
			axis = "y"

			xDis = Math.min( Math.abs( player.balloon.position.x - ( object.position.x + object.scale.x / 2 + 30 )) , Math.abs( player.balloon.position.x - ( object.position.x - object.scale.x / 2 - 30 )))
			yDis = Math.min( Math.abs( player.balloon.position.y - ( object.position.y + object.scale.y / 2 + 30 )) , Math.abs( player.balloon.position.y - ( object.position.y - object.scale.y / 2 - 30 )))
			zDis = Math.min( Math.abs( player.balloon.position.z - ( object.position.z + object.scale.z / 2 + 30 )) , Math.abs( player.balloon.position.z - ( object.position.z - object.scale.z / 2 - 30 )))

			if Math.min( xDis , yDis , zDis ) is xDis
				if player.balloon.position.x > object.position.x then direction = 1 else direction = -1
				axis = "x"

			if Math.min( xDis , yDis , zDis ) is yDis
				if player.balloon.position.y > object.position.y then direction = 1 else direction = -1
				axis = "y"

			if Math.min( xDis , yDis , zDis ) is zDis
				if player.balloon.position.z > object.position.z then direction = 1 else direction = -1
				axis = "z"

			player.velocity[ axis ] = direction * Math.abs( player.velocity[ axis ]) * 1.01
			player.balloon.position[ axis ] += player.velocity[ axis ]