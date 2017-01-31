import yaml
import json

with open('/etc/ansible/roles/os_tempest/defaults/main.yml') as f:
  data = f.read()
with open('args.yaml') as f:
  args = f.read()
with open('existing.json') as f:
  existing = f.read()
with open('/root/openrc') as f:
  creds = f.read().splitlines()

args_yaml = yaml.safe_load(args)
data_yaml = yaml.safe_load(data)
existing_json = json.loads(existing)

authentication = []
authentication.append(creds)

args_yaml['image_name'] = data_yaml['tempest_img_name']
args_yaml['flavor_name'] = data_yaml['tempest_flavors'][0]['name']
existing_json['auth_url'] = authentication[0][16]
existing_json['username'] = authentication[0][12]
existing_json['password'] = authentication[0][13]
existing_json['tenant_name'] = authentication[0][15]
existing_json['region_name'] = authentication[0][20]

with open('args.yaml', 'w') as outfile:
    yaml.dump(args_yaml, outfile)
for p in authentication:
  print p

print existing_json['username']
print existing_json['password']
print existing_json['tenant_name']
print existing_json['region_name']
print existing_json['auth_url']

