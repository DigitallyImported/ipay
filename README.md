iPay
======

Ruby gem for interfacing with the iPay XML API

Changelog
---------

**v0.0.1**

- Initial commit

Setup
-----

Create a configuration file 'ipay.yml' and place it in your apps config/ folder. The configuration file is automatically loaded for you and values are accessible via iPay::config struct.

Example configuration:

	:url: "https://uap.txngw.com/"
	:company_key: 6990
	:terminal_id: 6177
	:pin: 1234

Dependencies
----

- libxml-ruby for processing xml responses

Usage
----
	require 'ipay'
	response = IPay::Network::Status.query
	puts response.success?
	puts response.server_time
	puts response.data