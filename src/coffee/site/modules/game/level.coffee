define ->

	# generates the game level
	class Level

		# storing generated layers in this array
		layers: []

		# what the highest grid point it
		position: 0

		# width/height/depth of the grid
		gridSize: 300

		# number of grid sections
		height: 10
		width: 10
		depth: 10

		loop: =>

			# check to see if the player is at an altitude
			# that needs a new layer
			if site.stage.player.balloon.position.y + ( @.gridSize * @.height ) > @.position
				@.position += @.gridSize * @.height
				@.buildLayer()

			# destroy old layers
			i = 0
			n = -1
			for layer in @.layers
				if layer.position < site.stage.player.balloon.position.y - ( @.gridSize * @.height ) then n = i
				i++
			if n >= 0 then @.destroy @.layers[n]

		destroy: ( layer ) ->

			# remove inner elements
			for grid in layer.grid

				# remove wall
				if grid.wall isnt false
					site.stage.wall.destroy grid.wall

			# remove from sections array
			i = 0
			n = 0
			for l in @.layers
				if l is layer then n = i
				i++

			@.layers.splice( n , 1 )

		buildLayer: ->

			# make a new grid array
			grid = []

			# fill it with the base object

			# loop through each z
			z = 0
			while z < @.depth

				# loop through each x
				x = 0
				while x < @.width

					# loop through each y
					y = 0
					while y < @.height

						# set up grid data
						props =
							wall: false
							fan: 
								vertical: null
								direction: null
							spikes:
								vertical: null
								direction: null
							x: x
							y: y
							z: z

						# save to the layer
						grid.push props

						y++
					x++
				z++

			grid = @.makeWalls grid
			@.updateLight()

			layer =
				position: @.position
				grid: grid

			@.layers.push layer

		makeWalls: ( layer ) ->

			# if it's the bottom layer, make it a wall
			for grid in layer
				if grid.y is 0 then grid.wall = true

			# position the openings randomly, with at least 1 opening
			opening = Math.floor( Math.random() * ( @.width * @.depth ))
			for grid in layer
				if grid.y is 0 then opening--
				if opening is 0 then grid.wall = false
				if Math.random() > 0.9 then grid.wall = false

			# define the wall parts
			for grid in layer

				# only build on wall = true
				if grid.wall is true
					
					# position relative to the shaft
					x = ( grid.x * @.gridSize ) - ( @.width * @.gridSize * 0.5 ) + ( @.gridSize * 0.5 )
					y = ( grid.y * @.gridSize ) + @.position
					z = ( grid.z * @.gridSize ) - ( @.depth * @.gridSize * 0.5 ) + ( @.gridSize * 0.5 )
					size = @.gridSize

					# define the wall section
					section =
						position:
							x: x
							y: y
							z: z
						scale: 
							x: size 
							y: size
							z: size

					# call the build function
					grid.wall = site.stage.wall.build( section )
			return layer

		updateLight: ->
			light = site.stage.light.spot
			x = @.width * @.gridSize * 0.5
			y = ( @.position + @.height ) - ( @.gridSize * @.height * 0.5 )
			z = @.depth * @.gridSize * 0.5
			light.position.set( x , y , z )