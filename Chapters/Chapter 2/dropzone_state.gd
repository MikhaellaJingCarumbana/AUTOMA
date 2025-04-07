class_name DropzoneState extends CardDropzone

@export var accept_type : String

signal transition_card_dropped(card_ui: CardUI)

func can_drop_card(card_ui : CardUI):
    #if card_ui.card_data.type != accept_type:
        #return false

    # If trying to drop a "state" card, ensure no other "state" cards are held
    if card_ui.card_data.type == "state":
        for held_card in _held_cards:
            if held_card.card_data.type == "state":
                return false

    return true

func card_ui_dropped(card_ui: CardUI):
    super.card_ui_dropped(card_ui)

    if card_ui.card_data.type == "transition" or card_ui.card_data.type == "transition":
        emit_signal("transition_card_dropped", card_ui)
