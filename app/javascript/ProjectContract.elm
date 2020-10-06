module ProjectContract exposing (..)

import Http
import Json.Decode as Decode exposing (Decoder, nullable, string)
import Json.Decode.Pipeline exposing (required)
import Project exposing (Project)


type alias ProjectContract =
    { activity : String
    , project_rate : String
    , user_rate : String
    , user_fixed_rate : Maybe String
    , project : Project
    }


decoder : Decoder ProjectContract
decoder =
    Decode.succeed ProjectContract
        |> required "activity" string
        |> required "project_rate" string
        |> required "user_rate" string
        |> required "user_fixed_rate" (nullable string)
        |> required "project" Project.decoder


decoderList : Decoder (List ProjectContract)
decoderList =
    Decode.list decoder


getActiveContracts msg =
    Http.get
        { url = "http://localhost:3000/active_contracts"
        , expect = Http.expectJson msg decoderList
        }
