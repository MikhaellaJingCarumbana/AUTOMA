extends Node2D


@onready var card_pile_ui := $CardPileUI
@onready var panel_container = $PanelContainer
@onready var rich_text_label = $PanelContainer/RichTextLabel
@onready var reset_button := $ResetButton
@onready var option_button := $CanvasLayer/TransitionPrompt/OptionButton
@onready var transition_prompt := $CanvasLayer/TransitionPrompt
@onready var from_label := $CanvasLayer/TransitionPrompt/FromLabel
@onready var to_label := $CanvasLayer/TransitionPrompt/ToLabel
@onready var dropzones := [$StateCardDropzone, $StateCardDropzone2, $StateCardDropzone3, $StateCardDropzone4, $StateCardDropzone5, $StateCardDropzone6, $StateCardDropzone7, $StateCardDropzone8, $StateCardDropzone9, $StateCardDropzone10, $StateCardDropzone11]
var current_hovered_card : CardUI
var selected_transition_card: CardUI


func _ready() -> void:
    
    card_pile_ui.connect("card_hovered", func(card_ui):
        rich_text_label.text = card_ui.card_data.format_description()
        panel_container.visible = true
        current_hovered_card = card_ui
    )
    card_pile_ui.connect("card_unhovered", func(_card_ui):
        panel_container.visible = false
        current_hovered_card = null
    )
    
    # Connect to all dropzones
    var dropzones = []
    _collect_dropzones(get_tree().root, dropzones)
    for dropzone in dropzones:
        dropzone.connect("transition_card_dropped", _on_transition_card_dropped)
        
func _process(delta):
    if current_hovered_card:
        var target_pos = current_hovered_card.position
        target_pos.y += 30
        target_pos.x += 100
        panel_container.position = target_pos

#Buttons Functions

func _on_reset_button_pressed():
    card_pile_ui.reset()

func _get_transition_card():
    return "Transition A or B" if randi_range(0,1) else "Transition A and B"


func _on_sort_button_pressed():
    card_pile_ui.sort_hand(func(a, b): 
        if a.card_data.type == b.card_data.type:
            return a.card_data.value < b.card_data.value
        else:
            return a.card_data.type < b.card_data.type
    )

func _on_draw_transition_orand_button_pressed():
    if !card_pile_ui.hand_is_at_max_capacity():
        card_pile_ui.create_card_in_pile(_get_transition_card(), CardPileUI.Piles.hand_pile)

func _get_effect_card():
    return "Start State" if randi_range(0,1) else "Final State"
    
func _on_draw_effect_button_pressed():
    if !card_pile_ui.hand_is_at_max_capacity():
        card_pile_ui.create_card_in_pile(_get_effect_card(), CardPileUI.Piles.hand_pile)

func _on_discard_button_pressed():
    for card_ui in card_pile_ui.get_cards_in_pile(CardPileUI.Piles.hand_pile):
        card_pile_ui.set_card_pile(card_ui, CardPileUI.Piles.discard_pile)

func _on_transition_button_pressed(): #change pani nato
    populate_option_button_with_top_cards()
    transition_prompt.show()


func _on_transition_card_dropped(card_ui: CardUI):
    selected_transition_card = card_ui
    var droppedzone
    for dropzone in dropzones:
        var top_card = dropzone.get_top_card()
        if top_card == selected_transition_card:
            droppedzone = dropzone
    card_pile_ui.set_card_pile(selected_transition_card, CardPileUI.Piles.discard_pile)
    var dropzone_card = droppedzone.get_top_card()
    from_label.text = dropzone_card.card_data.nice_name
    populate_option_button_with_top_cards()
    
    transition_prompt.show()

func _on_confirm_button_pressed():
    if selected_transition_card:
        selected_transition_card = null
    transition_prompt.hide()

#OptionButton Functions
func _on_option_button_item_selected(index: int):
    var selected_card_name = option_button.get_item_text(index)
    to_label.text = selected_card_name

func populate_option_button_with_top_cards():
    option_button.clear()
    var top_cards = get_top_cards_from_all_dropzones(get_tree().root)
    for card_ui in top_cards:
        option_button.add_item(card_ui.card_data.nice_name)

func get_top_cards_from_all_dropzones(root: Node) -> Array:
    var top_cards := []
    for dropzone in dropzones:
        var top_card = dropzone.get_top_card()
        if top_card:
            top_cards.append(top_card)
    return top_cards
