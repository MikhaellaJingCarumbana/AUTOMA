extends CardDropzone

@export var accept_type : String

func can_drop_card(card_ui : CardUI):
    #if card_ui.card_data.type != accept_type:
        #return false

    # If trying to drop a "state" card, ensure no other "state" cards are held
    if card_ui.card_data.type == "state":
        for held_card in _held_cards:
            if held_card.card_data.type == "state":
                return false

    return true
