define ->

	class Spikes

		sections: []

		init: ->

			spike =
				vertical: "y"
				direction: 1
				position: 
					x: 900 , y: 10 , z: 900
				height: 600
				width: 600

			# @.build spike

		build: ( props ) =>

			self = @

			x = props.position.x
			y = props.position.y
			z = props.position.z

			ox = -props.width / 2
			while ox < props.width / 2

				oy = -props.height / 2
				while oy < props.height / 2

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
							cone.position.x = x + h / 2 - 10
							cone.position.y = y + yp
							cone.position.z = z + xp

							if props.direction < 0
								cone.rotation.z = Math.radians( 90 )
							else
								cone.rotation.z = Math.radians( -90 )

						when "y"
							cone.position.x = x + xp
							cone.position.y = y + h / 2 - 10
							cone.position.z = z + yp

							if props.direction < 0
								cone.rotation.x = Math.radians( 180 )

						when "z"
							cone.position.x = x + xp
							cone.position.y = y + yp
							cone.position.z = z + h / 2 - 10

							if props.direction < 0
								cone.rotation.x = Math.radians( 90 )
							else
								cone.rotation.x = Math.radians( -90 )

					site.stage.scene.add cone

					oy += 60

				ox += 60

			x1 = x
			x2 = x
			y1 = y
			y2 = y
			z1 = z
			z2 = z

			switch props.vertical

				when "x"
					y1 -= props.height / 2
					y2 += props.height / 2
					z1 -= props.width / 2
					z2 += props.width / 2

				when "y"
					x1 -= props.width / 2
					x1 += props.width / 2
					z1 -= props.height / 2
					z2 += props.height / 2

				when "z"
					x1 -= props.width / 2
					x2 += props.width / 2
					y1 -= props.height / 2
					y2 += props.height / 2

			obj = {}
			obj.collision =
				onCollision: self.onCollision
				x1: x1
				x2: x2
				y1: y1
				y2: y2
				z1: z1
				z2: z2

			site.stage.collision.add obj

		onCollision: ->
			console.log "popping"
			# if site.stage.player.isDead is false then site.stage.player.die()


