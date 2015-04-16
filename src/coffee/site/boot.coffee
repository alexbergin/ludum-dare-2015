define [

	# run on start
	"site/modules/preloader"
	"site/modules/views"

	# run later
	"site/modules/landing"
	"site/modules/stage"

] , (

	# run on start
	Preloader
	Views

	# run later
	Landing
	Stage

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

			# run later
			landing: new Landing
			stage: new Stage

			start: ->

				# property names to call "init" on
				# when the site is ready to run
				run = [
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