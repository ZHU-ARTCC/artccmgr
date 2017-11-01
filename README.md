# ARTCC Manager

[![pipeline status](https://gitlab.com/jvoss1/artccmgr/badges/development/pipeline.svg)](https://gitlab.com/jvoss1/artccmgr/commits/development) [![coverage report](https://gitlab.com/jvoss1/artccmgr/badges/development/coverage.svg)](https://gitlab.com/jvoss1/artccmgr/commits/development)

Badges represent the current state of the development branch.

ImageMagick required for image management!

How to get started with development:

* Ruby version 2.3.3

* System dependencies

    ```bundle install```

* Configuration Files

    Database configuration:

    ```config/database.yml```
    
    Default site wide settings:
    
    ```config/settings.yml```
    
    Environment specific settings:
    
    ```
    config/settings/development.yml
    config/settings/production.yml
    config/settings/test.yml
    ```
    
    Credential storage:
    
    ```config/secrets.yml```

* Database initialization

    Create the databases and seed the Development database:

    ```rake db:setup```

    Seed the test database to ensure RSpec tests pass:

    ```rake db:seed RAILS_ENV=test```

* How to run the test suite

    ```rake spec```

* How to run the application (in development)

    ```rails s```
    
    If you would like jobs to run while developing:
    
    ```bundle exec crono```
    