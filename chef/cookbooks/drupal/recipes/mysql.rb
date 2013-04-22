#
# Author::  Kevin Bridges (<kevin@cyberswat.com>)
# Cookbook Name:: drupal
# Recipe:: mysql
#
# Copyright 2013, Cyberswat Industries, LLC.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
passwords = data_bag_item('users', 'mysql')[node.chef_environment]
node.set['mysql']['server_root_password'] = passwords["root"]
node.set['mysql']['server_repl_password'] = passwords["replication"]
node.set['mysql']['server_debian_password'] = passwords["debian"]

include_recipe "mysql::server"
include_recipe "mysql::client"
include_recipe "database"
include_recipe "database::mysql"

mysql_connection_info = {
  :host => "localhost",
  :username => "root",
  :password => node["mysql"]["server_root_password"]
}

mysql_database node['drupal']['site']['dbname'] do
  connection mysql_connection_info
  action :create
end

drupal_user = data_bag_item('users', 'drupal')[node.chef_environment]

['%', 'localhost'].each do |host_name|
  mysql_database_user drupal_user['dbuser'] do
    connection mysql_connection_info
    password drupal_user['dbpass']
    database_name node['drupal']['site']['dbname']
    host host_name
    privileges [:select,:insert,:update,:delete,:create,:drop,:index,:alter,:'lock tables',:'create temporary tables']
    action :grant
  end
end
