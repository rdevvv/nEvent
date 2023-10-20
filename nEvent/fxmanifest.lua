fx_version 'adamant'
game 'gta5'

name "NeVo_Event"
description 'for rDev'
author "nevogia#9717"

client_scripts {
  "src/RMenu.lua",
  "src/menu/RageUI.lua",
  "src/menu/Menu.lua",
  "src/menu/MenuController.lua",
  "src/components/*.lua",
  "src/menu/elements/*.lua",
  "src/menu/items/*.lua",
  "src/menu/panels/*.lua",
  "src/menu/windows/*.lua",
}

client_scripts {
  'client.lua',
  'function.lua'
}

server_scripts {
  'server.lua'
}

shared_script {
  'config.lua'
}