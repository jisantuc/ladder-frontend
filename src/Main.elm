module Main exposing (main)

import Browser
import Process
import Random
import Task
import Types exposing (Model, Msg(..))
import View exposing (view)


main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


init : Int -> ( Model, Cmd Msg )
init _ =
    ( { recentRatings = [ 1100, 1115, 1130, 1120, 1129, 1144, 1179, 1161, 1163, 1163 ]
      , ratingsHover = Nothing
      , expiryNonce = Nothing
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        RatingHover p ->
            ( { model | ratingsHover = p }
            , Random.int 0 65536 |> Random.generate RatingNewExpiryNonce
            )

        RatingExpireDisplay x ->
            if model.expiryNonce == Just x then
                ( { model | ratingsHover = Nothing }, Cmd.none )

            else
                ( model, Cmd.none )

        RatingNewExpiryNonce x ->
            ( { model | expiryNonce = Just x }
            , Process.sleep 4500
                |> Task.andThen (\_ -> Task.succeed (RatingExpireDisplay x))
                |> Task.perform identity
            )
