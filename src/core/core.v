module core

import util

const (
	table_max_size = 100
)

pub struct Table {
pub mut:
	num_rows u32
	pages    []Row
}

struct Row {
	id       u32
	username string
	email    string
}

struct Statement {
	statement_type StatementType
	row_to_insert  Row
}

enum StatementType {
	type_insert
	type_select
}

pub fn process_command(command string, mut table Table) ? {
	statement := prepare_statement(command) or {
		println(err)
		return error('[Error] Preparing Statement failed')
	}
	execute_statement(statement, mut table) or {
		return error('[Error] Executing Statement failed')
	}
}

fn prepare_statement(command string) ?Statement {
	// [0]: command, [1]: arg ...
	command_args := command.split(' ')
	if command_args[0] == 'insert' {
		// command should be `insert :id :username :email`
		if command_args.len < 3 {
			return error("[Error] Syntax error \'$command\'")
		}
		// if the first element was not `int` return error
		id := util.s_to_u32(command_args[1]) or {
			println(err)
			return error("[Error] Syntax error \'$command\'")
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
	return error("[Error] Unrecognized statement \'$command\'")
}

fn execute_statement(statement Statement, mut table Table) ? {
	match statement.statement_type {
		.type_insert {
			execute_insert(statement, mut table) or {
				println(err)
				return error("[Error] failed to execute statement \'$statement\'")
			}
			println('Executed')
		}
		.type_select {
			execute_select(statement, mut table) or {
				println(err)
				return error("[Error] failed to execute statement \'$statement\'")
			}
			println('Executed')
		}
	}
}

fn execute_insert(statement Statement, mut table Table) ? {
	if table.num_rows >= table_max_size {
		return error('[Error] failed to insert table was full. max page size is $table_max_size')
	}
	table.pages << statement.row_to_insert
	table.num_rows = table.num_rows + 1
}

fn execute_select(statement Statement, mut table Table) ? {
	for page in table.pages {
		println('($page.id, $page.username, $page.email)')
	}
}
