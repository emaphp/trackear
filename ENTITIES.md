# Entities

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

### Ability
Determines what a user can do inside of the application (authorization). This file can
be found on `app/models/ability.rb`.
