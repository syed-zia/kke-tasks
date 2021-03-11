Some new packages need to be installed on all app servers in Stratos DC. 
Basically Nautilus DevOps team is trying to install some group packages which they want to install using Puppet. 
Team was working on to develop some Puppet manifests to accomplish the same. Please find below the details of task and complete the same accordingly:


Create a puppet programming file games.pp under /etc/puppetlabs/code/environments/production/manifests directory on puppet master node 
i.e on Jump Server. Define a class yum_group in puppet programming code and using puppet yum group resource 

complete the task as per details mentioned below:

First of all Install puppet module named puppet-yum on puppet master node i.e on Jump Server (this needs to be done manually).

Install group package Fedora Packager on all puppet agent nodes i.e on all App Servers using your programming file.

Note: Please perform this task using games.pp only, do not create any separate inventory file.


solution:
=========

task 1:

to install puppet-yum
---------------------
=> puppet module install puppet-yum

outout:
Notice: Preparing to install into /etc/puppetlabs/code/environments/production/modules ...
Notice: Downloading from https://forgeapi.puppet.com ...
Notice: Installing -- do not interrupt ...
/etc/puppetlabs/code/environments/production/modules
└─┬ puppet-yum (v4.3.0)
  ├─┬ puppetlabs-concat (v6.4.0)
  │ └── puppetlabs-translate (v2.2.0)
  └── puppetlabs-stdlib (v6.6.0)
  
  to check if the module was installed
  -----------------------------------
  
 => puppet module search [module_name]
 
 puppet module search puppet-yum
  
  ==> root@jump_host /# puppet module search puppet-yum
  
  output:
Warning: This action has been deprecated. Please use the Puppet Forge to search for modules.
   (location: /opt/puppetlabs/puppet/lib/ruby/vendor_ruby/puppet/face/module/search.rb:27:in `block (3 levels) in <top (required)>')
Notice: Searching https://forgeapi.puppet.com ...
NAME               DESCRIPTION                                   AUTHOR        KEYWORDS             
puppet-yum         YUM utilities                                 @puppet       yum package rpm dnf  
ULHPC-slurm        Configure and manage Slurm: A Highly Scal...  @ULHPC        slurm munge slurmd   
ape-elasticsearch  Module for managing and configuring Elast...  @ape                               
ULHPC-infiniband   Install and configure infiniband              @ULHPC        infiniband           
root@jump_host /

Alternate way to verify by running ```puppet module list```. see output below:

root@jump_host /# puppet module list
/etc/puppetlabs/code/environments/production/modules
├── puppet-yum (v4.3.0)
├── puppetlabs-concat (v6.4.0)
├── puppetlabs-stdlib (v6.6.0)
└── puppetlabs-translate (v2.2.0)
/etc/puppetlabs/code/modules (no modules installed)
/opt/puppetlabs/puppet/modules (no modules installed)

task 2: 

create a file games.pp with below content

#============================*Begining of Code file*==============
class yum_group {
  
  yum::group { 'Fedora Packager':
  ensure => present,
  timeout => 300,
}

}

node 'stapp01.stratos.xfusioncorp.com', 'stapp02.stratos.xfusioncorp.com', 'stapp03.stratos.xfusioncorp.com' {
  include yum_group
}

node default{
}  
#================*End of Code==========================
run below to validate the syntax:

=> puppet parser validate games.pp

run below without actually doing the changes permanent

=> puppet apply -v --noop games.pp

run below to apply the changes

=> puppet apply games.pp

on below on the app servers 1, 2, 3

=> puppet agent -tv

sudo yum group mark convert

sudo yum search fedora
sudo yum group summary | grep Installed
sudo yum group list | grep Installed -A 1
sudo yum group list | grep -i Fedora
sudo yum list | grep -i fedora

[tony@stapp01 ~]$ sudo yum group list | grep Installed -A 1
Installed Groups:
   Fedora Packager

[tony@stapp01 ~]$ history
    1  sudo puppet agent -t
    2  sudo yum search fedora
    3  yum group summary | grep Installed
    4  yum group list | grep Installed -A 1
    5  sudo yum group list | grep Installed -A 1
    6  sudo yum group list | grep -i Fedora
    7  sudo yum list | grep -i fedora



