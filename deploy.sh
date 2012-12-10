#!/usr/bin/env ruby

system('gem install octokit 1.19.0')
Gem.clear_paths
require 'octokit'

puts Octokit.downloads(ENV['VEEWEEBOT_DEPLOY_REPO_URL'])

puts 'start'
puts ENV['VEEWEEBOT_DEPLOY_REPO_URL']
puts ENV['VEEWEEBOT_DEPLOY_FILE']
puts ENV['VEEWEEBOT_DEPLOY_OAUTH_USERNAME']
puts ENV['VEEWEEBOT_DEPLOY_OAUTH_TOKEN']
puts 'end'