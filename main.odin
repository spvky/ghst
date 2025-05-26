package ghst

import "base:runtime"
import "core:log"

import sapp "shared:sokol/app"
import shelpers "shared:sokol/helpers"
import sglue "shared:sokol/glue"
import sg "shared:sokol/gfx"

default_context: runtime.Context

main :: proc() {
	context.logger = log.create_console_logger()
	default_context = context

	sapp.run({
		width = 800,
		height = 600,
		window_title = "hello Sokol",
		allocator = sapp.Allocator(shelpers.allocator(&default_context)),
		logger = sapp.Logger(shelpers.logger(&default_context)),

		init_cb = init_cb,
		frame_cb = frame_cb,
		cleanup_cb = cleanup_cb,
		event_cb = event_cb
	})
}

// Runs when the app starts, defining our graphics context
init_cb :: proc "c" () {
	context = default_context
	sg.setup({
		// Use sokol helpers to determing proper GPU interface
		environment = shelpers.glue_environment(),
		// Use the default context to assign our allocator and loggers
		allocator = sg.Allocator(shelpers.allocator(&default_context)),
		logger = sg.Logger(shelpers.logger(&default_context))
	})
}

// Runs on app exit
cleanup_cb :: proc "c" () {
	context = default_context
	sg.shutdown()
}

// Runs each render frame
frame_cb :: proc "c" () {
	context = default_context
	// Takes in a swapchain, which is essentially a chain of framebuffers
	sg.begin_pass({swapchain = shelpers.glue_swapchain()})

	// Drawing logic

	// End our drawing pass
	sg.end_pass()

	// Commit the changes from the drawing pass
	sg.commit()
}


event_cb :: proc "c" (ev: ^sapp.Event) {
	context = default_context
	if ODIN_DEBUG {
		log.debug(ev.type)
	}
}

