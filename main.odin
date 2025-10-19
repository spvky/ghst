package main

import buttons "./ui/buttons"
import "core:fmt"
import rl "vendor:raylib"

button_row: buttons.Button_Container

// Runs examples 

main :: proc() {
	rl.InitWindow(1600, 900, "ghst")
	init()
	defer rl.CloseWindow()

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		buttons.draw_button_container(button_row)
		rl.EndDrawing()
	}
}


init :: proc() {
	button_row = buttons.make_button_container({500, 500}, buttons.Button {
		text = "Yes",
		callback = proc() {fmt.println("Yes")},
	}, buttons.Button {
		text = "No",
		callback = proc() {fmt.println("No")},
	})
}
