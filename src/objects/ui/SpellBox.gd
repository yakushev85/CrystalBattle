extends Node2D

var spells_data = [
	{"name": "HealSpell", "cost": 23}, 
	{"name": "IncreaseDamageSpell", "cost": 42}, 
	{"name": "EnemySkipSpell", "cost": 51}, 
	{"name": "RandomLineSpell", "cost": 63}, 
	{"name": "ReflectDamageSpell", "cost": 74}, 
	{"name": "RegenSpaceSpell", "cost": 85}
	]
var visible_spells = []
var selected_spell
var is_selection_allowed

func _ready():
	is_selection_allowed = true
	clear_selection()

func clear_visible_spells():
	for spell in spells_data:
		get_node(spell.name).hide()

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


func get_cost_by_spell(sname):
	for spell in spells_data:
		if spell.name == sname:
			return spell.cost
	
	return 0

func select_spell_event(event, spell_name):
	if is_selection_allowed and event is InputEventMouseButton and not (event as InputEventMouseButton).is_pressed():
		select_spell(spell_name)

func _on_HealSpell_gui_input(event):
	select_spell_event(event, "HealSpell")


func _on_IncreaseDamageSpell_gui_input(event):
	select_spell_event(event, "IncreaseDamageSpell")


func _on_EnemySkipSpell_gui_input(event):
	select_spell_event(event, "EnemySkipSpell")


func _on_RandomLineSpell_gui_input(event):
	select_spell_event(event, "RandomLineSpell")


func _on_ReflectDamageSpell_gui_input(event):
	select_spell_event(event, "ReflectDamageSpell")


func _on_RegenSpaceSpell_gui_input(event):
	select_spell_event(event, "RegenSpaceSpell")
