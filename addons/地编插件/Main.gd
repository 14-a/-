@tool
extends EditorPlugin

# 按钮和面板的引用
var toggle_button: Button
var dock_panel: PanelContainer

func _enter_tree():
	# 1. 创建工具栏按钮
	toggle_button = Button.new()
	toggle_button.text = "显示面板"
	toggle_button.toggle_mode = true  # 设为切换按钮，可按下/弹起
	toggle_button.pressed.connect(_on_toggle_button_pressed)
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, toggle_button)

	# 2. 创建停靠面板
	dock_panel = _create_dock_panel()

	# 3. 将面板添加到编辑器停靠槽位（这里使用左侧槽位，并且放在左上角）
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_UL, dock_panel)

	# 4. 初始状态：面板隐藏（可根据需要调整）
	dock_panel.visible = false

func _exit_tree():
	# 清理工具栏按钮
	if is_instance_valid(toggle_button):
		remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, toggle_button)
		toggle_button.queue_free()

	# 清理停靠面板
	if is_instance_valid(dock_panel):
		remove_control_from_docks(dock_panel)
		dock_panel.queue_free()

func _create_dock_panel() -> PanelContainer:
	# 创建面板根容器
	var panel = PanelContainer.new()
	panel.name = "地编插件"
	panel.custom_minimum_size = Vector2(200, 0)  # 最小宽度

	# 面板内部布局
	var vbox = VBoxContainer.new()
	panel.add_child(vbox)

	var label = Label.new()
	label.text = "这是一个停靠面板"
	vbox.add_child(label)

	var info_button = Button.new()
	info_button.text = "面板内的按钮"
	info_button.pressed.connect(func():
		print("面板内按钮被点击")
	)
	vbox.add_child(info_button)

	return panel

func _on_toggle_button_pressed():
	if is_instance_valid(dock_panel):
		dock_panel.visible = toggle_button.button_pressed
