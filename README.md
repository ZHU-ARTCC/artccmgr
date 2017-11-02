# ARTCC Manager

[![pipeline status](https://gitlab.com/jvoss1/artccmgr/badges/development/pipeline.svg)](https://gitlab.com/jvoss1/artccmgr/commits/development) [![coverage report](https://gitlab.com/jvoss1/artccmgr/badges/development/coverage.svg)](https://gitlab.com/jvoss1/artccmgr/commits/development)

ARTCC Manager is a full featured VATSIM/VATUSA ARTCC website and management platform
developed on Ruby on Rails. It utilizes VATUSA API integration and VATSIM Single sign-on
(SSO) to provide a seamless experience to users and ease website management for ARTCC staff.

Contact
-------
*Code and Bug Reports*

* [Issue Tracker](https://gitlab.com/jvoss1/artccmgr/issues)
* See [CONTRIBUTING](CONTRIBUTING.md) for how to contribute to this project

Requirements
------------

* Ruby 2.4
* Bundler ruby gem
* ImageMagick

Installation
------------
Clone the repository and install the gem requirements:
    
    $ git clone git@gitlab.com:jvoss1/artccmgr.git
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
        
    The VATSIM_SSO_RSA_KEY **must** be formatted carefully. Use the exact output of:
    
        awk 1 ORS='\\n' <keyfile>
        
* VATUSA API Integration

    Configure the following environment variables:
    
        VATUSA_API_URL={normally: https://api.vatusa.net}
        VATUSA_API_KEY={your organizations specific API key}
        
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
    