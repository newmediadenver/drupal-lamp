#
# Author::  Kevin Bridges (<kevin@cyberswat.com>)
# Cookbook Name:: drupal
# Recipe:: default
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
directory node[:drupal][:server][:base] do
  owner node[:drupal][:server][:web_user]
  group node[:drupal][:server][:web_group]
  mode 00755
  action :create
  recursive true
end

directory node[:drupal][:server][:files] do
  owner node[:drupal][:server][:web_user]
  group node[:drupal][:server][:web_group]
  mode 00755
  action :create
  recursive true
end

deploy node[:drupal][:server][:base] do
  repository node[:drupal][:site][:repository]
  revision node[:drupal][:site][:revision]
  keep_releases node[:drupal][:site][:releases]

  before_migrate do
    link "#{release_path}/sites/default/files" do
      to node[:drupal][:server][:files]
      link_type :symbolic
    end
  end

  before_restart do
    drupal_user = data_bag_item('users', 'drupal')[node.chef_environment]

    execute "drush-site-install" do
      cwd "#{node[:drupal][:server][:base]}/current"
      command <<-EOF
        drush -y site-install --clean-url=1 --db-url=mysql://#{drupal_user['dbuser']}:#{drupal_user['dbpass']}@localhost/#{node['drupal']['site']['dbname']} --account-name=#{drupal_user['admin_user']} --account-pass=#{drupal_user['admin_pass']}
        touch "#{node[:drupal][:server][:base]}/drupal.installed"
        EOF
      not_if { ::File.exists?("#{node[:drupal][:server][:base]}/drupal.installed") }
    end

  end

restart_command "drush updb"

  symlink_before_migrate.clear
  create_dirs_before_symlink.clear
  purge_before_symlink.clear
  symlinks.clear
end
