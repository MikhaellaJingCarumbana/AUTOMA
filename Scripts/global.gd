extends Node


var gameStarted : bool

var playerBody : CharacterBody2D
var playerWeaponEquip : bool
var playerAlive: bool
var playerDamageZone : Area2D
var playerDamageAmount : int

var setDamageZone : Area2D
var setDamageAmount : int
# Called when the node enters the scene tree for the first time.

	
var active_line: Line2D = null
var active_line2: Line2D = null
var start_button: Button = null
var start_button2: Button = null
var end_button: Button = null

func set_active_line(line: Line2D):
	active_line = line
	active_line2 = line

func clear_active_line():
	active_line = null
	active_line2 = null
	start_button = null
	end_button = null

func get_active_line2() -> Line2D:
	return active_line2 
	
func get_active_line() -> Line2D:
	return active_line

func set_start_button(button: Button):
	start_button = button
	
func set_start_button2(button: Button):
	start_button2 = button

func set_end_button(button: Button):
	end_button = button

func get_start_button() -> Button:
	return start_button

func get_start_button2() -> Button:
	return start_button2
	
func get_end_button() -> Button:
	return end_button
