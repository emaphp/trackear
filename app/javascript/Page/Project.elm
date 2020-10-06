module Page.Project exposing (..)

import Session
import Task


type alias Model =
    { session : Session.Model }


type Msg
    = GetProject


run : msg -> Cmd msg
run m =
    Task.perform (always m) (Task.succeed ())


init : Session.Model -> ( Model, Cmd Msg )
init session =
    ( { session = session }, run GetProject )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )
