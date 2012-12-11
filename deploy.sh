#!/usr/bin/env ruby

require 'rubygems'
require 'rubygems/dependency_installer'
require 'digest/sha1'
Gem::DependencyInstaller.new.install('octokit', '1.19.0')
require 'octokit'

repo = {:username => ENV['VEEWEEBOT_DEPLOY_REPO_USERNAME'], :name => ENV['VEEWEEBOT_DEPLOY_REPO_NAME']}
# file must be in cwd - reevaluate this aspect
FILE = ENV['VEEWEEBOT_DEPLOY_FILE']
CONTENT_TYPE = ENV['VEEWEEBOT_DEPLOY_FILE_CONTENT_TYPE']
BUILD_TIMESTAMP = ENV['VEEWEEBOT_DEPLOY_BUILD_TIMESTAMP']
BUILD_URL = ENV['VEEWEEBOT_DEPLOY_BUILD_URL']
# remember: if you get 404 errors using the client, check for cred values and also make sure the user is allowed to write to the repo
client = Octokit::Client.new(:username => ENV['VEEWEEBOT_DEPLOY_OAUTH_USERNAME'], :oauth_token => ENV['VEEWEEBOT_DEPLOY_OAUTH_TOKEN'])


client.downloads(repo).each { |entry|
  if FILE == entry.name
    puts "deleting download: #{entry.name} (#{entry.description}) ..."
    client.delete_download(repo, entry.id)
  end
}

# TODO: fill in these fields with real values
sha1 = Digest::SHA1.new
File.open(FILE, 'r') do |file|
  while buffer = file.read(1024)
    sha1.update(buffer)
  end
end
description = "SHA1: #{sha1} - Build Timestamp: #{BUILD_TIMESTAMP} - Build URL: #{BUILD_URL}"
options = {:description => description, :content_type => CONTENT_TYPE}

puts "creating download: #{FILE} (#{options[:description]}) ..."
client.create_download(repo, FILE, options)