define ->

	class Spikes

		sections: []

		init: ->

			spike =
				vertical: "y"
				direction: 1
				position: 
					x: 0 , y: 0 , z: 0
				height: 300
				width: 300

			@.build spike

		build: ( props ) =>

			x = props.position.x
			y = props.position.y
			z = props.position.z

			ox = 0
			while ox < props.width

				oy = 0
				while oy < props.height 

					h = 40 + Math.random() * 22
					w = 6 + Math.random() * 3
					xp = ox + (( Math.random() - 0.5 ) * ( props.width / 12 ))
					yp = oy + (( Math.random() - 0.5 ) * ( props.height / 12 ))

					geometry = new THREE.CylinderGeometry 0 , w , h , 3 , 1 , true
					material = new THREE.MeshBasicMaterial
						color: 0xD65555

					cone = new THREE.Mesh geometry , material
					cone.castShadow = false
					cone.receiveShadow = false

					switch props.vertical

						when "x"
							cone.position.x = x + h / 2
							cone.position.y = y + yp
							cone.position.z = z + xp

							if props.direction < 0
								cone.rotation.z = Math.radians( 90 )
							else
								cone.rotation.z = Math.radians( -90 )

						when "y"
							cone.position.x = x + xp
							cone.position.y = y + h / 2
							cone.position.z = z + yp

							if props.direction < 0
								cone.rotation.x = Math.radians( 180 )

						when "z"
							cone.position.x = x + xp
							cone.position.y = y + yp
							cone.position.z = z + h / 2

							if props.direction < 0
								cone.rotation.x = Math.radians( 90 )
							else
								cone.rotation.x = Math.radians( -90 )

					site.stage.scene.add cone

					oy += props.height / 6

				ox += props.width / 6
