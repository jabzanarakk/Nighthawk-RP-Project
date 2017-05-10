resource_type 'gametype' { name = 'Roleplay' }

-- Manifest
resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

-- Requiring essentialmode
dependency 'essentialmode'

-- Core General
client_script 'client_core.lua'
server_script 'server_core.lua'

-- Server configs
server_script 'config/config_master.lua'

-- Function
server_script 'function/server_function.lua'