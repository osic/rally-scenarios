#!/bin/bash

source /openrc

# first update the rally files in our workspace
# sed -i "s/{{IP}}/$IP/g"                   $WORKSPACE/existing.json
# sed -i "s/{{USER}}/$USER/g"               $WORKSPACE/existing.json
# sed -i "s/{{PASSWORD}}/$PASSWORD/g"       $WORKSPACE/existing.json
# sed -i "s/{{TENANT}}/$TENANT/g"           $WORKSPACE/existing.json
# sed -i "s|{{RALLY_PRIME_TASK}}|$RALLY_PRIME_TASK|g"   $WORKSPACE/run_rally.sh
# sed -i "s|{{RALLY_PRIME_PARMS}}|$RALLY_PRIME_PARMS|g" $WORKSPACE/run_rally.sh
# sed -i "s|{{RALLY_TASK}}|$RALLY_TASK|g"   $WORKSPACE/run_rally.sh
# sed -i "s|{{RALLY_PARMS}}|$RALLY_PARMS|g" $WORKSPACE/run_rally.sh

# next send them up to the rally box
scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $WORKSPACE/existing.json $RALLY_USER@$RALLY_IP:/home/rally/
scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $WORKSPACE/run_rally.sh $RALLY_USER@$RALLY_IP:/home/rally/
scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $WORKSPACE/$RALLY_TASK $RALLY_USER@$RALLY_IP:/home/rally/
scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $WORKSPACE/$RALLY_PRIME_TASK $RALLY_USER@$RALLY_IP:/home/rally/

# run the script - this runs the tests themselves
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $RALLY_USER@$RALLY_IP "chmod +x run_rally.sh; ./run_rally.sh > out 2> err" 

# get the result files and put them into our workspace
scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $RALLY_USER@$RALLY_IP:/home/rally/results.json $WORKSPACE/
scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $RALLY_USER@$RALLY_IP:/home/rally/results.html $WORKSPACE/
scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $RALLY_USER@$RALLY_IP:/home/rally/results.xml $WORKSPACE/
scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $RALLY_USER@$RALLY_IP:/home/rally/rally-console.out $WORKSPACE/


scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $RALLY_USER@$RALLY_IP:/home/rally/prime-results.json $WORKSPACE/
scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $RALLY_USER@$RALLY_IP:/home/rally/prime-results.html $WORKSPACE/
scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $RALLY_USER@$RALLY_IP:/home/rally/prime-results.xml $WORKSPACE/
scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $RALLY_USER@$RALLY_IP:/home/rally/prime-rally-console.out $WORKSPACE/

# delete any leftover logs from previous runs
for file in `ls logs.*` ; do
    if [ -f $file ] ; then
        rm $file
    fi
done

# get the logs from openstack & rally compressed
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@$IP 'tar -chf logs.tar `find /opt/stack/new/ | egrep *.log$`'
scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@$IP:logs.tar .
tar -rf logs.tar $WORKSPACE/results.json
tar -rf logs.tar $WORKSPACE/rally-console.out
gzip logs.tar

# upload logs to files
file_name="rally_"$(date +"%Y-%m-%d_%H-%M-%S")".tar.gz"
rack files object upload --container logs --name $file_name --file logs.tar.gz --delete-after 2592000
temp_url=$(python temp_url.py $file_name)
echo $temp_url

# parse the logs and upload them to ElasticSearch
scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $WORKSPACE/results.json root@104.239.149.33:~
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@104.239.149.33 "cat results.json | elastic-benchmark -e devstack -l $temp_url"
