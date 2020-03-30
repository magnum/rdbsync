#!/usr/bin/ruby
require 'yaml'
require 'net/ftp'
require "net/http"
require 'json'

working_dir = Dir.pwd
DUMP_FILENAME = "rdbsync.sql"
SCRIPT_FILENAME = "rdbsync.php"
CONFIG_PATH = File.join(working_dir, "rdbsync.yml")
CONFIG = YAML::load(File.open(CONFIG_PATH), symbolize_names: true)[:config]


def string_merge_params(string, params)
  params.merge!({
    dump_filename: DUMP_FILENAME,
    script_filename: SCRIPT_FILENAME,
    mysql_password_option: (params[:password] ? "-p#{params[:password]}" : "") 
  })
  params.keys.each{|k| string.gsub!(":#{k}", params[k].to_s)}
  string
end


def ftp_run
  config_ftp = CONFIG[:remote][:ftp]
  begin
    ftp = Net::FTP.new(config_ftp[:host])
    ftp.login config_ftp[:username], config_ftp[:password]
    ftp.chdir(config_ftp[:dir])
    ftp.put File.join(File.expand_path(File.dirname(__FILE__)), SCRIPT_FILENAME)
    yield(ftp) if block_given? # run &block in ftp context
    ftp.delete SCRIPT_FILENAME
    ftp.delete DUMP_FILENAME
    ftp.close
  rescue StandardError => e
    puts "FTP ERROR: #{e.message}"
  end
end


def remote_action_url(action)
  path = string_merge_params(
    ":script_filename?action=#{action}&host=:host&username=:username&password=:password&name=:name",
    CONFIG[:remote][:db]
  )
  File.join  CONFIG[:remote][:url], path
end


def pull
  ftp_run do |f|
    remote_url = remote_action_url("remote_export")
    result = JSON.parse(Net::HTTP.get(URI.parse(remote_url)))
    puts result
    f.getbinaryfile(DUMP_FILENAME);
    print "import LOCAL? [y/n]:"
    local_import if gets.chomp == "y"
  end
end


def push
  local_export
  print "import REMOTE? [y/n]:"
  ftp_run do |f|
    f.putbinaryfile(DUMP_FILENAME);
    remote_url = remote_action_url("remote_import")
    result = JSON.parse(Net::HTTP.get(URI.parse(remote_url)))
    puts result
  end if gets.chomp == "y"
end


def local_import
  command = string_merge_params("mysql -h :host -u :username :mysql_password_option :name < :dump_filename", CONFIG[:local][:db])
  result = %x[ #{command} ]
  puts "LOCAL - IMPORT #{CONFIG[:local][:db][:name]}"
end


def local_export
  command = string_merge_params("(mysqldump -h :host -u :username :mysql_password_option :name > :dump_filename) 2>&1", CONFIG[:local][:db])
  result = %x[ #{command} ]
  puts "LOCAL - EXPORT #{CONFIG[:local][:db][:name]}"
end


puts "usage: ruby rdbsync.rb [push|pull]" if ARGV.length == 0
send(ARGV.shift) if ARGV.length > 0 && defined?(ARGV[0])

