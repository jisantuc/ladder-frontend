module Types exposing (Model, Msg(..))


type Msg
    = NoOp
    | RatingHover (Maybe ( Int, Int ))
    | RatingExpireDisplay Int
    | RatingNewExpiryNonce Int


type alias Model =
    { recentRatings : List Float
    , ratingsHover : Maybe ( Int, Int )
    , expiryNonce : Maybe Int
    }
