module ViewHelpers exposing (cardTitleText, stdBox, textLine)

import Html exposing (Html, div, h2, span, text)
import Html.Attributes as HA
import Types exposing (Msg)


stdBox : List (Html Msg) -> Html Msg
stdBox children =
    div
        [ HA.style "border" "1px solid black"
        , HA.style "border-radius" "5px"
        , HA.align "center"
        , HA.style "width" "100%"
        , HA.style "max-width" "400px"
        , HA.style "padding" "5"
        ]
        children


cardTitleText : String -> Html Msg
cardTitleText title =
    h2 [ HA.style "font-family" "sans-serif" ] [ text title ]


textLine : String -> Html Msg
textLine shortText =
    span
        [ HA.style "font-family" "sans-serif"
        , HA.style "font-size" "10"
        ]
        [ text shortText ]
