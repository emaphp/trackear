module Page.Invoices.New exposing (..)

import Browser
import Browser.Navigation exposing (load)
import DurationDatePicker exposing (Settings, defaultSettings)
import FormatNumber exposing (format)
import FormatNumber.Locales exposing (Decimals(..), spanishLocale)
import Html exposing (Html, button, div, img, label, table, tbody, td, text, tfoot, th, thead, tr)
import Html.Attributes exposing (class, disabled, src, style)
import Html.Events exposing (onClick)
import Http
import InoviceSummary exposing (InvoiceSummary, getSummary)
import Invoice
import Task
import Time exposing (Month(..), Posix, Zone)
import Time.Extra as Time exposing (Interval(..))


type alias Props =
    { project_id : String
    , name_label : String
    , hours_label : String
    , amount_label : String
    , date_label : String
    , choose_another_date_label : String
    , create_invoice_label : String
    , continue_label : String
    , select_date_label : String
    , authenticity_token : String
    }


type Msg
    = OpenPicker
    | UpdatePicker ( DurationDatePicker.DatePicker, Maybe ( Posix, Posix ) )
    | AdjustTimeZone Zone
    | Tick Posix
    | GetInvoiceSummary
    | GotInvoiceSummary (Result Http.Error (List InvoiceSummary))
    | ChooseAnotherDate
    | CreateInvoice
    | CreateInvoiceResponse (Result Http.Error String)


type alias Model =
    { currentTime : Posix
    , zone : Zone
    , pickedStartTime : Maybe Posix
    , pickedEndTime : Maybe Posix
    , picker : DurationDatePicker.DatePicker
    , summary : Maybe (List InvoiceSummary)
    , props : Props
    , disabled : Bool
    }


main : Program Props Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : Props -> ( Model, Cmd Msg )
init props =
    ( { currentTime = Time.millisToPosix 0
      , zone = Time.utc
      , pickedStartTime = Nothing
      , pickedEndTime = Nothing
      , picker = DurationDatePicker.init
      , summary = Nothing
      , props = props
      , disabled = True
      }
    , Task.perform AdjustTimeZone Time.here
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ DurationDatePicker.subscriptions
            (userDefinedDatePickerSettings model.zone model.currentTime)
            UpdatePicker
            model.picker
        , Time.every 1000 Tick
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OpenPicker ->
            ( { model
                | picker =
                    DurationDatePicker.openPicker
                        model.zone
                        model.currentTime
                        model.pickedStartTime
                        model.pickedEndTime
                        model.picker
              }
            , Cmd.none
            )

        UpdatePicker ( newPicker, maybeRuntime ) ->
            let
                ( startTime, endTime ) =
                    Maybe.map
                        (\( start, end ) -> ( Just start, Just end ))
                        maybeRuntime
                        |> Maybe.withDefault ( model.pickedStartTime, model.pickedEndTime )
            in
            ( { model
                | picker = newPicker
                , pickedStartTime = startTime
                , pickedEndTime = endTime
              }
            , Cmd.none
            )

        AdjustTimeZone newZone ->
            ( { model | zone = newZone }, Cmd.none )

        Tick newTime ->
            ( { model | currentTime = newTime, disabled = False }, Cmd.none )

        GetInvoiceSummary ->
            ( model
            , InoviceSummary.getSummary
                model.props.project_id
                (formatDate model.zone model.pickedStartTime "")
                (formatDate model.zone model.pickedEndTime "")
                GotInvoiceSummary
            )

        GotInvoiceSummary (Ok summary) ->
            ( { model | summary = Just summary }, Cmd.none )

        GotInvoiceSummary (Err _) ->
            ( { model | summary = Nothing }, Cmd.none )

        ChooseAnotherDate ->
            ( { model | summary = Nothing }, Cmd.none )

        CreateInvoice ->
            ( { model | disabled = True }
            , Invoice.createInvoice
                model.props.project_id
                model.props.authenticity_token
                (formatDate model.zone model.pickedStartTime "")
                (formatDate model.zone model.pickedEndTime "")
                CreateInvoiceResponse
            )

        CreateInvoiceResponse (Ok invoice_url) ->
            ( { model | disabled = False }, load invoice_url )

        CreateInvoiceResponse (Err _) ->
            ( { model | disabled = False }, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ div [ class "form-group" ]
            [ div [] [ label [] [ text model.props.date_label ] ]
            , div [] [ dateField model ]
            ]
        , getSummaryButton model
        , summaryTable model
        ]


userDefinedDatePickerSettings : Zone -> Posix -> Settings Msg
userDefinedDatePickerSettings zone today =
    let
        defaults =
            defaultSettings zone UpdatePicker
    in
    { defaults
        | isFooterDisabled = True
        , focusedDate = Just today
        , dateStringFn = posixToDateString
    }


calculateHoursFor : InvoiceSummary -> String
calculateHoursFor row =
    addLeadingZero (InoviceSummary.calculateHours row)


calculateMinutesFor : InvoiceSummary -> String
calculateMinutesFor row =
    addLeadingZero (InoviceSummary.calculateMinutes row)


calculateAmount : InvoiceSummary -> String
calculateAmount row =
    "$" ++ formatAmount (InoviceSummary.calculateAmount row)


calculateTotalAmount : List InvoiceSummary -> String
calculateTotalAmount summary =
    "$" ++ formatAmount (List.sum (List.map InoviceSummary.calculateAmount summary))


formatAmount : Float -> String
formatAmount amount =
    format { spanishLocale | decimals = Exact 2 } amount


summaryTableRow : InvoiceSummary -> Html Msg
summaryTableRow row =
    tr []
        [ td
            [ class "py-2" ]
            [ div [ class "flex items-center" ]
                [ img [ src row.user.picture, class "rounded-full w-8 mr-3" ] []
                , text (row.user.first_name ++ " " ++ row.user.last_name)
                ]
            ]
        , td [ class "py-2 text-right" ]
            [ text
                (calculateHoursFor row ++ ":" ++ calculateMinutesFor row)
            ]
        , td [ class "py-2 text-right" ] [ text (calculateAmount row) ]
        ]


summaryTableBody : List InvoiceSummary -> Html Msg
summaryTableBody summary =
    tbody [] (List.map summaryTableRow summary)


summaryTableHead : Props -> Html Msg
summaryTableHead props =
    thead []
        [ tr []
            [ th [ class "py-2 text-left" ] [ text props.name_label ]
            , th [ class "py-2 text-right" ] [ text props.hours_label ]
            , th [ class "py-2 text-right" ] [ text props.amount_label ]
            ]
        ]


summaryTableFooter : List InvoiceSummary -> Html Msg
summaryTableFooter summary =
    tfoot []
        [ tr []
            [ td [] []
            , td [ class "py-2 text-right font-bold" ] [ text "Total" ]
            , td [ class "py-2 text-right" ] [ text (calculateTotalAmount summary) ]
            ]
        ]


summaryTable : Model -> Html Msg
summaryTable model =
    case model.summary of
        Just summary ->
            div []
                [ div [ class "form-group" ]
                    [ table
                        [ class "table-auto w-full" ]
                        [ summaryTableHead model.props
                        , summaryTableBody summary
                        , summaryTableFooter summary
                        ]
                    ]
                , div [ class "text-right" ]
                    [ button
                        [ class "btn btn-secondary"
                        , onClick ChooseAnotherDate
                        , disabled model.disabled
                        ]
                        [ text model.props.choose_another_date_label ]
                    , button
                        [ class "ml-2 btn btn-primary"
                        , onClick CreateInvoice
                        , disabled model.disabled
                        ]
                        [ text model.props.create_invoice_label ]
                    ]
                ]

        Nothing ->
            div [] []


getSummaryButton : Model -> Html Msg
getSummaryButton model =
    case model.summary of
        Just _ ->
            div [] []

        Nothing ->
            div [ class "text-right" ]
                [ button
                    [ class "btn btn-primary"
                    , onClick GetInvoiceSummary
                    , disabled model.disabled
                    ]
                    [ text model.props.continue_label ]
                ]


formatDate : Zone -> Maybe Posix -> String -> String
formatDate zone maybeDate default =
    case maybeDate of
        Just date ->
            posixToDateString zone date

        Nothing ->
            default


selectedDateFormatted : Model -> Html Msg
selectedDateFormatted model =
    Maybe.map2
        (\start end -> text (posixToDateString model.zone start ++ " " ++ " - " ++ posixToDateString model.zone end))
        model.pickedStartTime
        model.pickedEndTime
        |> Maybe.withDefault (text model.props.select_date_label)


dateField : Model -> Html Msg
dateField model =
    case model.summary of
        Just _ ->
            div [ class "form-control bg-gray-200" ] [ selectedDateFormatted model ]

        Nothing ->
            div []
                [ button
                    [ class "form-control text-left"
                    , onClick OpenPicker
                    , disabled model.disabled
                    ]
                    [ selectedDateFormatted model ]
                , DurationDatePicker.view
                    (userDefinedDatePickerSettings model.zone model.currentTime)
                    model.picker
                ]


addLeadingZero : Int -> String
addLeadingZero value =
    String.padLeft 2 '0' (String.fromInt value)


monthToNmbString : Month -> String
monthToNmbString month =
    case month of
        Jan ->
            "01"

        Feb ->
            "02"

        Mar ->
            "03"

        Apr ->
            "04"

        May ->
            "05"

        Jun ->
            "06"

        Jul ->
            "07"

        Aug ->
            "08"

        Sep ->
            "09"

        Oct ->
            "10"

        Nov ->
            "11"

        Dec ->
            "12"


posixToDateString : Zone -> Posix -> String
posixToDateString zone date =
    addLeadingZero (Time.toDay zone date)
        ++ "/"
        ++ monthToNmbString (Time.toMonth zone date)
        ++ "/"
        ++ addLeadingZero (Time.toYear zone date)
