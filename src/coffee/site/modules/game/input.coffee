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

			# listen for touch input
			window.addEventListener "touchstart" , @.onTouchStart
			window.addEventListener "touchmove" , @.onTouchMove
			window.addEventListener "touchend" , @.onTouchEnd

			# listen for left or right mouse buttons to be pressed
			window.addEventListener "mousedown" , @.onMouseDown
			window.addEventListener "mousemove" , @.onMouseMove
			window.addEventListener "mouseup" , @.onMouseUp

			# hack to allow us to use the right mouse button
			document.oncontextmenu = document.body.oncontextmenu = -> return false

		onMouseWheel: ( e ) ->

			# do nothing if touch
			if site.stage.isTouch is false

				# get how much to change the distance
				delta = e.wheelDelta * 0.2

				# apply the delta to the current position
				distance = site.stage.player.distance - delta

				# bound it between a minimum and maximum
				distance = Math.min( 600 , Math.max( 120 , distance ))

				# apply to the camera
				site.stage.player.distance = distance

		onMouseMove: ( e ) =>

			# do nothing if touch
			if site.stage.isTouch is false

				# get the current mouse position
				@.x = e.clientX
				@.y = e.clientY

				# position the camera
				if @.rightDown is true then @.updateCamera()

				# move the balloon
				if @.leftDown is true then @.updateBalloon()

		onTouchMove: ( e ) =>

			# get the current mouse position
			@.x = e.touches[0].clientX
			@.y = e.touches[0].clientY

			# position the camera
			if @.rightDown is true then @.updateCamera()

			# move the balloon
			if @.leftDown is true then @.updateBalloon()


		onMouseDown: ( e ) =>

			# do nothing if touch
			if site.stage.isTouch is false

				# stop default
				e.preventDefault()
				
				# detect which button was clicked
				switch e.which

					# call the right one
					when 1 then @.onLeftDown()
					when 3 then @.onRightDown()

		onTouchStart: ( e ) =>
			
			# stop any default
			e.preventDefault()

			# store the inital touch position
			@.x = e.touches[0].clientX
			@.y = e.touches[0].clientY

			# detect number of touches
			switch e.touches.length
				when 1 then @.onLeftDown()
				when 2 then @.onRightDown()

		onMouseUp: ( e ) =>

			# do nothing if touch
			if site.stage.isTouch is false

				# stop default
				e.preventDefault()
				
				# detect which button was clicked
				switch e.which

					# call the right one
					when 1 then @.onLeftUp()
					when 3 then @.onRightUp()

		onTouchEnd: ( e ) =>

			# stop default
			e.preventDefault()

			# make sure all touches are done
			if e.touches.length is 0

				# release camera and balloon
				@.onLeftUp()
				@.onRightUp()

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
			deltaX = ( @.startX - @.x ) * 0.5
			deltaY = ( @.startY - @.y ) * 0.0001

			# apply the movement
			site.stage.player.angle += deltaX
			site.stage.player.viewHeight += deltaY

			# reset the difference
			@.startX = @.x

		updateBalloon: ->

			# get the balloon's velocity, rotation, & viewing angle
			velocity = site.stage.player.velocity
			angle = site.stage.player.angle

			# set multiplyer
			if site.stage.isTouch
				mult = 0.1
			else
				mult = 0.02

			# get our deltas
			x = ( @.startX - @.x ) * mult
			y = ( @.startY - @.y ) * mult

			# set our left & right input velocity
			xVel = Math.sin( Math.radians( angle - 90 )) * x
			zVel = Math.cos( Math.radians( angle - 90 )) * x

			# add our forward and backwards velocity
			xVel += Math.sin( Math.radians( angle )) * y
			zVel += Math.cos( Math.radians( angle )) * y

			# apply the input to the balloon velocity
			if site.stage.player.isDead is false
				velocity.x += xVel
				velocity.z += zVel

			# reset the delta
			@.startX = @.x
			@.startY = @.y