module main

import os
import gg
import gx
import net.websocket
import term


// This client should be compiled an run in different consoles
// it connects to the server who will broadcast your messages
// to all other connected clients
fn main() {
	mut ws := start_client()!
	defer {
		unsafe {
			ws.free()
		}
	}
	println(term.green('client ${ws.id} ready'))
	println('Write message and enter to send...')
	for {
		line := os.get_line()
		if line == '' {
			break
		}
		ws.write_string(line)!
	}
	ws.close(1000, 'normal') or {
		eprintln(term.red('ws.close err: ${err}'))
		exit(1)
	}
}

fn start_client() !&websocket.Client {
	mut ws := websocket.new_client('ws://localhost:30000')!
	// mut ws := websocket.new_client('wss://echo.websocket.org:443')?
	// use on_open_ref if you want to send any reference object
	ws.on_open(fn (mut ws websocket.Client) ! {
		println(term.green('ws.on_open websocket connected to the server and ready to send messages...'))
	})
	// use on_error_ref if you want to send any reference object
	ws.on_error(fn (mut ws websocket.Client, err string) ! {
		println(term.red('ws.on_error error: ${err}'))
	})
	// use on_close_ref if you want to send any reference object
	ws.on_close(fn (mut ws websocket.Client, code int, reason string) ! {
		println(term.green('ws.on_close the connection to the server successfully closed'))
	})
	// on new messages from other clients, display them in blue text
	ws.on_message(fn (mut ws websocket.Client, msg &websocket.Message) ! {
		if msg.payload.len > 0 {
			message := msg.payload.bytestr()
			println(term.blue('ws.on_message `${message}`'))
		}
	})

	ws.connect() or {
		eprintln(term.red('ws.connect error: ${err}'))
		return err
	}

	spawn ws.listen() // or { println(term.red('error on listen $err')) }
	return ws
}


struct Vec2 {
mut:
	x int
	y int
}

fn (a Vec2) + (b Vec2) Vec2 {
	return Vec2{a.x + b.x, a.y + b.y}
}

fn (a Vec2) - (b Vec2) Vec2 {
	return Vec2{a.x - b.x, a.y - b.y}
}

/*
struct Img {
mut:
	img gg.Image
	pos Vec2
	vel Vec2
	size f32
}
*/

struct App {
mut:
	ctx    &gg.Context = unsafe { nil }
	// img  Img
	// file_name string
}

const (
	win_width = 800
	win_height = 600
	speed = 5
)

fn main() {

	mut app := &App{
		ctx: 0,
        // file_name: "assets/human.png"
    }

	app.ctx = gg.new_context(
		bg_color: gx.white
		width: win_width
		height: win_height
		create_window: true
		window_title: "'gg' module template"
		frame_fn: frame
		user_data: app
		init_fn: init
	)
	app.ctx.run()
}

fn init(mut app &App) {
	// app.img.img = app.ctx.create_image(os.resource_abs_path(app.file_name))
    // app.img.pos = Vec2{60, 60}
    // app.img.size = 2
}

fn (mut app App) draw() {
    // app.ctx.draw_image(app.img.pos.x, app.img.pos.y, app.img.img.width*app.img.size, app.img.img.height*app.img.size, app.img.img)
}

fn frame(mut app &App) {
	// app.img.vel.x = 0
	// app.img.vel.y = 0


	// if app.ctx.pressed_keys[int(gg.KeyCode.a)] || app.ctx.pressed_keys[int(gg.KeyCode.left)] {
	// 	println("Left key down")
	// 	app.img.vel.x -= speed
	// }

	// if app.ctx.pressed_keys[int(gg.KeyCode.d)] || app.ctx.pressed_keys[int(gg.KeyCode.right)] {
	// 	println("Right key down")
	// 	app.img.vel.x += speed
	// }

	// if app.ctx.pressed_keys[int(gg.KeyCode.w)] || app.ctx.pressed_keys[int(gg.KeyCode.up)] {
	// 	println("Up key down")
	// 	app.img.vel.y -= speed
	// }

	// if app.ctx.pressed_keys[int(gg.KeyCode.s)] || app.ctx.pressed_keys[int(gg.KeyCode.down)] {
	// 	println("Down key down")
	// 	app.img.vel.y += speed
	// }


	// if app.ctx.pressed_keys[int(gg.KeyCode.escape)] {
	// 	exit(0)
	// }

	// app.img.pos.x += app.img.vel.x
	// app.img.pos.y += app.img.vel.y


	app.ctx.begin()
	app.draw()
	app.ctx.end()
}
