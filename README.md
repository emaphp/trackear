## Installation Docker
- `docker-compose up`
- `docker-compose exec app bundle exec rails db:create db:migrate`
- Go to http://localhost:3000/ (first time may take a while since assets are being compiled)

## Assets
Styles and images can be found on `app/assets/images` and `app/assets/stylesheets`.
These assets are not being processed with webpack but with Rails deprecated assets pipeline.

## Javascript
Javascript files can be found on `app/javascript`. Files inside the `packs` folder are entry points.
All of these files are being processed by [webpacker](https://github.com/rails/webpacker), a Ruby gem that internally uses webpack.

## Deploy
- `eb deploy trackear-prod`

## Webpack configuration
Webpack configuration can be found on `config/webpacker.yml` and `config/webpack`.

## Entities

### User
Represents the user of the application. This entity is mostly handled by Devise
(see below for libraries used in the project).

### Project
Represents the many projects a user may belong to.

### Project contract
Represents the relation a user and a project have. It determines what will be the user's
activity inside of a project, as well as project rate (how much a client gets charged)
and the user rate (how much each team member will charge).

### Activity track
Represents each entry of work made by a user on a project. Each activity track is linked
to a project contract.

### Activity stop watch
Represents a stopwatch initiated by a user. When the user registers time through
a stopwatch, internally a new activity track gets created using the last active
contract the user has.

### Invoice
Gets linked to a project and holds information to know if the invoice is visible or not to
the client (`is_client_visible`) or if it is an internal invoice (meaning only intended
to be used for team members).

### Invoice entry
Represents each entry an invoice can have. Each one of these gets created from
the activity tracks.

## How to convert my user as admin?
- Run the application with `docker-compose up`
- `docker-compose exec app bundle exec rails c`
- `User.find_by(email: 'your@email.com').update(is_admin: true)`

## Where can I see the schema of the DB?
Review `db/schema.rb`

## Library used for session/authentication
[Devise](https://github.com/heartcombo/devise)

## Library used for roles/authorization
[CanCanCan](https://github.com/CanCanCommunity/cancancan)

## Library used for currency
[MoneyRails](https://github.com/RubyMoney/money-rails)

## Library used for soft-delete
[Acts as paranoid](https://github.com/ActsAsParanoid/acts_as_paranoid)
