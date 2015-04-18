define ->

	class Input

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

		onMouseDown: ( e ) =>

			# stop default
			e.preventDefault()
			
			# detect which button was clicked
			switch e.which

				# call the right one
				when 1 then @.onLeftDown
				when 3 then @.onRightDown

		onMouseUp: ( e ) =>

			# stop default
			e.preventDefault()
			
			# detect which button was clicked
			switch e.which

				# call the right one
				when 1 then @.onLeftUp
				when 3 then @.onRightUp

		onLeftUp: ->

		onLeftDown: ->

		onRightUp: ->

		onRightDown: ->