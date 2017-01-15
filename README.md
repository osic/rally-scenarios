# rally
Artifacts related to running Rally scenarios. These scenarios are executed using a shell script (executioner.sh) as a controller on the Jenkins Server webpage. The variables IP, USER, PASSWORD, TENANT, RALLY_TASK, and RALLY_PARAS are first updated by the shell script with the credentials from the existing workspace. The  script next step is to send the credentials,the rally task, and the run_rally.sh shell script up to the rally box. The result files are stored into the workspace. Any leftover logs from previous runs are deleted and the logs from openstack & rally are compressed and uploaded to files. The files are then parsed and uploaded to elastic search.

# existing.json 
File used to specify and pass the cloud type, auth-url, region_name, endpoint_type, and admin credentials for each rally task.

# osic-glance-cinder-nova.json
Parameters: Flavor_name, image_name, volume_type, volume_size, new_volume_size, and iterations.

Rally task used to test different scenarios for glance, cinder and nova. This file test:   
NovaServers.boot_and_delete_server - test if nova can boot and delete 1 server.   
NovaServers.boot_server_from_volume_and_delete - test if nova can boot and delete a server from a cinder volume.   
CinderVolumes.create_and_delete_snapshot - test if cinder can create and delete a snapshot.
CinderVolumers.create_volume_and_clone - test if cinder can create a volume and clone another from the newly created volume.  
CinderVolumes.create_volume_from_snapshot - test if cinder can create a volume from a snapshot.  
CinderVolumes.create_and_extend_volume - test if cinder can create a volume and extend the newly created volume.   
GlanceImages.create_and_delete_image  - test if glance can create and delete images.

# osic-keystone-prime-scenario.json:
KeystoneBasic.authenticate_user_and_validate_token - Rally task used to authenticate 1 user and token to prime for the osic-keystone-scenario.

# osic-keystone-scenarion.json
KeystoneBasic.authenticate_user_and_validate_token - Rally task used to authenticate 20 users and validate their tokens.

# osic-nova-1-server-scenario.json
NovaServers.boot_server - Rally task used to boot 1 server to prime for the n-server-scenario. 
Parameters: flavor_name.

# osic-nova-n-server-scenario.json
NovaServers.boot_server - Rally task used to boot a specified number of servers.
Parameters: flavor_name, servers_to_build

# run_rally.sh
Used to initialize rally database, create a rally deployment, and start the rally task.
