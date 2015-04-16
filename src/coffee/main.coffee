"use strict"

require.config
	baseUrl: "/scripts"

	paths:
		"classlist": "vendor/classlist/classList"
		"jquery": "vendor/jquery/dist/jquery"
		"PIXI": "vendor/pixi.js/bin/pixi.dev"
		"requestAnimationFrame": "vendor/requestAnimationFrame/app/requestAnimationFrame"
		"SoundJS": "vendor/SoundJS/lib/soundjs-0.6.0.min"
		
require [ "site/boot" ] , ( Site ) ->
	new Site()