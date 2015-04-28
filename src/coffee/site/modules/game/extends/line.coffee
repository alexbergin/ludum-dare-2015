define ->

	class Line

		points: []
		count: 12
		minDist: 20

		init: ->
			@.makeString()

		distance: ( p1 , p2 ) ->

			x = p1.x - p2.x
			y = p1.y - p2.y
			z = p1.z - p2.z

			d = x * x + y * y + z * z
			d = Math.sqrt d
			d = Math.abs d

			return d

		makeString: ->

			geometry = new THREE.Geometry()
			material = new THREE.LineBasicMaterial
				color: 0xff0000

			i = 0
			while i < @.count
				point =
					position:
						x: 0 , y: 0 , z: 0
					velocity:
						x: 0 , y: 0 , z: 0

				@.points.push point
				geometry.vertices.push( new THREE.Vector3( 0 , -i * @.minDist , 0 ))

				i++

			@.string = new THREE.Line geometry , material
			site.stage.scene.add @.string

		loop: =>

			# vertices + player
			vertices = [ "x" , "y" , "z" ]
			balloon = site.stage.player.balloon

			# set the starting point
			for vertex in vertices
				@.points[0].position[ vertex ] = balloon.position[ vertex ]

			# position remaining points
			i = 1
			while i < @.points.length

				# get our reference points
				past = @.points[ i - 1 ]
				point = @.points[ i ]

				# move if needed
				if @.distance( past.position , point.position ) > @.minDist
					mult = 0.2
				else
					mult = 0

				for vertex in vertices

					diff = point.position[ vertex ] - past.position[ vertex ]

					if Math.abs( diff ) > 0.00001
						point.velocity[ vertex ] -= diff * mult

					else
						point.position[ vertex ] = past.position[ vertex ]

				# apply positioning and friction
				for vertex in vertices
					point.velocity[ vertex ] *= 0.6
					point.position[ vertex ] += point.velocity[ vertex ]

				point.velocity.y -= 9

				i++

			# update the geometry
			for vertex in vertices
				@.string.position[ vertex ] = @.points[0].position[ vertex ]

			# update the strings vertices
			i = 0
			while i < @.points.length

				line = @.string.geometry.vertices[i]
				point = @.points[i]

				# do some garbage here, god i hate this
				for vertex in vertices
					line[vertex] = point.position[vertex] - balloon.position[vertex]

				i++

			@.string.geometry.verticesNeedUpdate = true