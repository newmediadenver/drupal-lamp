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
  * If you want to access access controlled git repositories you will need to add your respective ssh keys via ssh-agent

## Step by Step ##

These instructions take you from zero to a working, virtualized installation of Drupal 7.  It may be a bit simplistic if you are already familiar with Vagrant and you can figure it out if you know Chef ... if that's you then feel free to go that path.  For the rest of the world, this should be helpful.

Add your ssh key to ssh-agent.  You only need this if you are working with git repositories that are private and require your authentication.

```bash
cyberswat:git/ $ ssh-add
Enter passphrase for /Users/cyberswat/.ssh/id_rsa:
Identity added: /Users/cyberswat/.ssh/id_rsa (/Users/cyberswat/.ssh/id_rsa)
cyberswat:git/ $ ssh-add -l
2048 a7:93:5c:93:5c:95:51:cc:60:f5:95:ba:2c:50:81:ca /Users/cyberswat/.ssh/id_rsa (RSA)
```

Clone the drupal-lamp git repository.

```bash
cyberswat:git/ $ git clone git@github.com:cyberswat/drupal-lamp.git
Cloning into 'drupal-lamp'...
Warning: Permanently added 'github.com,204.232.175.90' (RSA) to the list of known hosts.
Identity added: /Users/cyberswat/.ssh/cyberswat_foo (/Users/cyberswat/.ssh/cyberswat_foo)
remote: Counting objects: 121, done.
remote: Compressing objects: 100% (67/67), done.
remote: Total 121 (delta 49), reused 115 (delta 43)
Receiving objects: 100% (121/121), 17.08 KiB, done.
Resolving deltas: 100% (49/49), done.
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

Each of the chef recipes that Vagrant uses are referenced as git submodules.  First, you need to initialize the submodules.

```bash
cyberswat:drupal-lamp/ (master) $ git submodule init
Submodule 'chef/cookbooks/apache2' (git://github.com/opscode-cookbooks/apache2.git) registered for path 'chef/cookbooks/apache2'
Submodule 'chef/cookbooks/build-essential' (git://github.com/opscode-cookbooks/build-essential.git) registered for path 'chef/cookbooks/build-essential'
Submodule 'chef/cookbooks/database' (git://github.com/opscode-cookbooks/database.git) registered for path 'chef/cookbooks/database'
Submodule 'chef/cookbooks/drupal' (git@github.com:cyberswat/drupal.git) registered for path 'chef/cookbooks/drupal'
Submodule 'chef/cookbooks/git' (git://github.com/opscode-cookbooks/git.git) registered for path 'chef/cookbooks/git'
Submodule 'chef/cookbooks/mysql' (git://github.com/opscode-cookbooks/mysql.git) registered for path 'chef/cookbooks/mysql'
Submodule 'chef/cookbooks/openssl' (git://github.com/opscode-cookbooks/openssl.git) registered for path 'chef/cookbooks/openssl'
Submodule 'chef/cookbooks/php' (git://github.com/opscode-cookbooks/php.git) registered for path 'chef/cookbooks/php'
Submodule 'chef/cookbooks/sudo' (git://github.com/opscode-cookbooks/sudo.git) registered for path 'chef/cookbooks/sudo'
```

After the submodules are initialized you need to update them so that they pull down their respective code.

```bash
cyberswat:drupal-lamp/ (master) $ git submodule update
Cloning into 'chef/cookbooks/apache2'...
remote: Counting objects: 2101, done.
remote: Compressing objects: 100% (1037/1037), done.
remote: Total 2101 (delta 1153), reused 1825 (delta 912)
Receiving objects: 100% (2101/2101), 386.35 KiB | 499 KiB/s, done.
Resolving deltas: 100% (1153/1153), done.
Submodule path 'chef/cookbooks/apache2': checked out '9eb2252c1582514364d962fdedd70e6ea98436b9'
Cloning into 'chef/cookbooks/build-essential'...
remote: Counting objects: 283, done.
remote: Compressing objects: 100% (163/163), done.
remote: Total 283 (delta 131), reused 228 (delta 86)
Receiving objects: 100% (283/283), 40.92 KiB, done.
Resolving deltas: 100% (131/131), done.
Submodule path 'chef/cookbooks/build-essential': checked out 'df4264aad07d706f3207cb1fe2bbfa03a0b82f31'
Cloning into 'chef/cookbooks/database'...
remote: Counting objects: 475, done.
remote: Compressing objects: 100% (249/249), done.
remote: Total 475 (delta 268), reused 413 (delta 217)
Receiving objects: 100% (475/475), 91.40 KiB, done.
Resolving deltas: 100% (268/268), done.
Submodule path 'chef/cookbooks/database': checked out '8f31c451d1b090165c758d37b2d4a78a533ccf31'
Cloning into 'chef/cookbooks/drupal'...
Warning: Permanently added 'github.com,204.232.175.90' (RSA) to the list of known hosts.
remote: Counting objects: 75, done.
remote: Compressing objects: 100% (38/38), done.
remote: Total 75 (delta 36), reused 65 (delta 26)
Receiving objects: 100% (75/75), 13.75 KiB, done.
Resolving deltas: 100% (36/36), done.
Submodule path 'chef/cookbooks/drupal': checked out '69eca845e23aa06251ea373eadaa46da6107d697'
Cloning into 'chef/cookbooks/git'...
remote: Counting objects: 473, done.
remote: Compressing objects: 100% (262/262), done.
remote: Total 473 (delta 208), reused 439 (delta 178)
Receiving objects: 100% (473/473), 73.76 KiB, done.
Resolving deltas: 100% (208/208), done.
Submodule path 'chef/cookbooks/git': checked out '5860dd00c470f1bdebf42bf369d9da58029ce9f5'
Cloning into 'chef/cookbooks/mysql'...
remote: Counting objects: 1533, done.
remote: Compressing objects: 100% (1043/1043), done.
remote: Total 1533 (delta 651), reused 1239 (delta 390)
Receiving objects: 100% (1533/1533), 306.03 KiB, done.
Resolving deltas: 100% (651/651), done.
Submodule path 'chef/cookbooks/mysql': checked out '61bda92b46f2eabd59a8e4c3eef4df8096bcf0dc'
Cloning into 'chef/cookbooks/openssl'...
remote: Counting objects: 80, done.
remote: Compressing objects: 100% (42/42), done.
remote: Total 80 (delta 36), reused 68 (delta 27)
Receiving objects: 100% (80/80), 15.47 KiB, done.
Resolving deltas: 100% (36/36), done.
Submodule path 'chef/cookbooks/openssl': checked out 'ccf81e9b3fec9427ed2e6dd76f252dcf68370379'
Cloning into 'chef/cookbooks/php'...
remote: Counting objects: 578, done.
remote: Compressing objects: 100% (340/340), done.
remote: Total 578 (delta 320), reused 448 (delta 205)
Receiving objects: 100% (578/578), 124.96 KiB, done.
Resolving deltas: 100% (320/320), done.
Submodule path 'chef/cookbooks/php': checked out '6a3056dae96d0a826ddc8f5a8ff392afa61aaafc'
Cloning into 'chef/cookbooks/sudo'...
remote: Counting objects: 414, done.
remote: Compressing objects: 100% (186/186), done.
remote: Total 414 (delta 159), reused 394 (delta 142)
Receiving objects: 100% (414/414), 68.24 KiB, done.
Resolving deltas: 100% (159/159), done.
Submodule path 'chef/cookbooks/sudo': checked out '7eb50f591ca5eef5b706f447c942b2caa169b819'
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
cyberswat:drupal-lamp/ (master✗) $ vagrant up drupaldev
Bringing machine 'drupaldev' up with 'virtualbox' provider...
[drupaldev] Box 'precise64' was not found. Fetching box from specified URL for
the provider 'virtualbox'. Note that if the URL does not have
a box for this provider, you should interrupt Vagrant now and add
the box yourself. Otherwise Vagrant will attempt to download the
full box prior to discovering this error.
Downloading or copying the box...
Extracting box...te: 132k/s, Estimated time remaining: --:--:--)
Successfully added box 'precise64' with provider 'virtualbox'!
[drupaldev] Importing base box 'precise64'...
[drupaldev] Matching MAC address for NAT networking...
[drupaldev] Setting the name of the VM...
[drupaldev] Clearing any previously set forwarded ports...
[drupaldev] Creating shared folders metadata...
[drupaldev] Clearing any previously set network interfaces...
[drupaldev] Preparing network interfaces based on configuration...
[drupaldev] Forwarding ports...
[drupaldev] -- 22 => 2222 (adapter 1)
[drupaldev] Running any VM customizations...
[drupaldev] Booting VM...
[drupaldev] Waiting for VM to boot. This can take a few minutes.
[drupaldev] VM booted and ready for use!
[drupaldev] Setting hostname...
[drupaldev] Configuring and enabling network interfaces...
[drupaldev] Mounting shared folders...
[drupaldev] -- /assets
[drupaldev] -- /vagrant
[drupaldev] -- /tmp/vagrant-chef-1/chef-solo-2/roles
[drupaldev] -- /tmp/vagrant-chef-1/chef-solo-1/cookbooks
[drupaldev] -- /tmp/vagrant-chef-1/chef-solo-3/data_bags
[drupaldev] Running provisioner: chef_solo...
Generating chef JSON and uploading...
Running chef-solo...
<-- snip -->
[2013-06-26T19:13:48+00:00] INFO: Running report handlers
[2013-06-26T19:13:48+00:00] INFO: Report handlers complete
```
If all went well you should the last two lines above at the end of the provisioning stream. At this point you should have a LAMP stack with drupal 7 installed running on your machine.  If you edit the Vagrantfile you will see the ip address the instance has reserved on line 38.  The default is 192.168.50.5 ... if the instance has any kind of networking issues it may be necessary to edit this address.

### Edit hosts file ###

The proper way to view your new drupal site is to edit your hosts file to point to it.  By default the syntax is http://sitename.local.  We will go over how to set the site name later in the documentation. For the purposes of these instructions add a host entry pointing to drupal.local corresponding to the ip address in your Vagrantfile.

```bash
192.168.50.5    drupal.local
```

## Configuring Sites ##

This project will allow you to work with multiple drupal sites on teh same server. The Drupal 7 example is included in the .drupal_lamp.json file.  You can override the location of this file by setting an environment variable that contains the absolute path to the file.  This is done so that you can maintain your site configurations separately from the repository so that they are easy to edit, maintain and not accidently lost.  This file must be valid JSON.

```bash
cyberswat:drupal-lamp/ (master✗) $ cp .drupal_lamp.json /Users/cyberswat/.drupal_lamp.json
cyberswat:drupal-lamp/ (master✗) $ export DRUPAL_LAMP=/Users/cyberswat/.drupal_lamp.json
```

The structure of the json works with chef to define the attributes necessary to do it's work.  JSON doesn't allow comments by default, but please read through the following to help clarify it's use.  It may be helpful to compare the raw file to this commented version for clarity.

```javascript
{
// drupal is a chef specific namespace that is required.
  "drupal": {
// sites is the hash that contains each of your sites.
      "sites": {
// This is the beginning of the definition for a site named "drupal".
          "drupal": {
// If set to false the drupal deployment process will not be run.
              "deploy": true,
// If clean is true this will ensure a clean drupal install of the site.
              "clean": false,
// The number of old releases to keep on the server.
              "releases": 1,
// The sites files location.
              "files": "sites/default/files",
// The sites settings file location.
              "settings": "sites/default/settings.php",
// A hash containing the sites repository information.
              "repository": {
// The uri of the sites repository.
                  "uri": "http://git.drupal.org/project/drupal.git",
// The revision referenced in the repository eg: 'master', etc.
                  "revision": "7.x"
              },
// The Drupal site profile to run when performing an installation.
              "profile": "standard",
// A hash of installation flags that are appended to the drush site-install command.
              "install": {
// Instruct drush site-install to not send installation related emails.
                  "install_configure_form.update_status_module": "'array(FALSE,FALSE)'",
// Instruct drush site-install to enable clean urls.
                  "--clean-url": 1
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

current is a symbolic link to the most recent code that has been deployed. Code is deployed each time you run a vagrant provision if you have the sites deploy flag in your json file set to true.  Each deployment creates a unix timestamped folder that contains the drupal code. You can make your modifications in this folder and have them show up in real time for the drupal site you see in your browser.

In order to facilitate the symlinks that are necessary for this deployment strategy the files directory remains static. Each timestamped folder contains a symbolic link to the files directory to remain light weight.

The releases folder contains the timestamped folders that are created when you provision.

The cached-copy folder contains the initial clone of the sites repository.  This is done so that you do not need to copy the entire repository with each deployment.
