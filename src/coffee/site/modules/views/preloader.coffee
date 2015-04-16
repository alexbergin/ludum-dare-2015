define [

	"site/data/assets"

] , (

	Assets

) ->

	# used to preload all assets and control the page view
	class Preloader

		# manifest of asset sources and types
		# set in getElements
		assets: null

		# total number loaded
		loaded: 0

		# simulate time for nicer page transition
		delay: 0

		# tasks to perform once preload is complete
		tasks: [
			"landing"
			"game"
			"stage"
		]

		init: ->

			# setup process
			@.getElements()
			@.update()

			# load resources
			@.run()

		getElements: ->

			# get the page element and the preloader bar
			@.page = document.getElementById "preloader"
			@.bar = @.page.getElementsByClassName( "progress" )[0]

			# get the elements to load
			load = new Assets
			@.assets = load.manifest

			# make the three js loader
			@.jsonLoader = new THREE.JSONLoader()

		run: ->

			# save the context for the load event
			self = @

			# loop through all assets and make their tags
			for asset in @.assets

				# see if it's an obj or something for threejs
				if asset.type is "THREE"

					# don't pass anything to the on load event once finished
					@.jsonLoader.load asset.src , => @.onLoad()

				# regular media like an image
				else

					# create the tag we're loading and give it a hidden class
					tag = document.createElement asset.tag
					tag.setAttribute "class" , "preloading-el"

					# determine the name of the attribute we apply the src to
					if asset.attr is undefined then attr = "src" else attr = asset.attr

					# add asset type to tag, if it's defined
					if asset.type isnt undefined
						tag.setAttribute "type" , asset.type

					# add the load event and append the tag to our preloader page
					tag.addEventListener "load" , ->
						self.onLoad @

					# set the tag source so it can load
					tag.setAttribute attr , asset.src
					@.page.appendChild tag

			# add delay to page transition out
			setTimeout =>
				@.delay = 500
			, 40

		onLoad: ( tag ) =>

			# remove the loaded element, if present
			if tag isnt undefined then tag.parentNode.removeChild tag

			# increment the load count
			@.loaded++

			# check the status of our load task
			@.update()

		update: ->

			# find the percent loaded
			if @.assets.length > 0
				percent = ( @.loaded / @.assets.length ) * 100

			# if there aren't any assets, because you know, divide by zero
			else
				percent = 100

			# update the progress bar
			@.progress percent

			# if loading is finished then run end tasks
			if percent is 100 then @.onComplete()

		progress: ( percent ) ->

			# convert to the transform value
			n = -100 + Math.round( percent )

			# vendor prefixing
			properties = [ "webkitTransform" , "mozTransform" , "msTransform" , "transform" ]

			# apply style to each prefix
			for property in properties

				# translate the bar to its correct position
				@.bar.style[ property ] = "translate( #{n}% , 0 )"

		onComplete: ->

			# call each task's init function
			for task in @.tasks
				site[ task ].init()

			# render the landing page
			setTimeout =>
				site.views.render "landing"
			, @.delay
