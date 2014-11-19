Description
===========

Cookbook that installs and configures netvault

Requirements
============

## Platform

* Ubuntu (10.04+)
* Debian (7.1.0+)

Attributes
==========
* `node[:netvault][:file]` - the file to save as
* `node[:netvault][:url]` - the url to pull from
* `node[:netvault][:pkg_base]` - details for the responsefile
* `node[:netvault][:password]` - details for the responsefile
* `node[:netvault][:language]` - details for the responsefile

Recipes
=======

## default

License and Author
==================

- Author:: Jamie van Dyke (<admins@pharmmd.com>)
- Copyright:: 2010 - 2014, PharmMD

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
