module core

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
		id := parse_id(command_args[1]) or {
			println(err)
			return error("[Error] Syntax error \'$command\'")
		}
		row_to_insert := create_row_with_validation(id, command_args[2], command_args[3]) or {
			println(err)
			return error("[Error] Syntax error \'$command\'")
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

fn parse_id(str string) ?u32 {
	if str == '0' {
		return 0
	}
	parsed_int := str.u32()
	// when failed parse, `str.u32()` will return 0
	if parsed_int == 0 {
		return error("string parsing to u32 failed \'$str\'")
	}
	return parsed_int
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
			execute_select(statement, mut table)
			println('Executed')
		}
	}
}

fn execute_insert(statement Statement, mut table Table) ? {
	table.insert(statement.row_to_insert) or {
		return error(err)
	}
}

fn execute_select(statement Statement, mut table Table) {
	str := table.select_all()
	println(str)
}
