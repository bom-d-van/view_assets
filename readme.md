# ViewAssets [![Build Status](https://travis-ci.org/bom-d-van/view_assets.png?branch=master)](https://travis-ci.org/bom-d-van/view_assets)
A new method to manage assets in a rails project.
Instead of using the default assets managing style in rails 3.2, this gem will introduce a new way to manage your assets.
This is only a prototype of the whole project, the fullfledged version will publish soon.
It works like assetpipeline, but comes with different conventions. It doesn't include all your assets simply even if you have view/page or controller specific assets. It is page-specific.

## Conventions/Rules

According to ViewAssets, there are three folders in `/public` folder:

    * vendor
    * lib
    * app

Each sence of them are the same as in rails3 assetpipeline.

## DIRECTIVES

  for javascript
    double-slash syntax => "//= require_vendor xxx"
    space-asterisk syntax => " *= require_vendor xxx"
    slash-asterisk syntax => "/*= require_vendor xxx */"

  for stylesheets
    space-asterisk syntax => " *= require_vendor xxx"
    slash-asterisk syntax => "/*= require_vendor xxx */"

## Usage

First, include `ViewAssets` in `helpers/application_helper.rb`

```ruby
module ApplicationHelper
  include ViewAssets
end
```

Add some other codes in your `views/layouts/application.html.rb`

```ruby
<%= include_assets_with_assets_mvc(params[:controller], params[:action]) %>
```

If some of your controllers use their own layout file, and following rules in ViewAssets, then you should add that code above too.

This project rocks and uses MIT-LICENSE.