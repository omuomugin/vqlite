import readline

enum Meta_Command_Result {
	success
	exit
}

struct Statement {
	statement_type Statement_type
}

enum Statement_type {
	type_insert
	type_select
}

fn main() {
	prompt := 'db > '
	mut readline := readline.Readline{}
	for {
		oline := readline.read_line(prompt) or {
			println('[Error] cannot read line')
			break
		}
		input := oline.trim_space()
		if input == '.exit' {
			break
		}
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
		statement := prepare_statement(input) or {
			println(err)
			continue
		}
		execute_statement(statement)
	}
}

fn do_meta_command(command string) ?Meta_Command_Result {
	if command.starts_with('.') {
		if command == '.exit' {
			return Meta_Command_Result.exit
		} else {
			return error('Unrecognized command $command')
		}
	}
	return Meta_Command_Result.success
}

fn prepare_statement(command string) ?Statement {
	if command.starts_with('insert') {
		return Statement{
			statement_type: Statement_type.type_insert
		}
	} else if command.starts_with('select') {
		return Statement{
			statement_type: Statement_type.type_select
		}
	}
	return error('Unrecognized statement $command')
}

fn execute_statement(statement Statement) {
	match statement.statement_type {
		.type_insert { println('This is where we would do an insert.') }
		.type_select { println('This is where we would do a select.') }
	}
}
