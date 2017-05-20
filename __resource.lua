resource_type 'gametype' { name = 'Roleplay' }

-- Manifest
resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

-- Requiring essentialmode
dependency 'essentialmode'

-- lib 
ui_page 'html/banking/ui.html'
files {
	'html/banking/ui.html',
	'html/banking/pricedown.ttf',
	'html/banking/bank-icon.png',
	'html/banking/logo.png',
	'html/banking/cursor.png',
	'html/banking/styles.css',
	'html/banking/scripts.js',
	'html/banking/debounce.min.js'
}

-- Core General
client_script 'init_client.lua'
server_script 'init_server.lua'

-- Server configs
server_script 'config/config_master.lua'

-- Function
server_script 'function/server_function.lua'

-- Database
server_script 'db/db_init.lua'
server_script 'db/db_function.lua'

-- Core
client_script 'core/banking/banking_client.lua'
server_script 'core/banking/banking_server.lua'

