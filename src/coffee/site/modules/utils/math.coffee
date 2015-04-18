define ->

	# fixing the math object to be somewhat useful
	class MathUtil

		init: ->

			Math.radians = ( n ) ->
				return n * ( Math.PI / 180 )

			Math.degrees = ( n ) ->
				return n * ( 180 / Math.PI )

