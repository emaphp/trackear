module ActivityTrack exposing (..)

import Html exposing (track)
import Json.Decode exposing (Decoder, nullable, string)
import Json.Decode.Extra exposing (datetime)
import Json.Decode.Pipeline exposing (required)
import Time exposing (Posix)
import Time.Extra


type alias ActivityTrack =
    { project_rate : Maybe String
    , user_rate : String
    , from : Posix
    , to : Posix
    }


decoder : Decoder ActivityTrack
decoder =
    Json.Decode.succeed ActivityTrack
        |> required "project_rate" (nullable string)
        |> required "user_rate" string
        |> required "from" datetime
        |> required "to" datetime


calculateHours : ActivityTrack -> Int
calculateHours track =
    Time.Extra.diff Time.Extra.Hour Time.utc track.from track.to


calculateMinutes : ActivityTrack -> Int
calculateMinutes track =
    modBy 60 (calculateTotalMinutes track)


calculateTotalMinutes : ActivityTrack -> Int
calculateTotalMinutes track =
    Time.Extra.diff Time.Extra.Minute Time.utc track.from track.to


getProjectHourlyRate : ActivityTrack -> Float
getProjectHourlyRate track =
    case track.project_rate of
        Just project_hourly_rate ->
            Maybe.withDefault 0 (String.toFloat project_hourly_rate)

        Nothing ->
            0


calculateAmount : ActivityTrack -> Float
calculateAmount track =
    (getProjectHourlyRate track / 60) * toFloat (calculateTotalMinutes track)
