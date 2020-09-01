# FAQ

## How to convert user to admin?
- Run the application with `docker-compose up`
- `docker-compose exec app bundle exec rails c`
- `User.find_by(email: 'your@email.com').update(is_admin: true)`

## Where is the webpack configuration?
Webpack configuration can be found on `config/webpacker.yml` and `config/webpack`.

## Where are the assets?
Styles and images can be found on `app/assets/images` and `app/assets/stylesheets`.
These assets are not being processed with webpack but with Rails deprecated assets pipeline.

## Where is the javascript?
Javascript files can be found on `app/javascript`. Files inside the `packs` folder are entry points.
All of these files are being processed by [webpacker](https://github.com/rails/webpacker), a Ruby gem that internally uses webpack.

## How to test/preview emails?
Go to http://localhost:3000/rails/mailers

## Where can I see the DB Schema?
Review `db/schema.rb`

## What library is being used for session/authentication?
[Devise](https://github.com/heartcombo/devise)

## What library is being used for roles/authorization?
[CanCanCan](https://github.com/CanCanCommunity/cancancan)

## What library is being used for currency?
[MoneyRails](https://github.com/RubyMoney/money-rails)

## What library is being used for soft-delete?
[Acts as paranoid](https://github.com/ActsAsParanoid/acts_as_paranoid)
