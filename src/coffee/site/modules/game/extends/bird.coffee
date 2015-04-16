define [

	"site/modules/game/extends/obj"

] , (

	Obj

) ->

	# this is just a test object,
	# so ideally this is all you're writing

	class Bird extends Obj

		init: =>

			@.clock = new THREE.Clock()
			@.build(
				src: "models/flamingo.js"
				callback: @.ready
			)

		ready: ( mesh ) =>
			@.character = mesh

		loop: =>

			# classic
			@.character.position.z += 1
