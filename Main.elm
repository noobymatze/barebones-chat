module Main exposing (..)

import Html exposing (Html, text, div, textarea, button, section)
import Html.Attributes exposing (value, class)
import Html.Events exposing (onInput, onClick)
import WebSocket exposing (listen, send)


-- MAIN

main : Program Never Model Msg
main =
  Html.program
    { init = init
    , update = update
    , view = view
    , subscriptions = subscriptions
    }


-- MODEL

type alias Message = String


type alias Model = 
  { ownMessage : String
  , messages : List Message
  , serverUrl : String
  }


init : (Model, Cmd Msg)
init =
  ({ ownMessage = ""
   , messages = []
   , serverUrl = "ws://localhost:8080/chat"
   }
  , Cmd.none
  )


-- UPDATE

type Msg
  = UpdateOwnMessage String
  | Broadcast
  | IncomingMessage String


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    UpdateOwnMessage message ->
      ({ model | ownMessage = message }
      , Cmd.none
      )

    Broadcast ->
      let
        newMessages =
          model.messages ++ [model.ownMessage]
      in
        ({ model
           | messages = newMessages
           , ownMessage = ""
         }
        , send model.serverUrl model.ownMessage
        )

    IncomingMessage message ->
      let
        newMessages =
          model.messages ++ [message]
      in
        ({ model | messages = newMessages }
        , Cmd.none
        )
  

-- VIEW

view : Model -> Html Msg
view model =
  div
    []
    [ viewMessages model.messages
    , viewOwnMessageInput model.ownMessage
    ]


viewOwnMessageInput : String -> Html Msg
viewOwnMessageInput ownMessage =
  div
    [ class "message-input" ]
    [ textarea
        [ value ownMessage
        , onInput UpdateOwnMessage
        ] []
    , button
        [ onClick Broadcast
        ]
        [ text "Sende"
        ]
    ]
                      

viewMessages : List Message -> Html Msg
viewMessages messages =
  section
    [ class "messages" ]
    (List.map viewMessage messages)


viewMessage : Message -> Html Msg
viewMessage msg =
  div
    []
    [ text msg
    ]


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  listen model.serverUrl IncomingMessage
