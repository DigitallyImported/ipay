iPay
======

Ruby gem for interfacing with the iPay XML API

Changelog
---------

**v0.2.4**

- Added models for Client and CreditCard with validations.
- Added basic error handling.

**v0.2.0**

- Updated tests
- Included example certification file for CC/Wallet Services
- Added countries yaml for converting iso 3166 2 char country codes to iPay 3 char country code and currency codes
- Cleaned up some constants

**v0.1.1**

- Added certification mode

**v0.1.0**

- CC (credit/debit) and Wallet (client/account) requests
- Tests

**v0.0.1**

- Initial commit

Dependencies
----

- libxml-ruby for processing xml responses

Setup
-----

Create a configuration file 'ipay.yml' and place it in your apps config/ folder. The configuration file is automatically loaded for you and values are accessible via iPay::config struct.

Example configuration:

	:url: "https://uap.txngw.com/"
	:company_key: 6990
	:terminal_id: 6177
	:pin: 1234

You can also configure IPay via a block:

	IPay.config do |c|
	  c.url = 'https://uap.txngw.com/'
	  c.company_key = 6990
	  c.terminal_id = 6177
	  c.pin = 1234
	end

Usage
----
	require 'ipay'
	resp = IPay::CC::Debit.sale(
		:amount => '4.99', 
		:account_number => '4000009999999991',
		:cvv => 123,
		:expiration => '0614', 
		:first_name => 'nick', 
		:last_name => 'wilson',
		:address => '123 fake st', 
		:city => 'sometown', 
		:state => 'NY', 
		:postal_code => '90210', 
		:country => 'USA'
	)

	if resp.success?
		puts resp.data[:transaction_id]
	else
		puts resp.errors.full_messages
	end

Certification
----

IPay requires that test accounts submit an xml file of compiled responses before allowing an account to be used in production mode. The IPay gem has a certification mode that will compile all responses into the appropriate file/format for you automatically:

	IPay::Certification.capture do
		# ... all responses for api requests are now logged and saved when the block ends
	end
