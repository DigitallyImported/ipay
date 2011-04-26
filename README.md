iPay
======

Ruby gem for interfacing with the iPay XML API

Changelog
---------

**v0.0.1**

- Initial commit, checks ipay network status

Setup
-----

Create a configuration file 'ipay.yml' and place it in your apps config/ folder. The configuration file is automatically loaded for you and values are accessible via iPay::config struct.

Example configuration:

	:url: "https://api.monexa.com/v05_24/XML/monexa_xml.cgi"
	:username: "API_USERNAME"
	:password: "API_PASSWORD"
	:provider_id: "YOUR_PROVIDER_ID"
	:office_id: "YOUR_OFFICE_ID"

Dependencies
----

- libxml-ruby for processing xml responses

Usage
----
	require 'ipay'
	response = IPay::ping
	puts response.success?
	puts response.data[:version]