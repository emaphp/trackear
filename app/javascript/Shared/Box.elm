module Shared.Box exposing (..)

import Element exposing (Element, fromRgb255, padding, row, spacing)
import Element.Border exposing (color, rounded, shadow, width)


box : List (Element msg) -> Element msg
box children =
    row
        [ spacing 10
        , padding 30
        , rounded 5
        , width 1
        , color (fromRgb255 { red = 113, green = 128, blue = 150, alpha = 0.15 })
        , shadow
            { offset = ( 0, 5 )
            , blur = 5
            , color = fromRgb255 { red = 113, green = 128, blue = 150, alpha = 0.1 }
            , size = 0
            }
        ]
        children
