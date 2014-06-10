drupal-lamp
=================

A vagrant build to run a Drupal LAMP stack utilizing best practices.

Our vision is to aid the Drupal Community by removing the complexity of managing a development environment and to offer a bridge to maintain parity and best practices when going live.

Requirements
------------
There are two requirements that you need to manage before you can begin.
* You need to install virtualbox https://www.virtualbox.org/wiki/Downloads
* You need to install vagrant 1.4.3 or greater http://www.vagrantup.com/downloads.html

Installation Simple:
------------
To install drupal lamp, you must have Vagrant and Virtual box already installed.

```
cd ~/
mkdir ~/vagrant
cd vagrant
git clone git@github.com:newmediadenver/drupal-lamp.git
cd drupal-lamp
mkdir assets
vagrant plugin install vagrant-berkshelf --plugin-version '2.0.1'
vagrant plugin install vagrant-omnibus
```

***Note:*** On OSX Mavericks, run: ```sudo /Library/StartupItems/VirtualBox/VirtualBox restart```

```
vagrant up
```

During the install process. Edit ```/etc/hosts``` add the line:

```
192.168.50.5  example.local
```

Once the vagrant process is complete, visit http://example.local

To work on the files locally, you will need to set up a method of file sharing. This
is described in the below sections. *** Note:*** You will need to run ```vagrant
destroy -f && vagrant up```after changing the settings. This *WILL* destroy your
machine and work, so make sure it is versioned.

Installation Complex:
-------------
### Custom Drupal Site(s)
Drupal-lamp allows for you to easily work with multiple sites at once using pre-existing
git repos.

To start customizing your machine:

Edit: ```infrastructure/drupal_lamp.json```

Instructions: [Drupal](https://github.com/newmediadenver/drupal)

***NOTE:*** Make sure that you have a data-bag associated with the each unique site id.
See below for info about data-bags.

Once your done: ```vagrant provision```

### Other Cookbook Settings
To control the settings of other cookbooks.

Edit: ```infrastructure/drupal_lamp.json```

Each Cookbook that is in the run list found here: ```chef/roles/drupal_lamp.rb```
has associated hashes that can be manipulated and overrode through arrays in the
JSON. Look in the berksfile for those cookbooks, and the repos for those settings.

### To Add Cookbooks

Edit: ```Berksfile``` and place call your desired cookbook.
Instructions: [Berkshelf](http://berkshelf.com/)

Edit: ```chef/roles/drupal_lamp.rb```
Add the cookbook to the runlist at the bottom of the file.

Edit: ```infrastructure/drupal_lamp.json```
Add the array of data needed for the desired cookbook.


## Chef Configuration

#### Data Bags (Hash or Mash)
If you make a new or edit the existing site id in the drupal_lamp.json, you will
need to create a databag for that site with the same id as the site name. Steps to do so:

1. ```cp chef/data_bags/sites/example.json chef/data_bags/sites/[site_name].json```
1. Now edit the [site_name].json and change id of the site id.
1. Edit the info for your site.

## Vagrant Configuration

### Create a file share

#### Drupal-NFS (Set up a NFS share on the VM, mount it on your local machine)
This is the speediest option and is compatible with any system that can mount
NFS shares.

see [Drupal-NFS cookbook](https://github.com/arknoll/drupal-nfs)

#### Vagrant-provided nfs (Vagrant sets up a NFS share on your local machine, then mounts it on the VM.)
see [NFS in Vagrant Docs](https://docs.vagrantup.com/v2/synced-folders/nfs.html)

1. Get required prerequisits (see Vagrant Doc)
2. Add code/uncomment in Vagrantfile
````
# for Vagrant nfs support
config.nfs.map_uid = 0
config.nfs.map_gid = 0

...
# for Vagrant nfs support
# Ensure the second parameter (/assets) is the same as the Default['drupal']['server']['assets']
# destination in your drupal_lamp.json file
server.vm.synced_folder "assets", "/assets", :nfs => true
````
Vagrant reload

#### Vagrant synced folders (slower - Vagrant sets up a virtualbox share on your local machine, then mounts it on the VM.)
see [Synced folders in Vagrant Docs](https://docs.vagrantup.com/v2/synced-folders/basic_usage.html)
Add code/uncomment in Vagrantfile
````
# For Vagrant synced folders
# Ensure the second parameter (/assets) is the same as the Default['drupal']['server']['assets']
# destination in your drupal_lamp.json file
server.vm.synced_folder "assets", "/assets", :nfs => false, :owner => "www-data", :group => "www-data"
````


Known "plug-ins" for drupal-lamp
--------------------------------
## Typical plug-in usage
1. Add the cookbook to the Berksfile
2. Add the role to the chef/roles/drupal_lamp.rb
3. Modify any attributes in your drupal_lamp.json if necessary

### Drupal-NFS
Allows you to expose and configure NFS shares on the VM.
see [Drupal-NFS cookbook](https://github.com/arknoll/drupal-nfs)

### Drupal-solr
Installs Apache Solr on your virtual machine.
see [Drupal solr cookbook](http://github.com/arknoll/drupal)

### Drupal-codeception
Installs [Codeception](http://codeception.com/) testing framework on your virtual machine.
see [Drupal codeception cookbook](http://github.com/arknoll/drupal-codeception)

### Drupal-frontend
Adds CSS Preprocessing on spin up. More coolness to come.
See [Drupal Frontend](http://github.com/timodwhit/drupal-frontend)

### Create a self-signed ssl certificate
See wiki [SSL in a dev environment](https://github.com/newmediadenver/drupal-lamp/wiki/SSL-in-a-dev-environment)


Contributing
------------

We welcome contributed improvements and bug fixes via this workflow:

1. Fork this repository
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new pull request


If you would like a deeper understanding to utilize this project as a regular tool for individuals or teams, [you should help in the wiki](https://github.com/newmediadenver/drupal-lamp/wiki/_pages), [or simply provide feedback in the issue queue](https://github.com/newmediadenver/drupal-lamp/issues).
## Why are you doing this? ##
There's a big, complex problem that is instantly born when someone has the thought "I need to spin up a new drupal site."  Personally, I'm tired of having to spend any time thinking about how to do that. The conversation is relevant and it is gaining momentum. Send new conversations that should be listed here to [@cyberswat](https://twitter.com/cyberswat)

* https://groups.drupal.org/node/314508#comment-958458
* http://www.mediacurrent.com/blog/better-local-development-vagrant
* https://github.com/proviso/proviso
* https://github.com/Automattic/vip-quickstart
