extends Control

@onready var sts: Label = %STS


func calculate():
	var sum = 0
	
	for i in get_children():
		sum += i.get_STS()
		
		sts.text = str(sum)
		
