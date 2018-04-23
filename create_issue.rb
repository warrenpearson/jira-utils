#!/usr/bin/env ruby

require 'typhoeus'
require 'json'

# Simple JIRA ticket creator
class CreateIssue
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

  def create(input_file)
    url = issue_url

    headers = { 'Content-Type' => 'application/json' }

    params = File.readlines(input_file).join("\n")
    puts JSON.pretty_generate(JSON.parse(params))

    response = Typhoeus.post(url, userpwd: @credentials,
                                  body: params, headers: headers)
    handle(response)
  end

  def issue_url
    base_url = "https://#{@domain}.atlassian.net"
    issue_endpoint = '/rest/api/2/issue/'

    base_url + issue_endpoint
  end

  def handle(response)
    if response.response_code == 201
      json = JSON.parse(response.body)
      puts JSON.pretty_generate(json)
    else
      puts "Received error response status #{response.response_code}"
      puts response.body
    end
  end
end

input_file = ARGV[0]

unless input_file
  puts 'Please supply an input file'
  exit
end

CreateIssue.new.create(input_file)
