module Main exposing (..)

import Html.App as App
import Html exposing (Html, text, div, textarea, button, section)
import Html.Attributes exposing (type', value, class)
import Html.Events exposing (onInput, onClick)


-- MAIN

main : Program Never
main =
  App.program
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
  }


init : (Model, Cmd Msg)
init =
  ({ ownMessage = ""
   , messages = []
   }
  , Cmd.none
  )


-- UPDATE

type Msg
  = UpdateOwnMessage String
  | Broadcast


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
  Sub.none
