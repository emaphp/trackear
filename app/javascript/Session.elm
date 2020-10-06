module Session exposing (..)

import Browser.Navigation as Nav
import User exposing (User)


type alias Model =
    { key : Nav.Key
    , user : Maybe User
    }
