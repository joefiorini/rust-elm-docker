module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http


logger : (Msg -> Model -> ( Model, Cmd Msg )) -> Msg -> Model -> ( Model, Cmd Msg )
logger update msg model =
    let
        originalModel =
            Debug.log "Before:" model

        originalMsg =
            Debug.log "Msg: " msg

        ( afterModel, afterCmd ) =
            update originalMsg originalModel
    in
        ( Debug.log "After:" afterModel, afterCmd )



-- MODEL


type alias Model =
    { name : String, greeting : Maybe String, error : Maybe String }



-- UPDATE


type Msg
    = SetName String
    | RequestGreeting
    | SetGreeting (Result Http.Error String)
    | Reset


main : Program Never Model Msg
main =
    Html.program { init = init, view = view, update = logger update, subscriptions = subscriptions }


init : ( Model, Cmd Msg )
init =
    { name = ""
    , greeting = Nothing
    , error = Nothing
    }
        ! []


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


getGreeting : String -> Cmd Msg
getGreeting name =
    "http://localhost:8002/hello/"
        ++ name
        |> Http.getString
        |> Http.send SetGreeting


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Reset ->
            { model | name = "" } ! []

        SetName name ->
            { model | name = name } ! []

        RequestGreeting ->
            model ! [ getGreeting model.name ]

        SetGreeting r ->
            case r of
                Ok greeting ->
                    { model | greeting = Just greeting } ! []

                Err error ->
                    { model | error = Just "Could not get greeting", greeting = Nothing } ! []



-- VIEW


view : Model -> Html Msg
view model =
    section []
        [ input
            [ type_ "text", value model.name, onInput SetName ]
            []
        , button [ onClick RequestGreeting ] [ text "Get Greeting" ]
        , greetingView model.greeting
        ]


greetingView : Maybe String -> Html Msg
greetingView greeting =
    greeting
        |> Maybe.map (\g -> section [] [ text g ])
        |> Maybe.withDefault (section [] [])
