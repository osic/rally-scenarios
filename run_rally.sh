#!/bin/bash
. /home/rally/rally/bin/activate
echo "Initialize Rally database"
rally-manage db recreate
echo "Create a Rally deployment"
rally deployment create --file=existing.json --name=existing
echo "Start the Rally prime task"
rally -vd task start {{RALLY_PRIME_TASK}} {{RALLY_PRIME_PARMS}} > rally-prime-console.out 2>&1
rally task report --junit --out prime-results.xml
rally task report --html-static --out prime-results.html
rally task results > prime-results.json

echo "Start the Rally task"
rally -vd task start {{RALLY_TASK}} {{RALLY_PARMS}} > rally-console.out 2>&1
rally task report --junit --out results.xml
rally task report --html-static --out results.html
rally task results > results.json
