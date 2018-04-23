#!/bin/bash

username=$JIRA_USER
password=$JIRA_PASS
domain=$JIRA_DOMAIN
assignee=''

# Simple test that your credentials are ok.
curl -w "\n" -s -u ${username}:${password} -X GET -H "Content-Type: application/json" https://${domain}.atlassian.net/rest/api/2/search?jql=assignee=${assignee} | jq .[]
