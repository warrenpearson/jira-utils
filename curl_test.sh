#!/bin/bash

# Simple test that your credentials are ok.
curl -u <username>:<password> -X GET -H "Content-Type: application/json" https://<companyname>.atlassian.net/rest/api/2/search?jql=assignee=<username>
