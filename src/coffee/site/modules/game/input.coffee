define ->

	class Input

		startX: 0
		x: 0

		startY: 0
		y: 0

		leftDown: false
		rightDown: false

		init: ->
			@.addListeners()

		addListeners: ->

			# listen for a distance change
			window.addEventListener "mousewheel" , @.onMouseWheel

			# listen for left or right mouse buttons to be pressed
			window.addEventListener "mousedown" , @.onMouseDown
			window.addEventListener "mouseup" , @.onMouseUp

			# listen for movement of the mouse
			window.addEventListener "mousemove" , @.onMouseMove

			# hack to allow us to use the right mouse button
			document.oncontextmenu = document.body.oncontextmenu = -> return false

		onMouseWheel: ( e ) ->

			# get how much to change the distance
			delta = e.wheelDelta * 0.2

			# apply the delta to the current position
			distance = site.stage.player.distance - delta

			# bound it between a minimum and maximum
			distance = Math.min( 600 , Math.max( 120 , distance ))

			# apply to the camera
			site.stage.player.distance = distance

		onMouseMove: ( e ) =>

			# get the current mouse position
			@.x = e.clientX
			@.y = e.clientY

			# position the camera
			if @.rightDown is true then @.updateCamera()

			# move the balloon
			if @.leftDown is true then @.updateBalloon()


		onMouseDown: ( e ) =>

			# stop default
			e.preventDefault()
			
			# detect which button was clicked
			switch e.which

				# call the right one
				when 1 then @.onLeftDown()
				when 3 then @.onRightDown()

		onMouseUp: ( e ) =>

			# stop default
			e.preventDefault()
			
			# detect which button was clicked
			switch e.which

				# call the right one
				when 1 then @.onLeftUp()
				when 3 then @.onRightUp()

		onLeftUp: ->

			# release the balloon
			@.leftDown = false

		onLeftDown: ->

			# get starting position
			if @.leftDown is false and @.rightDown is false
				@.startX = @.x
				@.startY = @.y

			# grab the balloon
			@.leftDown = true

		onRightUp: ->

			# release the camera
			@.rightDown = false

		onRightDown: ->

			# get starting position
			if @.leftDown is false and @.rightDown is false
				@.startX = @.x
				@.startY = @.y

			#grab the camera
			@.rightDown = true

		updateCamera: ->

			# get and contain the delta for movement
			delta = ( @.startX - @.x ) * 0.5

			# apply the movement
			site.stage.player.angle += delta

			# reset the difference
			@.startX = @.x

		updateBalloon: ->

			# get the balloon's velocity & viewing angle
			balloon = site.stage.player.velocity
			angle = site.stage.player.angle

			# get our deltas
			x = ( @.startX - @.x ) * 0.2
			y = ( @.startY - @.y ) * 0.2

			# set our input velocity
			xVel = Math.sin( Math.radians( angle - 90 )) * x
			zVel = Math.cos( Math.radians( angle - 90 )) * x
			yVel = y

			# apply the input to the balloon
			balloon.x += xVel
			balloon.y += yVel
			balloon.z += zVel

			# reset the delta
			@.startX = @.x
			@.startY = @.y