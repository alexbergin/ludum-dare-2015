define ->

	# controls what pages are visible and when
	# make a page visible by calling
	# site.views.render( "id" )

	class Views

		# milliseconds required for
		# page transitions
		transition: 250

		init: ->

			# get all pages then show the preloader
			@.getElements()
			@.render "preloader"

		getElements: ->

			# all sections are page elements
			@.pages = document.getElementsByTagName "section"

		render: ( view ) ->

			# reset page views
			for page in @.pages
				@.reset page

			# get the active page and make it visible
			active = document.getElementById view
			active.classList.remove "not-visible"
			active.classList.add "active"

			# make sure the reset doesn't affect the active page
			clearTimeout active.timer

		reset: ( page ) ->

			# remove active state, making page transition out
			page.classList.remove "active"

			# reset then set a timer to make it display none
			clearTimeout page.timer
			page.timer = setTimeout =>
				page.classList.add "not-visible"
			, @.transition

