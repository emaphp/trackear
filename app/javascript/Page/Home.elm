module Page.Home exposing (..)

import Session


type alias Model =
    { session : Session.Model }


type Msg
    = No


init : Session.Model -> ( Model, Cmd Msg )
init session =
    ( { session = session }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )
