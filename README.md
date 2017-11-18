# ARTCC Manager

[![Build Status](https://travis-ci.org/jvoss/artccmgr.svg?branch=development)](https://travis-ci.org/jvoss/artccmgr) [![Test Coverage](https://api.codeclimate.com/v1/badges/22c80ebbf0b39960ac03/test_coverage)](https://codeclimate.com/github/jvoss/artccmgr/test_coverage) [![Maintainability](https://api.codeclimate.com/v1/badges/22c80ebbf0b39960ac03/maintainability)](https://codeclimate.com/github/jvoss/artccmgr/maintainability) 

ARTCC Manager is a full featured VATSIM/VATUSA ARTCC website and management platform
developed on Ruby on Rails. It utilizes VATUSA API integration and VATSIM Single sign-on
(SSO) to provide a seamless experience to users and ease website management for ARTCC staff.

Contact
-------
*Code and Bug Reports*

* [Issue Tracker](https://github.com/jvoss/artccmgr/issues)
* See [CONTRIBUTING](CONTRIBUTING.md) for how to contribute to this project

Requirements
------------

* Ruby 2.4
* Bundler ruby gem
* GPG
* ImageMagick

Installation
------------
Clone the repository and install the gem requirements:
    
    $ git clone git@github.com:jvoss/artccmgr.git
    $ cd artccmgr
    $ bundle install

Configuration
---------------
Configuration settings are maintained in a few separate places:

* Secret Key Base

    Configure the SECRET_KEY_BASE environment variable:
    
        SECRET_KEY_BASE={output of `rake secret`}
        
* Environment configuration

    Configure the RAILS_ENV variable:
    
        RAILS_ENV=production

* Database Configuration (PostgreSQL)

    Configure the DATABASE_URL environment variable:
        
        DATABASE_URL=postgres://{user}:{password}@{hostname}:{port}/{database-name}
        
* VATSIM SSO Configuration

    Configure the following environment variables:
    
        VATSIM_SSO_CONSUMER_KEY={consumer key, example: SSO_DEMO_VACC}
        VATSIM_SSO_SECRET={password for RSA private key}
        VATSIM_SSO_URL={normally: https://cert.vatsim.net/sso/}
        VATSIM_SSO_RSA_KEY={one line output of RSA key *see notes below*}
        
    The VATSIM_SSO_RSA_KEY **must** be formatted carefully. Use the exact output of in quotes:
    
        awk 1 ORS='\\n' <keyfile>
        
* VATUSA API Integration

    Configure the following environment variables:
    
        VATUSA_API_URL={normally: https://api.vatusa.net}
        VATUSA_API_KEY={your organizations specific API key}
        
* Optional GPG/PGP configuration

    When a user has a GPG key configured on their account, the user will
    receive notifications encrypted to their key. Keys are automatically
    added to the default keyring when they are used.

    In addition to user's receiving encrypted emails, you can also
    have ARTCC Manager sign the encrypted emails with a GPG key. 
    
    If a signing key is configured, emails will be automatically 
    signed when they are sent to users with a valid GPG key. The signing
    key **must** match ARTCC Manager's configured "mail_from" address as set in
    [config/settings.yml](config/settings.yml)
    
    To make use of this feature, configure the the environment variables below:
    
        GPG_KEY={one line output of GPG Private Key *see notes below*}
        GPG_PASSPHRASE={password to unlock the GPG Private Key}
        
    The GPG_KEY needs to be formatted carefully. Use the output of in quotes:
        
            awk 1 ORS='\\n' <keyfile>
        
* Customization options

    See the default settings [config/settings.yml](config/settings.yml) for a complete list.
    
    Any changes or customizations should be placed in config/settings/production.yml

## Initialization
Some first-time initialization commands must be executed before running ARTCC Manager for
the first time only.

1) Initialize the databases (make sure the database has been created):
    
        bundle exec rake db:schema:load  
        
2) Seed the database with initial groups, permissions, etc:

        bundle exec rake db:seed

3) Start the Rails server and Crono scheduler for your particular configuration. The
default [Procfile](Procfile) should be sufficient for most configurations:

        web: bundle exec rails server -p $PORT -e $RAILS_ENV
        worker: bundle exec crono RAILS_ENV=$RAILS_ENV
        
## Getting Started
When the scheduler is started it will run the following jobs:

* Update any defined airports weather information (METAR)
* Download the organization's roster from VATUSA and set appropriate groups on users
* Start monitoring VATSIM online data for defined controlling positions

Once the website is up and the scheduler has ran, you should be able to see users on
the roster and log in to the website to begin adding your organization's information. 
    