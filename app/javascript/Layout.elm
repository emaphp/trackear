module Layout exposing (view)

import Element
    exposing
        ( Element
        , alignTop
        , centerX
        , column
        , fill
        , height
        , htmlAttribute
        , link
        , padding
        , rgb255
        , row
        , spacing
        , text
        , width
        )
import Element.Background as Background
import Element.Font as Font
import Html
import Html.Attributes exposing (class)
import Session
import Shared.Box
import User exposing (User)


view : Session.Model -> Element msg -> Html.Html msg
view session content =
    Element.layout [ height fill, width fill ] (root session content)


root : Session.Model -> Element msg -> Element msg
root session content =
    column [ width fill, htmlAttribute (class "min-h-screen bg-gray-100") ]
        [ header session.user
        , Shared.Box.box [ content ]
        , footer
        ]


profileName : User -> String
profileName profile =
    case profile.first_name of
        Just name ->
            name

        Nothing ->
            "Guest"


authenticatedHeader : User -> Element msg
authenticatedHeader profile =
    row
        [ alignTop
        , padding 15
        , Background.color (rgb255 35 47 62)
        , Font.color (rgb255 255 255 255)
        ]
        [ row
            [ centerX, spacing 15 ]
            [ text "trackear"
            , link [] { url = "/home", label = text "Home" }
            , link [] { url = "/create-project", label = text "Create project" }
            , link [] { url = "/logout", label = text ("Logout " ++ profileName profile) }
            ]
        ]


header : Maybe User -> Element msg
header maybeProfile =
    case maybeProfile of
        Just profile ->
            authenticatedHeader profile

        Nothing ->
            row [ width fill ] [ text "Header" ]


footer : Element msg
footer =
    row [ width fill ] [ text "Footer" ]
