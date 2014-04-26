#!/usr/bin/env ruby

require 'rubygems'
require 'rubygems/dependency_installer'
Gem::DependencyInstaller.new.install('octokit', '1.19.0')
require 'octokit'

Octokit.downloads(:username => ENV['VEEWEEBOT_DEPLOY_REPO_USERNAME'], :name => ENV['VEEWEEBOT_DEPLOY_REPO_NAME']).each { |key, value]
  puts "key = #{key}"
  puts "value = #{value}"
}

puts 'start'
puts ENV['VEEWEEBOT_DEPLOY_FILE']
puts ENV['VEEWEEBOT_DEPLOY_REPO_USERNAME']
puts ENV['VEEWEEBOT_DEPLOY_REPO_NAME']
puts ENV['VEEWEEBOT_DEPLOY_OAUTH_USERNAME']
puts ENV['VEEWEEBOT_DEPLOY_OAUTH_TOKEN']
puts 'end'