#!/usr/bin/env ruby

require 'rubygems'
require 'rubygems/dependency_installer'
Gem::DependencyInstaller.new.install('octokit', '1.19.0')
require 'octokit'

Octokit.downloads(:username => ENV['VEEWEEBOT_DEPLOY_REPO_USERNAME'], :name => ENV['VEEWEEBOT_DEPLOY_REPO_NAME']).each { |entry|
  if ENV['VEEWEEBOT_DEPLOY_FILE'] == entry.name
    client = Octokit::Client.new(:login => ENV['VEEWEEBOT_DEPLOY_OAUTH_USERNAME'], :oauth_token => ENV['VEEWEEBOT_DEPLOY_OAUTH_TOKEN'])
    client.delete_download({:username => ENV['VEEWEEBOT_DEPLOY_REPO_USERNAME'], :name => ENV['VEEWEEBOT_DEPLOY_REPO_NAME']}, entry.id)
  end
}