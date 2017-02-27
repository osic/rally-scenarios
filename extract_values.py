import yaml
import json
import ConfigParser

with open('args.yaml') as f:
  args = f.read()
  
config = ConfigParser.ConfigParser()
config.read('/root/etc/tempest.conf')
config.sections()
  
args_yaml = yaml.safe_load(args)
data = config.get('image', 'http_image')
flavor = config.get('orchestration', 'instance_type')

args_yaml['image_name'] = data[16:22]
args_yaml['flavor_name'] = flavor

args_yaml['volume_type'] = "lvm"
  
with open('args.yaml', 'w') as outfile:
    yaml.dump(args_yaml, outfile)
