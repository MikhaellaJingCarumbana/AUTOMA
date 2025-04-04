extends Node2D


@onready var card_pile_ui := $CardPileUI
@onready var panel_container = $PanelContainer
@onready var rich_text_label = $PanelContainer/RichTextLabel
@onready var reset_button := $ResetButton

var current_hovered_card : CardUI

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
        
func _process(delta):
    if current_hovered_card:
        var target_pos = current_hovered_card.position
        target_pos.y += 30
        target_pos.x += 100
        panel_container.position = target_pos

func _on_reset_button_pressed():
    card_pile_ui.reset()

func _get_transition_card():
    return "Transition A or B" if randi_range(0,1) else "Transition A and B"


func _on_sort_button_pressed():
    card_pile_ui.sort_hand(func(a, b): 
        if a.card_data.type == b.card_data.type:
            return a.card_data.value < b.card_data.value
        else:
            return a.card_data.suit < b.card_data.suit
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
