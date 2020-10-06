module User exposing (..)

import Http
import Json.Decode as Decode exposing (Decoder, bool, nullable, string)
import Json.Decode.Pipeline exposing (optional, required)


type alias Profile =
    { email : String
    , first_name : Maybe String
    , last_name : Maybe String
    , picture : Maybe String
    , is_admin : Bool
    }


decoder : Decoder Profile
decoder =
    Decode.succeed Profile
        |> required "email" string
        |> required "first_name" (nullable string)
        |> required "last_name" (nullable string)
        |> required "picture" (nullable string)
        |> optional "is_admin" bool False


getProfile msg =
    Http.get
        { url = "http://localhost:3000/me"
        , expect = Http.expectJson msg decoder
        }
