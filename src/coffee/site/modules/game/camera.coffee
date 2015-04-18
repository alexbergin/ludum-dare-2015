define ->

	class Camera

		init: ->

			@.build()
			@.addListeners()

		build: ->

			# store the camera in the alpha property
			@.alpha = new THREE.PerspectiveCamera 75 , window.innerWidth / window.innerHeight , 1 , 2000

			# position it
			@.alpha.position.z = 50

		addListeners: ->

			# listen for a resize to update the camera
			window.addEventListener "resize" , @.onResize

		onResize: =>

			# update the apsect ratio and camera
			@.alpha.aspect = window.innerWidth / window.innerHeight
			@.alpha.updateProjectionMatrix()