drupal-lamp
=================

A vagrant build to run a Drupal LAMP stack utilizing best practices.

Our vision is to aid the Drupal Community by removing the complexity of managing a development environment and to offer a bridge to maintain parity and best practices when going live.  [Interact with the roadmap](https://github.com/newmediadenver/drupal-lamp/issues/milestones) to help direct this project.

Requirements
------------
There are two requirements that you need to manage before you can begin.
* You need to install virtualbox https://www.virtualbox.org/wiki/Downloads
* You need to install vagrant 1.4.0 or greater http://www.vagrantup.com/downloads.html

Installation
------------
To install drupal lamp, you must have Vagrant and Virtual box already installed.

```
cd ~/
mkdir ~/vagrant
cd vagrant
git clone git@github.com:newmediadenver/drupal-lamp.git
cd drupal-lamp
mkdir assets
vagrant install plugin vagrant-berkshelf
```
*Note:* If you are on Mavericks, you will need to run: ```sudo /Library/StartupItems/VirtualBox/VirtualBox restart``` to get up and running.

Now, you will have all the proper folders and files in place to run drupal lamp
as an example site. However, what fun is that?!

To customize drupal-lamp to use you specific site, you will need to edit the file
located at ```infrastructure/drupal_lamp.json```. See Below for the details on configuration
of sites.

Once you have updated the json, you will run the command:

```
vagrant up
```

The command will provision the machine and have you up and running in relatively no
time.


Configuration
-------------
### drupal_lamp.json

AKA, One File to Rule them all (kinda). This file houses the configuration for the
cookbooks used in this vagrant-chef pairing. For each top level hash (drupal, php, mysql, etc),
there is a corresponding cookbook for that site. For all the options available to set,
see that cookbooks repo. ** If you are curious where a cookbook comes from, look in the
berksfile **

### Drupal
see [Drupal chef cookbook](http://github.com/newmediadenver/drupal)

### Create a file share

#### Vagrant nfs
see [NFS in Vagrant Docs](https://docs.vagrantup.com/v2/synced-folders/nfs.html)

1. Get required prerequisits (see Vagrant Doc)
2. Add code/uncomment in Vagrantfile
````
# for Vagrant nfs support
config.nfs.map_uid = :auto
config.nfs.map_gid = :auto

...
# for Vagrant nfs support
# Ensure the second parameter (/assets) is the same as the Default['drupal']['server']['assets']
# destination in your drupal_lamp.json file
server.vm.synced_folder "assets", "/assets", :nfs => true
````
Vagrant reload

#### Vagrant synced folders (slower)
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

### Drupal-solr
Installs Apache Solr on your virtual machine.
see [Drupal solr cookbook](http://github.com/arknoll/drupal)

### Drupal-codeception
Installs [Codeception](http://codeception.com/) testing framework on your virtual machine.
see [Drupal codeception cookbook](http://github.com/arknoll/drupal-codeception)


Contributing
------------

We welcome contributed improvements and bug fixes via the usual workflow:

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
