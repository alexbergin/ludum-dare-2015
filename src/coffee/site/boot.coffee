define [

	# run on start
	"site/modules/views/preloader"
	"site/modules/utils/views"
	"site/modules/utils/math"

	# run later
	"site/modules/views/landing"
	"site/modules/views/game"
	"site/modules/game/stage"

	# libs
	"THREE"
	"Howl"
	"jquery"

] , (

	# run on start
	Preloader
	Views
	MathUtil

	# run later
	Landing
	Game
	Stage

	# libs
	THREE
	Howl
	$

) ->

	# this is the main start point for the site/game.
	# preloader and a few other classes run first, initializing
	# other classes once complete. see modules/preloader for
	# post preloader processes.

	Site = ->

		class App

			# run on start
			preloader: new Preloader
			views: new Views
			math: new MathUtil

			# run later
			landing: new Landing
			game: new Game
			stage: new Stage

			start: ->

				# property names to call "init" on
				# when the site is ready to run
				run = [
					"math"
					"views"
					"preloader"
				]

				# start all sub classes
				for classes in run
					site[ classes ].init()

		# store everything in the window.site variable
		# and start running all scripts
		window.site = new App
		site.start()