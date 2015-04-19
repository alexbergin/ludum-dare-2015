define -> 

	# used to load and place obj's on the stage
	# a lot easier
	class Obj

		build: ( props ) =>

			# get the three js loader
			if @.loader is undefined then @.loader = new THREE.JSONLoader()

			# load the geometry and apply the correct properties to it
			@.loader.load props.src , ( geometry ) =>

				# use these for looping though x/y/z props
				vertices = [ "x" , "y" , "z" ]

				# make sure props is valid
				props = @.checkProps props

				# set up shading
				geometry.computeMorphNormals()
				color = props.color

				# basic material for cruise control to simplicity
				material = new THREE.MeshLambertMaterial
					shading: THREE.SmoothShading
					emissive: color

				# create the mesh from our geometery and material
				mesh = new THREE.Mesh geometry , material

				# make it animate if animate isn't undefined
				if props.animation isnt undefined
					mesh.duration = props.animation

				# shadows
				mesh.castShadow = true
				mesh.receiveShadow = true

				# scale it
				mesh.scale.set props.scale.x , props.scale.y , props.scale.z

				# position and rotate the mesh
				for vertex in vertices
					mesh.position[ vertex ] = props.position[ vertex ]
					mesh.rotation[ vertex ] = props.rotation[ vertex ]

				# add the mesh to the stage and return it
				site.stage.scene.add mesh
				props.callback?( mesh )

				# check collision property
				if props.collision isnt undefined

					# add collision prop to the mesh
					# and append to the collision array
					mesh.collision = props.collision
					site.stage.collision.add mesh

		checkProps: ( props ) ->

			# the properties we're checking for
			base = [ "scale" , "rotation" , "position" ]

			# their sub values
			vertices = [ "x" , "y" , "z" ]

			for prop in base

				# make it into a new object
				if props[ prop ] is undefined then props[prop] = {}

				# check the vertices
				for vertex in vertices

					# default to 0 unless it's scale
					if prop is "scale" then n = 1 else n = 0

					# set the values for each vertex
					if props[ prop ][ vertex ] is undefined
						props[ prop ][ vertex ] = n

			# add a color if there is none
			if props.color is undefined then props.color = 0xffffff

			return props