"use strict"

require.config
	baseUrl: "/scripts"

	paths:
		"classlist": "vendor/classlist/classList"
		"jquery": "vendor/jquery/dist/jquery"
		"THREE": "vendor/threejs/build/three"
		"Howl": "vendor/howler.js/howler"
		"requestAnimationFrame": "vendor/requestAnimationFrame/app/requestAnimationFrame"
		"SoundJS": "vendor/SoundJS/lib/soundjs-0.6.0.min"
		
require [ "site/boot" ] , ( Site ) ->
	new Site()