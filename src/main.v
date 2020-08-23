module main

import readline
import core

enum MetaCommandResult {
	success
	exit
}

fn main() {
	mut readline := readline.Readline{}
	mut table := core.Table{}
	for {
		oline := readline.read_line('db > ') or {
			break
		}
		input := oline.trim_space()
		meta_command_result := do_meta_command(input) or {
			println(err)
			continue
		}
		match meta_command_result {
			.success {
				// do nothing
			}
			.exit {
				println('Bye Bye')
				break
			}
		}
		core.process_command(input, mut table) or {
			println(err)
			continue
		}
	}
}

fn do_meta_command(command string) ?MetaCommandResult {
	if command.starts_with('.') {
		if command == '.exit' {
			return MetaCommandResult.exit
		} else {
			return error("Unrecognized command \'$command\'")
		}
	}
	return MetaCommandResult.success
}
