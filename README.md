# rally
Artifacts related to running Rally scenarios

# Existing.json 
File used to the cloud type, auth-url, region_name, endpoint_type, and admin credentials.

# osic-glance-cinder-nova.json
Parameters: Flavor_name, image_name, volume_type, volume_size, new_volume_size, and iterations.

Used to test different scenarios for glance, cinder and nova. This file test:   
NovaServers.boot_and_delete_server,   
NovaServers.boot_server_from_volume_and_delete,   
CinderVolumes.create_and_delete_snapshot,  
CinderVolumers.create_volume_and_clone,   
CinderVolumes.create_volume_from_snapshot,  
CinderVolumes.create_and_extend_volume,   
GlanceImages.create_and_delete_image  

# osic-keystone-prime-scenario.json:
KeystoneBasic.authenticate_user_and_validate_token - Used to authenticate 1 user and token to prime for the osic-keystone-scenario.

# osic-keystone-scenarion.json
KeystoneBasic.authenticate_user_and_validate_token - Used to authenticate 20 users and validate their tokens.

# osic-nova-1-server-scenario.json
NovaServers.boot_server - Used to boot one server to prime for the n-server-scenario. 
Parameters: flavor_name.

# osic-nova-n-server-scenario.json
NovaServers.boot_server - Used to boot a specified number of servers.
Parameters: flavor_name, servers_to_build

# run_rally.sh
Used to Initialize database, create a rally deployment, and start the rally task.
