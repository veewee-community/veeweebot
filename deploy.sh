#!/usr/bin/env ruby

require 'rubygems'
require 'rubygems/dependency_installer'
Gem::DependencyInstaller.new.install(:name => 'octokit', :version => '1.19.0')
require 'octokit'

puts Octokit.downloads(:username => ENV['VEEWEEBOT_DEPLOY_REPO_USERNAME'], :name => ENV['VEEWEEBOT_DEPLOY_REPO_NAME'])

puts 'start'
puts ENV['VEEWEEBOT_DEPLOY_FILE']
puts ENV['VEEWEEBOT_DEPLOY_REPO_USERNAME']
puts ENV['VEEWEEBOT_DEPLOY_REPO_NAME']
puts ENV['VEEWEEBOT_DEPLOY_OAUTH_USERNAME']
puts ENV['VEEWEEBOT_DEPLOY_OAUTH_TOKEN']
puts 'end'