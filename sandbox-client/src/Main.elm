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
    { text : String
    , completed : Bool
    }

newToDo : String -> ToDo
newToDo text =
    { text = text
    , completed = False
    }

type alias Model =
    { toDos : List ToDo
    , current : String
    }

init : Model
init =
    { toDos = []
    , current = ""
    }

-- UPDATE
type Msg
    = Add String
    | Change String
    | Delete ToDo
    | ToggleCompleted ToDo

update : Msg -> Model -> Model
update msg model =
    case msg of
        Add text ->
            { toDos = List.append model.toDos [ newToDo text ]
            , current = ""
            }

        Change newContent -> { model | current = newContent }

        Delete deletedToDo ->
            let
                undeleted toDo = toDo /= deletedToDo
            in
                { model | toDos = List.filter undeleted model.toDos }

        ToggleCompleted toggledToDo ->
            let
                updateCompleted todo =
                    if (toggledToDo == todo) then
                        { todo | completed = not todo.completed }
                    else
                        todo
            in
                { model | toDos = List.map updateCompleted model.toDos }

-- VIEW
view : Model -> Html Msg
view model =
    let
        done todo = todo.completed
        open todo = not todo.completed
    in
        div []
            [ h1 [] [ text "Awesome ToDo list!" ]
            , viewInput model.current
            , h2 [] [ text "ToDo" ]
            , ul [] (List.filter open model.toDos |> List.map viewListItem)
            , h2 [] [ text "Done" ]
            , ul [] (List.filter done model.toDos |> List.map viewListItem)
            ]

viewListItem : ToDo -> Html Msg
viewListItem toDo =
    li []
        [ label []
            [ input [ type_ "checkbox", onClick (ToggleCompleted toDo), checked toDo.completed ] []
            , text toDo.text
            ]
        , text " "
        , a [ onClick (Delete toDo), href "#" ] [ text "Delete!" ]
        ]

viewInput : String -> Html Msg
viewInput current =
    div []
        [ textarea [ placeholder "Enter ToDo", value current, onInput Change ] []
        , div [] [ button [ onClick (Add current)
                          , disabled (String.length current == 0)
                          ]
                          [ text "Add" ]
                 ]
        ]