module InoviceSummary exposing (..)

import ActivityTrack exposing (ActivityTrack)
import Http
import Json.Decode as Decode exposing (Decoder, bool, list, nullable, string)
import Json.Decode.Pipeline exposing (optional, required)
import ProjectContract exposing (ProjectContract)
import Time
import Time.Extra
import Url.Builder
import User exposing (User)


type alias InvoiceSummary =
    { contract : ProjectContract
    , user : User
    , tracks : List ActivityTrack
    }


decoder : Decoder InvoiceSummary
decoder =
    Decode.succeed InvoiceSummary
        |> required "contract" ProjectContract.decoder
        |> required "user" User.decoder
        |> required "tracks" (list ActivityTrack.decoder)


listDecoder : Decoder (List InvoiceSummary)
listDecoder =
    list decoder


getSummary : String -> String -> String -> (Result Http.Error (List InvoiceSummary) -> msg) -> Cmd msg
getSummary project_id from to msg =
    Http.get
        { url =
            Url.Builder.absolute
                [ "projects"
                , project_id
                , "status_period.json"
                ]
                [ Url.Builder.string "start_date" from
                , Url.Builder.string "end_date" to
                ]
        , expect = Http.expectJson msg listDecoder
        }


calculateHours : InvoiceSummary -> Int
calculateHours summary =
    List.sum (List.map ActivityTrack.calculateHours summary.tracks)


calculateMinutes : InvoiceSummary -> Int
calculateMinutes summary =
    modBy 60 (List.sum (List.map ActivityTrack.calculateMinutes summary.tracks))


calculateAmount : InvoiceSummary -> Float
calculateAmount summary =
    List.sum (List.map ActivityTrack.calculateAmount summary.tracks)
