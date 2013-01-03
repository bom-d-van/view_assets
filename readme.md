# ViewAssets

## Simple Introductin

A new method to manage assets in a rails project.   

Instead of using the default assets managing style in rails 3.2, this gem will introduce a new way to manage your assets. This is still a prototype, the fullfledged version will publish soon.

## Conventions/Rules

## Usage

Include this gem in your `helpers/application_helper.rb`

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
