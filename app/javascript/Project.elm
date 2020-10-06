module Project exposing (..)

import Http
import Json.Decode as Decode exposing (Decoder, nullable, string)
import Json.Decode.Pipeline exposing (required)


type alias Project =
    { name : String
    , slug : String
    , icon_data : Maybe String
    }


decoder : Decoder Project
decoder =
    Decode.succeed Project
        |> required "name" string
        |> required "slug" string
        |> required "icon_data" (nullable string)


decoderList : Decoder (List Project)
decoderList =
    Decode.list decoder


getProjects msg =
    Http.get
        { url = "http://localhost:3000/projects"
        , expect = Http.expectJson msg decoderList
        }
