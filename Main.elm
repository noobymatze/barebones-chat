module Main exposing (..)

import Html.App as App
import Html exposing (Html, text, div, input, button, section)
import Html.Attributes exposing (type', value, class)
import Html.Events exposing (onInput, onClick)


-- MAIN

main : Program Never
main =
  App.beginnerProgram
    { model = init
    , update = update
    , view = view
    }


-- MODEL

type alias Message = String


type alias Model = 
  { ownMessage : String
  , messages : List Message
  }


init : Model
init =
  { ownMessage = ""
  , messages = []
  }


-- UPDATE

type Msg
  = UpdateOwnMessage String
  | Broadcast


update : Msg -> Model -> Model
update msg model =
  case msg of
    UpdateOwnMessage message ->
      { model | ownMessage = message }

    Broadcast ->
      let
        newMessages =
          model.messages ++ [model.ownMessage]
      in
        { model
          | messages = newMessages
          , ownMessage = ""
        }
  

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
    []
    [ input
        [ type' "text"
        , value ownMessage
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
