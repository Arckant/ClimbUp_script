version '1.1.0'
author 'Arckant'
repository 'https://github.com/Arckant'

resource_type 'script' { name = 'ClimbUp' }

shared_scripts {
  'Marker.lua'
}

client_scripts {
  'client.lua'
}

server_scripts {
  'server.lua'
}
game 'gta5'
fx_version 'cerulean'