import yaml
import json

with open('/etc/ansible/roles/os_tempest/defaults/main.yml') as f:
  data = f.read()
with open('args.yaml') as f:
  args = f.read()
with open('/etc/ansible/roles/os_cinder/defaults/main.yml') as f:
  cinder_backends = f.read()
with open('/etc/ansible/roles/os_tempest/tasks/tempest_resources.yml') as f:
  flavor = f.read()

args_yaml = yaml.safe_load(args)
data_yaml = yaml.safe_load(data)
cinder_yaml = yaml.safe_load(cinder_backends)
flavor_yaml = yaml.safe_load(flavor)

args_yaml['image_name'] = data_yaml['tempest_img_name']
args_yaml['flavor_name'] = flavor_yaml[0][0]['register']

temp = bool(cinder_yaml['cinder_backend_lvm_inuse'])
if temp == True:      
  args_yaml['volume_type'] = "lvm"
  
with open('args.yaml', 'w') as outfile:
    yaml.dump(args_yaml, outfile)
