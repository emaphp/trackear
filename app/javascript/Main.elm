module Main exposing (..)

import Browser exposing (Document)
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Page.Home
import Page.Project
import Route exposing (Route(..))
import Session
import Url
import User exposing (..)


type Model
    = Loading Session.Model
    | Home Page.Home.Model
    | Project Page.Project.Model


type Msg
    = GotUser ( Result Http.Error User, Url.Url )
    | HomeMsg Page.Home.Msg
    | ProjectMsg Page.Project.Msg


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading { user = Nothing }, Cmd.none )


getUserAndRedirectToUrl : Url.Url -> Model -> ( Model, Cmd Msg )
getUserAndRedirectToUrl url model =
    ( model, User.getProfile (\x -> GotUser ( x, url )) )


updateWith :
    (subModel -> Model)
    -> (subMsg -> Msg)
    -> Model
    -> ( subModel, Cmd subMsg )
    -> ( Model, Cmd Msg )
updateWith toModel toMsg model ( subModel, subCmd ) =
    ( toModel subModel, Cmd.map toMsg subCmd )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        session =
            sessionFromModel model
    in
    case msg of
        GotUser ( Ok user, redirect ) ->
            ( model, Cmd.none )

        GotUser ( Err err, redirect ) ->
            ( model, Cmd.none )

        HomeMsg homeMsg ->
            ( model, Cmd.none )

        ProjectMsg projectMsg ->
            ( model, Cmd.none )


sessionFromModel : Model -> Session.Model
sessionFromModel model =
    case model of
        Loading session ->
            session

        Home homeModel ->
            homeModel.session

        Project projectModel ->
            projectModel.session


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Html Msg
view model =
    currentView model


currentView : Model -> Html.Html Msg
currentView model =
    case model of
        Loading _ ->
            div [] [ text "Loading!" ]

        Home homeModel ->
            Page.Home.view homeModel
                |> Html.map HomeMsg

        Project _ ->
            div [] []
