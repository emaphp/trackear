module Session exposing (..)

import Browser.Navigation as Nav
import User exposing (User)


type alias Model =
    { user : Maybe User
    }
