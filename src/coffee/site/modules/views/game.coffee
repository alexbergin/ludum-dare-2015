define ->

	# controls the stage view, which is the
	# actual "game" part of the site
	# may or may not use this for interfacing
	# between game and the rest of the site
	class Game

		init: ->

			# basic setup
			@.getElements()

		getElements: ->

			# store the page for later reference
			@.page = document.getElementById "stage"

		# put game start stuff here here
		reset: ->
			
			site.stage.loop = true
