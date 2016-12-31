#!/usr/bin/env ruby

require 'typhoeus'
require 'json'

# Simple JIRA ticket deleter
class DeleteIssue
  def initialize
    user = ENV['JIRA_USER']
    pass = ENV['JIRA_PASS']

    unless user && pass
      puts 'User and password must be set'
      exit
    end

    @credentials = "#{user}:#{pass}"
  end

  def delete(ticket)
    url = issue_url(ticket)

    response = Typhoeus.delete(url, userpwd: @credentials)
    handle(response)
  end

  def issue_url(ticket)
    base_url = 'https://<companyname>.atlassian.net'
    issue_endpoint = '/rest/api/2/issue/'

    base_url + issue_endpoint + ticket
  end

  def handle(response)
    if response.response_code == 204
      puts 'Succesfully deleted'
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

DeleteIssue.new.delete(ticket)
