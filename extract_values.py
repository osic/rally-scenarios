import yaml
import json

with open('/etc/ansible/roles/os_tempest/defaults/main.yml') as f:
  data = f.read()
with open('args.yaml') as f:
  args = f.read()
with open('/etc/ansible/roles/os_cinder/defaults/main.yml') as f:
  cinder_backends = f.read()

args_yaml = yaml.safe_load(args)
data_yaml = yaml.safe_load(data)
cinder_yaml = yaml.safe_load(cinder_backends)

args_yaml['image_name'] = data_yaml['tempest_img_name']
args_yaml['flavor_name'] = data_yaml['tempest_flavors'][0]['name']
args_yaml['volume_type'] = cinder_yaml['cinder_backends'][0]['lvm']

with open('args.yaml', 'w') as outfile:
    yaml.dump(args_yaml, outfile)
