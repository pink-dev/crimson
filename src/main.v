module main

import server

fn main() {
	mut srv := server.new(25565, '0.0.0.0')!

	srv.start()!
}
