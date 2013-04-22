#
# Author::  Kevin Bridges (<kevin@cyberswat.com>)
# Cookbook Name:: drupal
# Recipe:: drush
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
drush_archive = "#{Chef::Config[:file_cache_path]}/drush-#{node[:drupal][:drush][:version]}.tar.gz"

remote_file drush_archive do
  checksum node[:drupal][:drush][:checksum]
  source "http://ftp.drupal.org/files/projects/drush-#{node[:drupal][:drush][:version]}.tar.gz"
  mode "0644"
end

directory node[:drupal][:drush][:dir] do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

execute "extract-drush" do
  cwd node[:drupal][:drush][:dir]
  command "tar --strip-components 1 -xzf #{drush_archive}"
  creates "#{node[:drupal][:drush][:dir]}/drush.php"
end

link node[:drupal][:drush][:executable] do
  to "#{node[:drupal][:drush][:dir]}/drush"
  link_type :symbolic
end