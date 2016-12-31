#!/usr/bin/env ruby

require 'typhoeus'
require 'json'

# Simple JIRA metadata getter
class GetMetadata
  def initialize
    user = ENV['JIRA_USER']
    pass = ENV['JIRA_PASS']

    unless user && pass
      puts 'User and password must be set'
      exit
    end

    @credentials = "#{user}:#{pass}"
  end

  def meta_data
    url = meta_url

    response = Typhoeus.get(url, userpwd: @credentials)
    json = JSON.parse(response.body)

    puts JSON.pretty_generate(json)
  end

  def meta_url
    base_url = 'https://<companyname>.atlassian.net'
    meta_endpoint = '/rest/api/2/issue/createmeta'

    base_url + meta_endpoint
  end
end

GetMetadata.new.meta_data
