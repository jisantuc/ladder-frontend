module View exposing (view)

import Browser
import Html exposing (Html, div, text)
import Html.Attributes as HA
import Ratings.View exposing (ratingsView)
import Types exposing (Model, Msg)


stdBox : List (Html Msg) -> Html Msg
stdBox children =
    div
        [ HA.style "border" "2px solid black"
        , HA.style "border-radius" "5px"
        , HA.align "center"
        , HA.style "width" "100%"
        , HA.style "max-width" "400px"
        , HA.style "max-height" "300px"
        ]
        children


baseView : Model -> Html Msg
baseView model =
    [ ratingsView model ]
        |> stdBox


view : Model -> Browser.Document Msg
view model =
    { title = "Ladder Billiards"
    , body = [ baseView model ]
    }
