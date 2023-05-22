module config

import toml
import os

pub const name = 'Crimson.toml'

const default = '[server]
port = 25565
host = "0.0.0.0"
'

[inline]
pub fn read() !toml.Doc {
	doc := toml.parse_file(config.name)!

	return doc
}

[inline]
pub fn write_default() ! {
	os.write_file(config.name, config.default)!
}
