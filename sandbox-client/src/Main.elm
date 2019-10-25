module Main exposing (..)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

-- MAIN
main =
  Browser.sandbox { init = init, update = update, view = view }

-- MODEL
type alias ToDo =
    { id : Int
    , text : String
    , completed : Bool
    }

type alias Model =
    { toDos : List ToDo
    , current : String
    , uid : Int
    }

newToDo : String -> Int -> ToDo
newToDo text id =
    { id = id
    , text = text
    , completed = False
    }

init : Model
init =
    { toDos = []
    , current = ""
    , uid = 0
    }

-- UPDATE
type Msg
    = Add
    | Change String
    | Delete Int
    | ToggleCompleted Int

update : Msg -> Model -> Model
update msg model =
    case msg of
        Add ->
            { toDos = List.append model.toDos [ newToDo model.current model.uid]
            , current = ""
            , uid = model.uid + 1
            }
        Change newContent -> { model | current = newContent }
        Delete id -> { model | toDos = List.filter (\t -> t.id /= id) model.toDos }
        ToggleCompleted id ->
            let
                updateId toDo =
                    if (toDo.id == id) then
                        { toDo | completed = not toDo.completed }
                    else
                        toDo
            in
                { model | toDos = List.map updateId model.toDos }

-- VIEW
view : Model -> Html Msg
view model =
    div []
        [ h1 [][ text "Awesome ToDo list" ]
        , viewInput model.current
        , h2 [] [ text "ToDo" ]
        , ul [] (List.map viewListItem (List.filter (\t -> not t.completed) model.toDos))
        , h2 [] [ text "Done" ]
        , ul [] (List.map viewListItem (List.filter (\t -> t.completed) model.toDos))
        ]

viewListItem: ToDo -> Html Msg
viewListItem toDo =
    li []
        [ input [ type_ "checkbox", onClick (ToggleCompleted toDo.id), checked toDo.completed ] []
        , text toDo.text
        , button [ onClick (Delete toDo.id) ] [ text "Delete" ]
        ]

viewInput : String -> Html Msg
viewInput current =
    div []
        [ input [ type_ "text", placeholder "Enter ToDo", value current, onInput Change ] []
        , button [ onClick Add ] [ text "Add" ]
        ]