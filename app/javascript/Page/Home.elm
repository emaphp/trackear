module Page.Home exposing (..)

import Element exposing (text)
import Html
import Layout
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


view : Model -> Html.Html msg
view model =
    Layout.view model.session (text "Hola!")
