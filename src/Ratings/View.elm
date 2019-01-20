module Ratings.View exposing (ratingsView)

import Html exposing (Html, div, img, text)
import Html.Attributes as HA
import LineChart
import LineChart.Area as Area
import LineChart.Axis as Axis
import LineChart.Axis.Intersection as Intersection
import LineChart.Colors as Colors
import LineChart.Container as Container
import LineChart.Dots as Dots
import LineChart.Events as Events
import LineChart.Grid as Grid
import LineChart.Interpolation as Interpolation
import LineChart.Junk as Junk
import LineChart.Legends as Legends
import LineChart.Line as Line
import Svg exposing (Svg, circle, line, svg)
import Svg.Attributes as SA
import Svg.Events as SE
import Types exposing (Model, Msg(..))
import ViewHelpers exposing (cardTitleText, stdBox, textLine)


lineSegmentsFromSeries : Float -> Float -> List ( Int, Float ) -> List (Svg Msg)
lineSegmentsFromSeries maxY minY series =
    case series of
        p1 :: p2 :: t ->
            [ line
                [ (Tuple.first >> (\x -> x * 10) >> String.fromInt) p1 |> SA.x1
                , (Tuple.second >> (\y -> maxY - y + minY) >> String.fromFloat) p1 |> SA.y1
                , (Tuple.first >> (\x -> x * 10) >> String.fromInt) p2 |> SA.x2
                , (Tuple.second >> (\y -> maxY - y + minY) >> String.fromFloat) p2 |> SA.y2
                , SA.style "stroke:rgb(0,20,255);stroke-width:0.5"
                , SE.onMouseOver (( Tuple.second p1 |> round, Tuple.second p2 |> round ) |> Just |> RatingsHover)
                ]
                []
            ]
                ++ lineSegmentsFromSeries maxY minY (p2 :: t)

        _ ->
            []


pointsFromSeries : Float -> Float -> List ( Int, Float ) -> List (Svg Msg)
pointsFromSeries maxY minY series =
    List.map
        (\p ->
            circle
                [ p
                    |> (Tuple.first >> (\x -> x * 10) >> String.fromInt)
                    |> SA.cx
                , p
                    |> (Tuple.second >> (\y -> maxY - y + minY) >> String.fromFloat)
                    |> SA.cy
                , SA.r "0.005"
                ]
                []
        )
        series


minMaxYFromSeries : List ( Int, Float ) -> Maybe ( Float, Float )
minMaxYFromSeries series =
    let
        minY =
            List.minimum (List.map Tuple.second series)

        maxY =
            List.maximum (List.map Tuple.second series)
    in
    case ( minY, maxY ) of
        ( Just min, Just max ) ->
            Just ( min, max )

        _ ->
            Nothing


lineChart : List ( Int, Float ) -> Html Msg
lineChart series =
    case minMaxYFromSeries series of
        Just ( min, max ) ->
            div []
                [ img [ HA.style "width" "100%" ]
                    [ svg
                        [ SA.width "100%"
                        , SA.height "200"
                        , "0 "
                            ++ String.fromFloat (min - 10)
                            ++ " 100 "
                            ++ String.fromFloat (max - min)
                            |> SA.viewBox
                        ]
                        (lineSegmentsFromSeries max min series
                            ++ pointsFromSeries max min series
                        )
                    ]
                ]

        Nothing ->
            div [ HA.style "width" "100%" ]
                [ textLine "No recent ratings available"
                ]


ratingsView : Model -> Html Msg
ratingsView model =
    let
        chart =
            List.indexedMap Tuple.pair model.recentRatings
                |> lineChart
    in
    [ cardTitleText "Recent Ratings"
    , chart
    ]
        ++ Maybe.withDefault [ div [] [ text " " ] ]
            (Maybe.map
                (\x ->
                    [ "From "
                        ++ (Tuple.first >> String.fromInt) x
                        ++ " to "
                        ++ (Tuple.second >> String.fromInt) x
                        |> textLine
                    ]
                )
                model.ratingsHover
            )
        |> stdBox
