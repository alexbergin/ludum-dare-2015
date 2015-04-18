define [

	"site/modules/game/extends/obj"

] , (

	Obj

) ->

	# this is just a test object,
	# so ideally this is all you're writing

	class Bird extends Obj

		rot:
			x: 0
			y: 0
			z: 0

		mot:
			x: 0
			y: 0
			z: 0

		init: =>

			@.clock = new THREE.Clock()
			@.build(
				src: "models/monkey.js",
				color: 0xff0000
				scale:
					x: 3 , y: 3 , z: 3
				callback: @.ready
			)

			@.addListeners()

		ready: ( mesh ) =>

			# store the mesh to a variable we can access
			@.character = mesh

		loop: =>

			# peform our animation
			@.position()


		addListeners: ->
			window.addEventListener "devicemotion" , @.onDeviceMotion
			window.addEventListener "deviceorientation" , @.onDeviceOrientation
			window.addEventListener "mousemove" , @.onMouseMove

		onDeviceMotion: ( e ) =>
			@.mot =
				x: e.acceleration.x * 3
				y: e.acceleration.y * 3
				z: e.acceleration.z * 3

		onDeviceOrientation: ( e ) =>
			@.rot =
				x: e.beta + ( 90 * ( Math.PI / 180 ))
				y: e.gamma
				z: e.alpha

		onMouseMove: ( e ) =>
			x = e.clientX
			y = e.clientY

			@.mot =
				x: ( x - ( window.innerWidth ) / 2 ) * 0.1
				y: ( y - ( window.innerHeight ) / 2 ) * -0.1
				z: 0

		position: ->

			rot = @.rot
			mot = @.mot

			props = [ "x" , "y" , "z" ]
			for prop in props
				@.character?.rotation[ prop ] = rot[ prop ] * ( Math.PI / 180 )
				@.character?.position[ prop ] += mot[ prop ]
				@.character?.position[ prop ] = @.character?.position[ prop ] * 0.8

