extends Node2D

var available_spells = ["HealSpell", "IncreaseDamageSpell", "EnemySkipSpell", "RandomLineSpell", "ReflectDamageSpell", "RegenSpaceSpell"]
var visible_spells = []
var selected_spell
var is_selection_allowed

func _ready():
	is_selection_allowed = true
	clear_selection()

func clear_visible_spells():
	for spell in available_spells:
		get_node(spell).hide()

func set_visible_spells(vs):
	clear_visible_spells()
	visible_spells = vs
	
	for spell in visible_spells:
		get_node(spell).show()
	
func clear_selection():
	selected_spell = null
	$SelectLabel.hide()

func select_spell(v):
	if selected_spell == v:
		clear_selection()
		return
	
	var selectedSpellNode = get_node(v) as TextureRect
	selected_spell = v
	
	$SelectLabel.rect_position = selectedSpellNode.rect_position
	$SelectLabel.show()


func _on_HealSpell_gui_input(event):
	if is_selection_allowed and event is InputEventMouseButton and not (event as InputEventMouseButton).is_pressed():
		select_spell("HealSpell")


func _on_IncreaseDamageSpell_gui_input(event):
	if is_selection_allowed and event is InputEventMouseButton and not (event as InputEventMouseButton).is_pressed():
		select_spell("IncreaseDamageSpell")


func _on_EnemySkipSpell_gui_input(event):
	if is_selection_allowed and event is InputEventMouseButton and not (event as InputEventMouseButton).is_pressed():
		select_spell("EnemySkipSpell")


func _on_RandomLineSpell_gui_input(event):
	if is_selection_allowed and event is InputEventMouseButton and not (event as InputEventMouseButton).is_pressed():
		select_spell("RandomLineSpell")


func _on_ReflectDamageSpell_gui_input(event):
	if is_selection_allowed and event is InputEventMouseButton and not (event as InputEventMouseButton).is_pressed():
		select_spell("ReflectDamageSpell")


func _on_RegenSpaceSpell_gui_input(event):
	if is_selection_allowed and event is InputEventMouseButton and not (event as InputEventMouseButton).is_pressed():
		select_spell("RegenSpaceSpell")
