#!/usr/bin/env ruby

require 'typhoeus'
require 'json'

# Simple JIRA ticket updater
class ArchiveTicket
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

  def archive(issue_id)
    url = issue_url(issue_id)
    input_file = './archive_ticket.json'

    headers = { 'Content-Type' => 'application/json' }

    params = File.readlines(input_file).join("\n")
    puts JSON.pretty_generate(JSON.parse(params))

    response = Typhoeus.post(url, userpwd: @credentials,
                                  body: params, headers: headers)
    handle(response)
  end

  def issue_url(issue_id)
    base_url = "https://#{@domain}.atlassian.net"
    issue_endpoint = '/rest/api/2/issue/'

    base_url + issue_endpoint + issue_id + '/transitions'
  end

  def handle(response)
    if response.response_code == 201 
      json = JSON.parse(response.body)
      puts JSON.pretty_generate(json)
    else
      puts "Received response status #{response.response_code}"
      puts response.body
    end
  end
end

issue_id = ARGV[0]

unless issue_id
  puts 'Please supply an issue id'
  exit
end

ArchiveTicket.new.archive(issue_id)
