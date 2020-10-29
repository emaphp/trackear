module Invoice exposing (..)

import Http
import Json.Decode exposing (string)
import Json.Encode
import Url.Builder


createInvoice : String -> String -> String -> String -> (Result Http.Error String -> msg) -> Cmd msg
createInvoice project_id authenticity_token from to msg =
    Http.post
        { body =
            Http.jsonBody
                (Json.Encode.object
                    [ ( "authenticity_token", Json.Encode.string authenticity_token )
                    , ( "invoice"
                      , Json.Encode.object
                            [ ( "from", Json.Encode.string from )
                            , ( "to", Json.Encode.string to )
                            ]
                      )
                    ]
                )
        , url =
            Url.Builder.absolute
                [ "projects"
                , project_id
                , "invoices.json"
                ]
                []
        , expect = Http.expectString msg
        }
