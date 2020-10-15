module PageProjectsShow exposing (..)

import Browser
import Html exposing (Html, button, div, span, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Task
import Time
import Time.Extra exposing (..)


type alias Model =
    { from : Time.Posix
    , now : Time.Posix
    }


type Msg
    = Tick Time.Posix


main : Program Int Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : Int -> ( Model, Cmd Msg )
init from =
    ( { from = Time.millisToPosix from, now = Time.millisToPosix from }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Time.every 1000 Tick


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick now ->
            ( { model | now = now }, Cmd.none )


view : Model -> Html Msg
view model =
    let
        seconds =
            modBy 60 (diffSeconds model.now model.from)

        minutes =
            modBy 60 (diffMinutes model.now model.from)

        hours =
            diffHours model.now model.from
    in
    span []
        [ text (padZeroIfRequired hours)
        , text ":"
        , text (padZeroIfRequired minutes)
        , text ":"
        , text (padZeroIfRequired seconds)
        ]


padZeroIfRequired : Int -> String
padZeroIfRequired x =
    if x < 10 then
        "0" ++ String.fromInt x

    else
        String.fromInt x


diffSeconds : Time.Posix -> Time.Posix -> Int
diffSeconds a b =
    Time.Extra.diff Second Time.utc b a


diffMinutes : Time.Posix -> Time.Posix -> Int
diffMinutes a b =
    Time.Extra.diff Minute Time.utc b a


diffHours : Time.Posix -> Time.Posix -> Int
diffHours a b =
    Time.Extra.diff Hour Time.utc b a
