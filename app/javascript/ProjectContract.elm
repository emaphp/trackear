module ProjectContract exposing (..)

import Json.Decode exposing (Decoder, string)
import Json.Decode.Pipeline exposing (required)


type alias ProjectContract =
    { project_rate : String
    , user_rate : String
    }


decoder : Decoder ProjectContract
decoder =
    Json.Decode.succeed ProjectContract
        |> required "project_rate" string
        |> required "user_rate" string
