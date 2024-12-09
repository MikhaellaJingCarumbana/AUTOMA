extends CardDropzone


@export var accept_type : String

func can_drop_card(card_ui: CardUI):
    return card_ui.card_data.type == accept_type
