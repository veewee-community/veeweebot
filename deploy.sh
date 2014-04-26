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
=======
require 'digest/sha1'
Gem::DependencyInstaller.new.install('google-api-client', '0.5.0')
require 'google/api_client'



# inputs
FILE =            ENV['VEEWEEBOT_DEPLOY_FILE']
FOLDER =          ENV['VEEWEEBOT_DEPLOY_FOLDER'] || 'boxes'
CONTENT_TYPE =    ENV['VEEWEEBOT_DEPLOY_FILE_CONTENT_TYPE'] || 'application/octet-stream'
BUILD_TIMESTAMP = ENV['VEEWEEBOT_DEPLOY_BUILD_TIMESTAMP'] || Time.now()
BUILD_URL =       ENV['VEEWEEBOT_DEPLOY_BUILD_URL'] || "http://travis-ci.org/#{Dir.pwd.split(File::SEPARATOR)[-2]}/#{Dir.pwd.split(File::SEPARATOR)[-1]}/builds/#{ENV['TRAVIS_BUILD_ID']}"
CLIENT_SECRET =   ENV['VEEWEEBOT_GOOGLE_CLIENT_SECRET']
REFRESH_TOKEN =   ENV['VEEWEEBOT_GOOGLE_REFRESH_TOKEN']


# non-configurable inputs
CLIENT_ID = '1082146764076.apps.googleusercontent.com'
ACCESS_TOKEN = 'nonempty_so_the_library_wont_complain'
SCOPE = 'https://www.googleapis.com/auth/drive.file'


client = Google::APIClient.new
drive = client.discovered_api('drive', 'v2')

client.authorization.client_id = CLIENT_ID
client.authorization.client_secret = CLIENT_SECRET
client.authorization.scope = SCOPE
client.authorization.refresh_token = REFRESH_TOKEN
client.authorization.access_token = ACCESS_TOKEN


def get_id_of_existing_folder(client, drive)
  folder_id = nil
  api_method = drive.children.list
  puts "#{__method__}:#{api_method.id}"
  result = client.execute(
    # https://developers.google.com/drive/v2/reference/files/list
    :api_method => api_method,
    :parameters => {
      :folderId => 'root',
      # don't know why can't use '=' for matching title
      # don't know why can't use ('anyone' in readers)
      :q => "(title contains '#{FOLDER}') and (mimeType = 'application/vnd.google-apps.folder') and (trashed = false)"
    }
  )
  # jj result.data.to_hash
  if result.status.between?(200, 299)
    items = result.data['items']
    if (!items.empty?)
      folder_id = items.fetch(0, nil)['id']
    end
  else
    raise
  end
  folder_id
end

def create_folder(client, drive)
  folder_id = nil
  folder = drive.files.insert.request_schema.new({
    :title => FOLDER,
    :description => 'This folder was created by veeweebot.',
    :mimeType => 'application/vnd.google-apps.folder'
  })
  api_method = drive.files.insert
  puts "#{__method__}:#{api_method.id}"
  result = client.execute(
    # https://developers.google.com/drive/v2/reference/files/insert
    :api_method => api_method,
    :body_object => folder
  )
  # jj result.data.to_hash
  if result.status.between?(200, 299)
    folder_id = result.data['id']
  else
    raise
  end
  # https://developers.google.com/drive/publish-site
  permission = drive.permissions.insert.request_schema.new({
    'value' => '',
    'type' => 'anyone',
    'role' => 'reader'
  })
  api_method = drive.permissions.insert
  puts "#{__method__}:#{api_method.id}"
  result = client.execute(
    # https://developers.google.com/drive/v2/reference/permissions/insert
    :api_method => api_method,
    :body_object => permission,
    :parameters => {
      'fileId' => folder_id
    }
  )
  # jj result.data.to_hash
  if !result.status.between?(200, 299)
    raise
  end
  folder_id
end

def get_id_of_existing_file(client, drive, folder_id)
  file_id = nil
  api_method = drive.children.list
  puts "#{__method__}:#{api_method.id}"
  result = client.execute(
    # https://developers.google.com/drive/v2/reference/files/list
    :api_method => api_method,
    :parameters => {
      :folderId => folder_id,
      # don't know why can't use '=' for matching title
      :q => "(title contains '#{FILE}') and (trashed = false)"
    }
  )
  # jj result.data.to_hash
  if result.status.between?(200, 299)
    items = result.data['items']
    if (!items.empty?)
      file_id = items.fetch(0, nil)['id']
    end
  else
    raise
  end
  file_id
end

def delete_file(client, drive, file_id)
  api_method = drive.files.delete
  puts "#{__method__}:#{api_method.id}"
  result = client.execute(
    # https://developers.google.com/drive/v2/reference/files/delete
    :api_method => api_method,
    :parameters => {
      :fileId => file_id,
    }
  )
  # puts "result.status=#{result.status}"
  if !result.status.between?(200, 299)
    raise
  end
end

def get_file_description()
  sha1 = Digest::SHA1.new
  File.open(FILE, 'r') do |file|
    while buffer = file.read(1024)
      sha1.update(buffer)
    end
  end
  description = "Build URL: #{BUILD_URL} - SHA1: #{sha1} - Build Timestamp: #{BUILD_TIMESTAMP}"
end

def upload_file(client, drive, folder_id, file_description)
  file = drive.files.insert.request_schema.new({
    'title' => FILE,
    'description' => file_description,
    'mimeType' => CONTENT_TYPE,
    'parents' => [
      { :id => folder_id }
    ]
  })
  media = Google::APIClient::UploadIO.new(FILE, CONTENT_TYPE)
  api_method = drive.files.insert
  puts "#{__method__}:#{api_method.id}"
  result = client.execute(
    # https://developers.google.com/drive/v2/reference/files/insert
    :api_method => api_method,
    :body_object => file,
    :media => media,
    :parameters => {
      'uploadType' => 'multipart',
      'alt' => 'json'
  })
  # jj result.data.to_hash
  if !result.status.between?(200, 299)
    raise
  end
end



folder_id = get_id_of_existing_folder(client, drive)
if (folder_id.nil?)
  folder_id = create_folder(client, drive)
end

preexisting_file_id = get_id_of_existing_file(client, drive, folder_id)
if (!preexisting_file_id.nil?)
  delete_file(client, drive, preexisting_file_id)
end

file_description = get_file_description()
upload_file(client, drive, folder_id, file_description)