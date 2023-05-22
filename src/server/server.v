module server

import time
import log
import net
import io

struct Server {
pub:
	port       int
	host       string
	started_on time.Time
pub mut:
	log   log.Log
	debug log.Log
mut:
	server net.TcpListener
	sock   &net.TcpConn
}

pub fn new(port int, host string) !Server {
	mut srv := Server{
		port: port
		host: host
		started_on: time.now()
		sock: 0
	}

	srv.server = net.listen_tcp(.ip, '${host}:${port}')!
	srv.log = log.Log{}
	srv.log.set_level(.info)
	srv.log.set_full_logpath('./Crimson.log')
	srv.log.log_to_console_too()

	srv.debug = log.Log{}
	srv.debug.set_level(.info)
	srv.debug.set_full_logpath('./Debug.log')

	return srv
}

pub fn (mut s Server) start() ! {
	laddr := s.server.addr()!
	s.log.info('Ready on ${laddr} ...')
	for {
		mut socket := s.server.accept()!
		s.sock = socket
		spawn s.handle(mut socket)
	}
}

fn (mut s Server) handle(mut socket net.TcpConn) {
	client_addr := socket.peer_addr() or { return }
	s.log.info('[+] new client: ${client_addr}')
	mut reader := io.new_buffered_reader(reader: socket)
	defer {
		unsafe {
			reader.free()
		}
	}
	for {
		received_line := reader.read_line() or { return }
		if received_line == '' {
			return
		}
		s.debug.debug('recived ${client_addr}: ${received_line}')
	}
}
