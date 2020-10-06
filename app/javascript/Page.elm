module Page exposing (..)

import Browser exposing (Document)
import Element exposing (Element, alignTop, centerX, fill, height, image, link, padding, rgb255, row, spacing, text, width)
import Element.Background as Background
import Element.Font as Font
import Shared.Box
import User exposing (Profile)


type Page
    = Home


view : Maybe Profile -> Document msg
view profile =
    { title = "Page "
    , body = [ Element.layout [ height fill ] (root profile) ]
    }


root : Maybe Profile -> Element msg
root profile =
    row [ width fill, height fill ]
        [ header profile
        , Shared.Box.box [ text "Something" ]
        ]


profileName : Profile -> String
profileName profile =
    case profile.first_name of
        Just name ->
            name

        Nothing ->
            "Guest"


authenticatedHeader : Profile -> Element msg
authenticatedHeader profile =
    row [ width fill, alignTop, padding 15, Background.color (rgb255 35 47 62), Font.color (rgb255 255 255 255) ]
        [ row
            [ centerX, spacing 15 ]
            [ text "trackear"
            , link [] { url = "/home", label = text "Home" }
            , link [] { url = "/create-project", label = text "Create project" }
            , link [] { url = "/logout", label = text ("Logout " ++ profileName profile) }
            ]
        ]


header : Maybe Profile -> Element msg
header maybeProfile =
    case maybeProfile of
        Just profile ->
            authenticatedHeader profile

        Nothing ->
            row [ width fill ] [ text "Header" ]


footer : Element msg
footer =
    row [ width fill ] [ text "Footer" ]
