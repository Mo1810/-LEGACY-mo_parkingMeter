fx_version 'bodacious'
game 'gta5' 

author 'Mo1810#4230'
version '1.2.0'

server_scripts {
	"@es_extended/locale.lua",
	"parkingMeter-s.lua",
	"config.lua",
	"locales/de.lua",
	"locales/en.lua"
}

client_scripts {
	"@es_extended/locale.lua",
	"parkingMeter-c.lua",
	"config.lua",
	"locales/de.lua",
	"locales/en.lua"
}

shared_scripts {
	"@es_extended/imports.lua"
}

dependencies {
	"es_extended"
}
