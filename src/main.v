module main

import readline
import util

const (
	table_max_size = 100
)

enum MetaCommandResult {
	success
	exit
}

struct Statement {
	statement_type StatementType
	row_to_insert  Row
}

enum StatementType {
	type_insert
	type_select
}

struct Row {
	id       u32
	username string
	email    string
}

struct Table {
mut:
	num_rows u32
	pages    []Row
}

fn main() {
	prompt := 'db > '
	mut readline := readline.Readline{}
	mut table := Table{}
	for {
		oline := readline.read_line(prompt) or {
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
		statement := prepare_statement(input) or {
			println(err)
			continue
		}
		execute_statement(statement, mut table)
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

fn prepare_statement(command string) ?Statement {
	// [0]: command, [1]: arg ...
	command_args := command.split(' ')
	if command_args[0] == 'insert' {
		// command should be `insert :id :username :email`
		if command_args.len < 3 {
			return error("Syntax error \'$command\'")
		}
		// if the first element was not `int` return error
		id := util.s_to_u32(command_args[1]) or {
			println(err)
			return error("Syntax error \'$command\'")
		}
		row_to_insert := Row{
			id: id
			username: command_args[2]
			email: command_args[3]
		}
		return Statement{
			statement_type: StatementType.type_insert
			row_to_insert: row_to_insert
		}
	} else if command_args[0] == 'select' {
		return Statement{
			statement_type: StatementType.type_select
		}
	}
	return error("Unrecognized statement \'$command\'")
}

fn execute_statement(statement Statement, mut table Table) {
	match statement.statement_type {
		.type_insert { execute_insert(statement, mut table) or {
				println(err)
			} }
		.type_select { execute_select(statement, mut table) or {
				println(err)
			} }
	}
}

fn execute_insert(statement Statement, mut table Table) ? {
	if table.num_rows >= table_max_size {
		return error('failed to insert table was full. max page size is $table_max_size')
	}
	table.pages << statement.row_to_insert
	table.num_rows = table.num_rows + 1
}

fn execute_select(statement Statement, mut table Table) ? {
	println('$table.pages')
}
