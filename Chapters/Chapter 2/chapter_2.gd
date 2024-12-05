extends Node2D


@onready var card_pile_ui := $CardPileUI
@onready var panel_container = $PanelContainer
@onready var rich_text_label = $PanelContainer/RichTextLabel

var current_hovered_card : CardUI

func _ready() -> void:
    card_pile_ui.draw(5)
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
        target_pos.y += 80
        target_pos.x += 180
        panel_container.position = target_pos
