## Reporting Issues

You can report issues at https://github.com/jvoss/artccmgr/issues

Before you submit a new issue, please search existing issues for your problem,
someone else may have already reported it.

## Making Contributions

If you would like to contribute, please:

  * Fork the project.
  * Make your feature addition or bug fix.
  * Add RSpec tests for it. This is important so we do not break functionality.
  * Ensure all RSpec tests are passing.
  * Ensure Brakeman tests pass (static security analysis)
  * Ensure Rubocop passes (lint testing)
  * Squash your changes to a single commit.
  * Send a merge request.
  
To fetch and set up your development environment:

    $ git clone git@github.com:jvoss/artccmgr.git
    $ cd artccmgr
    $ bundle
    
Setup the development and test databases (see config/database.yml):

    $ rake db:setup
    $ rake db:seed RAILS_ENV=test
    
Start the development web server:

    $ rails s

ARTCC Manager uses Crono for time based job scheduling. To start the scheduler:

    $ bundle exec crono
  
## Running Tests

This project uses RSpec. Tests can be ran like this:

Entire suite:
```bash
rake spec
```

By spec:
```bash
rspec spec/path/to/spec.rb
```

By suite (controllers, helpers, jobs, etc):
```bash
rake spec:controllers                   # Run the code examples in spec/controllers
rake spec:helpers                       # Run the code examples in spec/helpers
rake spec:jobs                          # Run the code examples in spec/jobs
rake spec:mailers                       # Run the code examples in spec/mailers
rake spec:models                        # Run the code examples in spec/models
rake spec:policies                      # Run the code examples in spec/policies
```

Checking for Test Coverage
--------------------------
This project uses [SimpleCov](https://github.com/colszowka/simplecov) to check test coverage. To generate a report:

```bash
COVERAGE=true rake spec
```

The output of the report can be found in ``/coverage``

Static Security Analysis
------------------------
This project uses [Brakeman](https://brakemanscanner.org/) for static vulnerability assessments.

To test the current project:

```bash
RAILS_ENV=test bundle exec brakeman -A
```

Rubocop Analysis
----------------
We use [Rubocop](https://github.com/bbatsov/rubocop) to enforce coding standards.

To test the current project:

```bash
bundle exec rubocop
```
