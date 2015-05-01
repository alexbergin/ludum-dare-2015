define ->

	# generates the game level
	class Level

		# check if the user is building anything
		isBuilding: false

		# width/height/depth of the grid
		gridSize: 300

		init: ->

			@.setup()
			@.addListeners()

		setup: ->

			# make the placement block
			@.block = site.stage.wall.build
				scale:
					x: @.gridSize , y: @.gridSize , z: @.gridSize
				position:
					x: 0 , y: 0 , z: 0

			# make sure it doesn't get pointer detection
			@.block.pointerDetection = false

			# make it transparent
			@.block.material.transparent = true
			@.block.material.opacity = 0.5
			@.block.material.color.setHex( 0x6ADDCE )
			@.block.material.needsUpdate = true

			# no collision
			@.block.collision.onCollision = -> return null

		addListeners: ->

			window.addEventListener "mousedown" , @.onMouseUp

		onMouseUp: ( e ) =>
			console.log e

			if @.isBuilding
				switch e.which
					when 1 then @.addBlock( @.block.position.x , @.block.position.y , @.block.position.z )
					when 3 then @.removeBlock()

		addBlock: ( x , y , z ) ->
			block = site.stage.wall.build
				scale:
					x: @.gridSize , y: @.gridSize , z: @.gridSize
				position:
					x: x , y: y , z: z

			block.playerPlaced = true

		removeBlock: =>
			block = site.stage.pointer.activeObject
			console.log block
			if block isnt null and block.playerPlaced is true and block.parent isnt undefined
				site.stage.wall.destroy block

		loop: =>

			@.updatePosition()
			@.updateCursor()

		updatePosition: ->

			if @.isBuilding
				vertices = [ "x" , "y" , "z" ]

				for vertex in vertices
					@.block.position[ vertex ] = Math.round( site.stage.pointer.position[ vertex ] / @.gridSize ) * @.gridSize

				switch site.stage.pointer.position.faceIndex
					when 2 then @.block.position.x -= @.gridSize
					when 3 then @.block.position.x -= @.gridSize
					when 10 then @.block.position.z -= @.gridSize
					when 11 then @.block.position.z -= @.gridSize

				@.block.position.y = Math.max( 0 , @.block.position.y )

		updateCursor: ->
			if @.isBuilding
				@.block.material.opacity = 0.5
			else
				@.block.material.opacity = 0
			@.block.material.needsUpdate = true

