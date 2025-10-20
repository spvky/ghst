package main

import buttons "./ui/buttons"
import "core:fmt"
import rl "vendor:raylib"

button_row: buttons.Button_Container
Menu_Config :: struct {
	primary:  Primary_Menu,
	save_box: bool,
}

config: Menu_Config

Primary_Menu :: enum {
	Display,
	Sound,
	Controls,
}

// Runs examples
main :: proc() {
	rl.InitWindow(1600, 900, "ghst")
	init()
	defer rl.CloseWindow()

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)
		buttons.draw_button_container(button_row)
		if config.save_box {
			rl.DrawRectangle(500, 238, 600, 450, rl.GRAY)
		}
		rl.EndDrawing()
	}
}


init :: proc() {
	button_row = buttons.make_button_container({500, 200}, buttons.Button {
		text = "Save",
		callback = proc() {
			config.save_box = !config.save_box
		},
	}, buttons.Button {
		text = "No",
		callback = proc() {fmt.println("No")},
	})
}
