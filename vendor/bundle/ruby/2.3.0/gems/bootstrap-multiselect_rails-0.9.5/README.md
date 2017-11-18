# bootstrap-multiselect_rails

[![Gem Version](https://badge.fury.io/rb/bootstrap-multiselect_rails.svg)](http://badge.fury.io/rb/bootstrap-multiselect_rails)

This gem packages the [bootstrap-multiselect](https://github.com/davidstutz/bootstrap-multiselect) library for the Rails 3.1+ asset pipeline.

## Installation

Add this line to your application's Gemfile:
```
  gem 'bootstrap-multiselect_rails', '~> 0.9.4'
```

And then execute:
```bash
  $ bundle
```

Or install it yourself:
```bash
  $ gem install bootstrap-multiselect_rails
```

To start using the bootstrap-multiselect library in your rails application, enable it via the asset pipeline.

Add the following to your Javascript manifest file (`application.js`):
```js
//= require bootstrap-multiselect
```

Add the following to your stylesheet file:

If you are using SCSS, modify your `application.css.scss`
```scss
@import 'bootstrap-multiselect';
```

If you're using just plain CSS, modify your `application.css`
```css
*= require bootstrap-multiselect
```
## Usage

Check out the documentation at: http://davidstutz.github.io/bootstrap-multiselect/

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
