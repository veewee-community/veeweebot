#!/usr/bin/env ruby

require 'rubygems'
system('gem install octokit 1.19.0')
Gem.clear_paths
require 'octokit'

puts Octokit.downloads(:username => ENV['VEEWEEBOT_DEPLOY_REPO_USERNAME'], :name => ENV['VEEWEEBOT_DEPLOY_REPO_NAME'])

puts 'start'
puts ENV['VEEWEEBOT_DEPLOY_FILE']
puts ENV['VEEWEEBOT_DEPLOY_REPO_USERNAME']
puts ENV['VEEWEEBOT_DEPLOY_REPO_NAME']
puts ENV['VEEWEEBOT_DEPLOY_OAUTH_USERNAME']
puts ENV['VEEWEEBOT_DEPLOY_OAUTH_TOKEN']
puts 'end'