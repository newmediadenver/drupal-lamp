# drupal-lamp #

A vagrant build to run a Drupal development LAMP stack on a vmware or virtualbox provider.

Starting with a vanilla drupal core install on an ubuntu box. The goal is to easily plug in the repos and databases of projects you may be working on.  Unlike other vagrant builds for Drupal this one focuses on being the basis for team developmet in addition to being a launch point for production level deployment strategies.

## Features ##

The feature list is relatively specific to a Drupal workflow. There are host of customizations that are available via the Chef Recipes that are not listed here.

  * Uses Chef as a provisioner.
  * Uses the deploy resource to provide production level deployments.
  * Geared to work with Drupal
  * Provides functionality to work with multiple Drupal sites on the same VM.
  * Provides mounts to access Drupal code, files and databases from the local developers machine.
  * Customizable per-site files location.
  * Customizable per-site settings.php location.
  * Customizable git upstream providers.  This will work with public and private repositories regardless of where they are hosted.
  * Customizable branch targets for deployment.
  * Customizable drupal site profile can be selected per-site.
  * Completely customizable `drush site-install` invocation.

## Requirements ##

This approach has been tested on OSX 10.8.3 in addition to the desktop version of Ubuntu 64 12.10. Please download and install the suggested versions vs relying on package managers. Ubuntu, in particular, has a fair amount of old code in their repositories that will lead to your inability to use this software.

I'm listing virtualbox in this list only because a fair number of people use it. I don't like the software and their latest version, as of this writing, has introduced a issues to using vagrant.  Stay away from Oracle code imo and use vmware.

  * Vagrant 1.2.2 http://downloads.vagrantup.com/
  * Virtualbox 4.2.10 https://www.virtualbox.org/wiki/Download_Old_Builds
or
  * VMware fusion 5.0.3 http://www.vmware.com/go/downloadfusion
  * Vagrant-berkshelf 1.3.4 https://github.com/berkshelf/vagrant-berkshelf
  * If you want to access access controlled git repositories you will need to add your respective ssh keys via ssh-agent

## Step by Step ##

These instructions take you from zero to a working, virtualized installation of Drupal 7.  It may be a bit simplistic if you are already familiar with Vagrant and you can figure it out if you know Chef ... if that's you then feel free to go that path.  For the rest of the world, this should be helpful.

Clone the drupal-lamp git repository.

```bash
cyberswat:git/ $ git clone git://github.com/cyberswat/drupal-lamp.git
Cloning into 'drupal-lamp'...
remote: Counting objects: 171, done.
remote: Compressing objects: 100% (106/106), done.
remote: Total 171 (delta 70), reused 150 (delta 54)
Receiving objects: 100% (171/171), 29.57 KiB, done.
Resolving deltas: 100% (70/70), done.

```

Change directory into the cloned repository.

```bash
cyberswat:git/ $ cd drupal-lamp
cyberswat:drupal-lamp/ (master) $
```

Create the assets folder.  This is where the drupal code and files that you are working with will be stored.  I go over this in detail later in the README.

```bash
cyberswat:drupal-lamp/ (master) $ mkdir assets
cyberswat:drupal-lamp/ (master) $
```

Each of the chef recipes that Vagrant uses are referenced as cookbooks in the Berkfile.  To utilize these with vagrant run:

```bash
cyberswat:drupal-lamp/ (master) $ $ vagrant plugin install vagrant-berkshelf
Installing the 'vagrant-berkshelf' plugin. This can take a few minutes...
Installed the plugin 'vagrant-berkshelf'
```

You can evaluate state of the instances that are defined in the Vagrantfile.

```bash
cyberswat:drupal-lamp/ (master) $ vagrant status
Current machine states:

drupaldev                poweroff (virtualbox)

The VM is powered off. To restart the VM, simply run `vagrant up`
```

Before bringing an instance online you need to download a base box. The base box is a vanilla virtual machine that the recipes get applied against.  Once you download this box it will be cached on your local machine and won't need to be downloaded again.

You will need to edit the Vagrantfile at the root level of the cloned drupal-lamp repository to uncomment the url of the base box you would like to use.  Line 26 is an Ubuntu 12.04 base box that will work with VMware while line 27 provides the same box configured to work with VirtualBox. Once you've uncommented your selection you can bring the box up.  I'll stick with VirtualBox from this point forward simply because most people will be using it.  You can use the --provider flag for the vagrant command to switch to VMware (which I recommend), but that is outside the scope of these instructions.

```bash
cyberswat:drupal-lamp/ (master✗) $ vagrant up
```

This command will run through the install of the cookbooks using berkshelf and then run through the installation of the LAMP stack and drupal using the cookbooks and vagrant.

If all went well you should the last two lines above at the end of the provisioning stream. At this point you should have a LAMP stack with drupal 7 installed running on your machine.  If you edit the Vagrantfile you will see the ip address the instance has reserved on line 38.  The default is 192.168.50.5 ... if the instance has any kind of networking issues it may be necessary to edit this address.

### Edit hosts file ###

The proper way to view your new drupal site is to edit your hosts file to point to it.  By default the syntax is http://sitename.local. On Macs and Linux, this can be found at /etc/hosts.

```bash
192.168.50.5    drupal.local
```

## Configuring Sites ##

This project will allow you to work with multiple drupal sites on the same server. The Drupal 7 example is included in the .drupal_lamp.json file.  You can override the location of this file by setting an environment variable that contains the absolute path to the file.  This is done so that you can maintain your site configurations separately from the repository so that they are easy to edit, maintain and not accidently lost.  This file must be valid JSON.

```bash
cyberswat:drupal-lamp/ (master✗) $ cp .drupal_lamp.json /Users/cyberswat/.drupal_lamp.json
cyberswat:drupal-lamp/ (master✗) $ export DRUPAL_LAMP=/Users/cyberswat/.drupal_lamp.json
```

The structure of the json works with chef to define the attributes necessary to do it's work.  JSON doesn't allow comments by default, but please read through the following to help clarify it's use.  It may be helpful to compare the raw file to this commented version for clarity.

```javascript
{
  // Controls the Database settings
  "db": {
      // Corresponds to what goes into settings.php
      "driver": "mysql",
      // Cookbook used to setup the database
      "client_recipe": "mysql::client",
      // Sets root user name
      "root": "root",
      // An array of hosts that are allowed to connect to the database
      "grant_hosts": [
        "localhost"
      ],
      // Array of users configured for the database
      "users": {
        "root": "root",
        "replication": "replication",
        "debian": "debian"
      }
  },
  // Global server specific settings
  "server": {
      // System webserver user
      "web_user": "www-data",
      // System group the user belongs to
      "web_group": "www-data",
      // Where the raw undeployed files exist
      "assets": "/srv/assets",
      // Default theme for the drupal install
      "theme_default": "example",
      // The base directory the deployments work from on server
      "base": "/srv/www"
  },
  // drupal is a chef specific namespace that is required.
  "drupal": {
      // sites is the hash that contains each of your sites.
      "sites": {
          // This is the beginning of the definition for a site named "example".
          "example": {
              // Whether or not to do anything with this drupal site during deployment, set to true to provision site
              "active": true,
              // Variables related to the deployment action
              "deploy": {
                  // Available flags: "clean" -- runs drush site-install "update"-- runs drush update-db "nothing" -- does nothing
                  "action": "clean",
                  // Number of previous releases to keep
                  "releases": 1
              },
              "drupal": {
                  // Metadata to allow you to query your infrastucute for specific versions Drupal
                  "version": 7.23,
                  // A hash of installation flags that are appended to the drush site-install command.
                  "install": {
                      // Instruct drush site-install to not send installation related emails.
                      "install_configure_form.update_status_module": "'array(FALSE,FALSE)'",
                      // Instruct drush site-install to enable clean urls.
                      "--clean-url": 1
                  },
                  "settings": {
                      // The Drupal site profile to run when performing an installation.
                      "profile": "standard",
                      // The location of the files for drupal
                      "files": "sites/default/files",
                      // If you have a custom settings.php file that you want included in the existing settings.php
                      "custom": "sites/default/example.settings.php",
                      // location of the settings.php file to use
                      "settings": "sites/default/settings.php",
                      // The Chef cookbook to use druing deployment
                      "cookbook": "drupal",
                      // Ruby file used to create custom.settings.php based on prior flag
                      "template": "example.settings.php.erb",
                      // Name of Drupal DB.
                      "db_name": "example",
                      // Drupal Database host
                      "db_host": "localhost",
                      // Database Prefix
                      "db_prefix": "",
                      // Database Driver
                      "db_driver": "mysql"
                  }
              },
              // A hash containing the sites repository information.
              "repository": {
                  // Repository host
                  "host": "github.com",
                  // The uri of the sites repository.
                  "uri": "https://github.com/drupal/drupal.git",
                  // The revision referenced in the repository eg: 'master', etc.
                  "revision": "7.x"
              },
              // A hash containing Apache settings
              "web_app": {
                  "web_app": {
                      // This is pretty complex example of the power behind the config: DO NOT USE THESE SETTINGS,
                      // However, this shows that this is simply the apache config settings
                      // And all can be controlled in this hash.
                      "80": {
                        "redirect": ["permanent / https://example.vagrant.local/"],
                        "server_name": "example.vagrant.local"
                      },
                      "443": {
                        "server_name": "example.vagrant.local",
                        "server_aliases": ["example.vagrant.local"],
                        "error_log": "syslog:local7",
                        "transfer_log": "logs/ssl_access_log",
                        "log_level": "warn",
                        "ssl": {
                          "ssl_engine": "on",
                          "ssl_protocol": ["all", "-SSLv2"],
                          "ssl_cipher_suite": ["ALL", "!ADH", "!EXPORT", "!SSLv2", "RC4+RSA", "+HIGH", "+MEDIUM", "+LOW"],
                          "ssl_certificate_file": "/etc/httpd/ssl/cert.pem",
                          "ssl_certificate_key_file": "/etc/httpd/ssl/key.pem"
                        },
                        "set_env_if": ["SetEnvIf User-Agent \".*MSIE.*\" nokeepalive ssl-unclean-shutdown downgrade-1.0 force-response-1.0"],
                        "custom_log": "\"|/usr/bin/logger -t httpd -p local6.info\" combined",
                        "rewrite_engine": "On",
                        "docroot": "/srv/www/html/example/current"
                      }
                  }
              }
          }
      }
  }
}
```

## Assets ##

During the setup you created an assets folder to store all of the Drupal files. This folder becomes a mount from the virtual machine to provide a way to keep everything you are interested on your local machine. This gives you the ability to work with the files in a way that is comfortable to you.  Understanding the structure of this folder is important.

```
drupal-lamp
  |_ assets
    |_ site01
      |_ current -> releases/20130627203237
      |_ files
      |_ releases
        |_ 20130627203237
      |_ shared
        |_ cached-copy
    |_ site02
      |_ current -> releases/20130627203238
      |_ files
      |_ releases
        |_ 20130627203238
      |_ shared
        |_ cached-copy
```

The "folder" current is a symbolic link to the most recent code that has been deployed. Code is deployed each time you run a vagrant provision if you have the sites deploy flag in your json file set to true.  Each deployment creates a unix timestamped folder that contains the drupal code. You can make your modifications in this folder and have them show up in real time for the drupal site you see in your browser.

In order to facilitate the symlinks that are necessary for this deployment strategy the files directory remains static. Each timestamped folder contains a symbolic link to the files directory to remain light weight.

The releases folder contains the timestamped folders that are created when you provision.

The cached-copy folder contains the initial clone of the sites repository.  This is done so that you do not need to copy the entire repository with each deployment.

## Berkshelf ##

Initially when the project was launched, we used submodules for the cookbooks. Since that time, we have updated to Berkshelf for handling of the cookbooks. This is a good step forward because it allows for each project to hold multiple cookbooks that are unique to the project without dealing with the mess of submodules.

To customize the cookbooks, edit the Berkfile.

Notice: because of the specific nature of this project with drupal, if you are looking to use the drupal install, the cookbooks currently in the Berkfile are necessary to use. However, you can try to change the version.
