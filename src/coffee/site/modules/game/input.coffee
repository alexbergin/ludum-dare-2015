define ->

	class Input

		isBuilding: false
		shiftKey: false

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

			# listen for key events
			window.addEventListener "keydown" , @.onKeyDown
			window.addEventListener "keyup" , @.onKeyUp

			# hack to allow us to use the right mouse button
			document.oncontextmenu = document.body.oncontextmenu = -> return false

		onKeyDown: ( e ) =>

			# listen for key press
			switch e.keyCode
				when 16 then @.shiftKey = true

		onKeyUp: ( e ) =>

			# listen for key release
			switch e.keyCode
				when 16 then @.shiftKey = false
				when 65 then @.toggleBuilding()

		onMouseWheel: ( e ) =>

			# do nothing if touch
			if site.stage.isTouch is false and @.isBuilding is false

				# get how much to change the distance
				delta = e.wheelDelta * 0.2

				# apply the delta to the current position
				distance = site.stage.camera.distance - delta

				# bound it between a minimum and maximum
				distance = Math.min( 2500 , Math.max( 300 , distance ))

				# apply to the camera
				site.stage.camera.distance = distance

		onMouseMove: ( e ) =>

			# do nothing if touch or building
			if site.stage.isTouch is false and @.isBuilding is false

				# get the current mouse position
				@.x = e.clientX
				@.y = e.clientY

				# position the camera
				if @.rightDown is true then @.updateRotation()

				# move the balloon
				if @.leftDown is true then @.updatePosition()

		onTouchMove: ( e ) =>

			# do nothing if building
			if @.isBuilding is false
			
				# get the current average touch position
				@.x = 0
				@.y = 0

				for touch in e.touches
					@.x += touch.clientX
					@.y += touch.clientY

				@.x = @.x / e.touches.length
				@.y = @.y / e.touches.length

				# position the camera
				if @.rightDown is true then @.updateRotation()

				# move the balloon
				if @.leftDown is true then @.updatePosition()


		onMouseDown: ( e ) =>

			# do nothing if touch
			if site.stage.isTouch is false and @.isBuilding is false

				# stop default
				e.preventDefault()
				
				# detect which button was clicked
				switch e.which

					# call the right one
					when 1 then @.onLeftDown()
					when 3 then @.onRightDown()

		onTouchStart: ( e ) =>
			
			if @.isBuilding is false

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
			if site.stage.isTouch is false and @.isBuilding is false

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
			if e.touches.length is 0 and @.isBuilding is false

				# release camera and balloon
				@.onLeftUp()
				@.onRightUp()

		onLeftUp: ->

			# release the balloon
			@.leftDown = false

		onLeftDown: ->

			# get starting position
			if @.leftDown is false and @.rightDown is false and @.isBuilding is false
				@.startX = @.x
				@.startY = @.y

			# grab the balloon
			@.leftDown = true

		onRightUp: ->

			# release the camera
			@.rightDown = false

		onRightDown: ->

			# get starting position
			if @.leftDown is false and @.rightDown is false and @.isBuilding is false
				@.startX = @.x
				@.startY = @.y

			#grab the camera
			@.rightDown = true

		updateRotation: ->

			# get and contain the delta for movement
			deltaX = ( @.startX - @.x ) * 0.5

			# apply the movement
			site.stage.camera.hAngle += deltaX

			# reset the difference
			@.startX = @.x

			# use the y delta to move the camera vertically
			# on a touch device
			if site.stage.isTouch

				# get the anchor position
				anchor = site.stage.camera.anchor

				# get the input amount
				deltaY = ( @.startY - @.y ) * 4
				anchor.y += deltaY

				# reset to get delta
				@.startY = @.y

		updatePosition: ->

			# get the camera's rotation & position
			anchor = site.stage.camera.anchor
			angle = site.stage.camera.hAngle

			# set movement amount based on touch
			if site.stage.isTouch
				mult = 4
			else
				mult = 2

			# get our deltas
			x = ( @.startX - @.x ) * mult
			y = ( @.startY - @.y ) * mult

			# apply the input to the camera anchor
			if @.shiftKey is true
				anchor.y += y

			else

				# set our left & right input velocity
				xVel = Math.sin( Math.radians( angle + 90 )) * x
				yVel = Math.cos( Math.radians( angle + 90 )) * x

				# add our forward and backwards velocity
				xVel += Math.sin( Math.radians( angle )) * y
				yVel += Math.cos( Math.radians( angle )) * y

				# add deltas
				anchor.x += xVel
				anchor.z += yVel

			# reset the delta
			@.startX = @.x
			@.startY = @.y

		toggleBuilding: =>

			if @.isBuilding is true then @.isBuilding = false else @.isBuilding = true
			site.stage.level.isBuilding = @.isBuilding