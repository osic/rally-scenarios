import yaml
import json

with open('/etc/ansible/roles/os_tempest/defaults/main.yml') as f:
  data = f.read()
with open('args.yaml') as f:
  args = f.read()

args_yaml = yaml.safe_load(args)
data_yaml = yaml.safe_load(data)

args_yaml['image_name'] = data_yaml['tempest_img_name']
args_yaml['flavor_name'] = data_yaml['tempest_flavors'][0]['name']

with open('args.yaml', 'w') as outfile:
    yaml.dump(args_yaml, outfile)
