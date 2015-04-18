define ->

	# fixing the math object to be somewhat useful
	class MathUtil

		init: ->

			Math.radians = ( n ) ->
				return n * ( Math.PI / 180 )

			Math.degrees = ( n ) ->
				return n * ( 180 / Math.PI )

			window.ShadeColor = (color, percent) ->
				num = color
				amt = Math.round(2.55 * percent)
				R = (num >> 16) + amt
				G = (num >> 8 & 0x00FF) + amt
				B = (num & 0x0000FF) + amt
				c = (0x1000000 + (if R < 255 then (if R < 1 then 0 else R) else 255) * 0x10000 + (if G < 255 then (if G < 1 then 0 else G) else 255) * 0x100 + (if B < 255 then (if B < 1 then 0 else B) else 255)).toString(16).slice 1
				return parseInt(c, 16)