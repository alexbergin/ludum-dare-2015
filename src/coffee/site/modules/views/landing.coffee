define ->

	# the functional bits of the landing page
	# basically just a start button
	class Landing

		init: ->

			# get the button
			@.getElements()

			# make it work
			@.addListeners()

		getElements: ->

			# store elements
			@.page = document.getElementById "landing"
			@.start = @.page.getElementsByClassName( "start" )[0]

		addListeners: ->

			# listen for a click on the start button
			@.start.addEventListener "click" , @.onStart

		onStart: ->

			# switch to the game page and tell it to run
			site.views.render "stage"
			site.game.reset()