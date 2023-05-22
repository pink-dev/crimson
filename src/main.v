module main

import server
import config
import os

fn main() {
	if !os.exists(config.name) {
		config.write_default()!
	}

	cfg := config.read()!

	mut srv := server.new(cfg.value('server.port').int(), cfg.value('server.host').string())!

	srv.start()!
}
