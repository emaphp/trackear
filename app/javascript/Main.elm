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
    | Redirect Session.Model
    | NotFound Session.Model


type Msg
    = GotUser ( Result Http.Error User, Url.Url )
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | HomeMsg Page.Home.Msg
    | ProjectMsg Page.Project.Msg


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    getUserAndRedirectToUrl
        url
        (Loading { key = key, user = Nothing })


getUserAndRedirectToUrl : Url.Url -> Model -> ( Model, Cmd Msg )
getUserAndRedirectToUrl url model =
    ( model, User.getProfile (\x -> GotUser ( x, url )) )


changeRouteTo : Route -> Model -> ( Model, Cmd Msg )
changeRouteTo route model =
    let
        session =
            sessionFromModel model
    in
    case route of
        Route.NotFound ->
            ( NotFound session, Cmd.none )

        Route.Home ->
            Page.Home.init session
                |> updateWith Home HomeMsg model

        Route.Project id ->
            Page.Project.init session
                |> updateWith Project ProjectMsg model


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
            changeRouteTo
                (Route.urlToRoute redirect)
                (Loading { session | user = Just user })

        GotUser ( Err err, redirect ) ->
            changeRouteTo (Route.urlToRoute redirect) model

        LinkClicked urlRequest ->
            linkClicked urlRequest model

        UrlChanged url ->
            changeRouteTo (Route.urlToRoute url) model

        HomeMsg homeMsg ->
            ( model, Cmd.none )

        ProjectMsg projectMsg ->
            ( model, Cmd.none )


linkClicked : Browser.UrlRequest -> Model -> ( Model, Cmd Msg )
linkClicked urlRequest model =
    case urlRequest of
        Browser.Internal url ->
            ( model, Nav.pushUrl (keyFromModel model) (Url.toString url) )

        Browser.External href ->
            ( model, Nav.load href )


sessionFromModel : Model -> Session.Model
sessionFromModel model =
    case model of
        Loading session ->
            session

        Home homeModel ->
            homeModel.session

        Project projectModel ->
            projectModel.session

        Redirect session ->
            session

        NotFound session ->
            session


keyFromModel : Model -> Nav.Key
keyFromModel model =
    (sessionFromModel model).key


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Document Msg
view model =
    { title = "Trackear"
    , body = [ currentView model ]
    }


currentView : Model -> Html.Html Msg
currentView model =
    case model of
        Loading _ ->
            div [] [ text "Loading" ]

        Home homeModel ->
            Page.Home.view homeModel
                |> Html.map HomeMsg

        Project _ ->
            div [] []

        Redirect _ ->
            div [] []

        NotFound _ ->
            div [] []
