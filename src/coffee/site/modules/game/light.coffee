define ->

	# sets the level lighting
	class Light

		# light options
		cast: true
		color: 0xffffff
		onlyShadow: true
		shadowDarkness: 0.05
		debug: false

		init: ->

			@.make()
			@.preferences()
			@.place()

		make: ->

			# make the lights
			@.spot = new THREE.DirectionalLight @.color , 1

		preferences: ->

			# set preferences
			@.spot.castShadow = @.cast
			@.spot.onlyShadow = @.onlyShadow
			@.spot.shadowDarkness = @.shadowDarkness
			@.spot.shadowCameraVisible = @.debug
			@.spot.shadowCameraNear = 100
			@.spot.shadowCameraFar = 2000
			@.spot.shadowCameraLeft = -1500
			@.spot.shadowCameraRight = 1500
			@.spot.shadowCameraTop = 1500
			@.spot.shadowCameraBottom = -1500

		place: ->

			# position the light source
			@.spot.position.set(0, 1000, 0)

			# put the light on the stage
			site.stage.scene.add @.spot