#!/usr/bin/env ruby

require 'typhoeus'
require 'json'

# Simple JIRA ticket retriever
class GetIssue
  def initialize
    user = ENV['JIRA_USER']
    pass = ENV['JIRA_PASS']
    @domain = ENV['JIRA_DOMAIN']

    unless user && pass
      puts 'User and password must be set'
      exit
    end

    @credentials = "#{user}:#{pass}"
  end

  def get(ticket)
    url = issue_url(ticket)

    response = Typhoeus.get(url, userpwd: @credentials)
    handle(response)
  end

  def issue_url(ticket)
    base_url = "https://#{@domain}.atlassian.net"
    issue_endpoint = '/rest/api/2/issue/'

    base_url + issue_endpoint + ticket + '/transitions'
  end

  def handle(response)
    if response.response_code == 200
      json = JSON.parse(response.body)
      puts JSON.pretty_generate(json)
    else
      puts "Received error response status #{response.response_code}"
      puts response.body
    end
  end
end

ticket = ARGV[0]

unless ticket
  puts 'Please supply a ticket id'
  exit
end

GetIssue.new.get(ticket)
