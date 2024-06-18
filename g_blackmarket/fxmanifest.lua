fx_version 'cerulean'

game 'gta5'

description 'BlackMarket hecho por P1ng'
lua54 'yes'
version 'Beta'
author 'P1ng'

shared_script '@es_extended/imports.lua'
server_script '@oxmysql/lib/MySQL.lua'
shared_scripts { 
	'@ox_lib/init.lua',
	'config.lua'
}

client_scripts {
	'client/main.lua',
}

server_scripts {
	'server/main.lua'
}
