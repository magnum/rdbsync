#!/usr/bin/ruby
require 'yaml'
require 'net/ftp'
require "net/http"
require 'json'

working_dir = Dir.pwd
DUMP_FILENAME = "rdbsync.sql"
SCRIPT_FILENAME = "rdbsync.php"
SCRIPT_PATH = File.expand_path(File.dirname(__FILE__))
CONFIG_PATH = File.join(working_dir, "rdbsync.yml")
CONFIG = YAML::load(File.open(CONFIG_PATH), symbolize_names: true)[:config]


def ftp
  config_ftp = CONFIG[:remote][:ftp]
  ftp = Net::FTP.new(config_ftp[:host])
  ftp.login config_ftp[:username], config_ftp[:password]
  ftp.chdir(config_ftp[:dir])
  yield(ftp) if block_given?
  ftp.close
end


def get
  php_script_path = File.join(SCRIPT_PATH, SCRIPT_FILENAME)
  ftp do |f|
    f.put php_script_path
    config_remote = CONFIG[:remote]
    remote_url = File.join(config_remote[:url], "#{SCRIPT_FILENAME}?action=get&host=#{config_remote[:db][:host]}&username=#{config_remote[:db][:username]}&password=#{config_remote[:db][:password]}&db=#{config_remote[:db][:name]}")
    result = JSON.parse(Net::HTTP.get(URI.parse(remote_url)))
    puts result
    f.getbinaryfile(DUMP_FILENAME);
    puts "exported #{config_remote[:db][:name]} in #{DUMP_FILENAME}"
    f.delete SCRIPT_FILENAME
    f.delete DUMP_FILENAME
     
    print "import locally? [y/n]:"
    local_import if gets.chomp == "y"
  end
end


def local_import
  config_local = CONFIG[:local]
  import_command = "mysql -h #{config_local[:db][:host]} -u #{config_local[:db][:username]} #{config_local[:db][:password] ? "" : "-p#{config_local[:db][:password]}"} #{config_local[:db][:name]} < #{DUMP_FILENAME}"
  import_result = %x[ #{import_command} ]
  puts "impoted into db #{config_local[:db][:name]}"
end


get
