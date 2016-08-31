#!/bin/bash
echo "Initialize Rally database"
rally-manage db recreate
echo "Create a Rally deployment"
rally deployment create --file=existing.json --name=existing
echo "Start the Rally task"
rally -vd task start {{RALLY_TASK}} {{RALLY_PARMS}} > rally-console.out 2>&1
rally task report --junit --out results.xml
rally task report --html-static --out results.html
rally task results > results.json
