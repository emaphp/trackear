module Route exposing (..)

import Url exposing (Url)
import Url.Parser exposing (..)


type Route
    = NotFound
    | Home
    | Project Int


urlToRoute : Url -> Route
urlToRoute url =
    case parse routes url of
        Just route ->
            route

        Nothing ->
            NotFound


routes : Parser (Route -> a) a
routes =
    oneOf
        [ map Home top
        , map Project (s "project" </> int)
        ]
