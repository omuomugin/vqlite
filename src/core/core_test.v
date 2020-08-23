import core

fn test_process_command__insert_single() {
	mut target_table := core.Table{}
	command := 'insert 1 user user@user.com'
	core.process_command(command, mut target_table) or {
		// do nothing
	}
	assert target_table.num_rows == 1
}

fn test_process_command__insert_multiple() {
	mut target_table := core.Table{}
	for i in 1 .. 3 {
		command := 'insert $i user user@user.com'
		core.process_command(command, mut target_table) or {
			// do nothing
		}
	}
	assert target_table.num_rows == 2
}

fn test_process_command__insert_max() {
	mut target_table := core.Table{}
	for i in 1 .. 101 {
		command := 'insert $i user user@user.com'
		core.process_command(command, mut target_table) or {
			// do nothing
		}
	}
	assert target_table.num_rows == 100
}

fn test_process_command__insert_more_thean_max() {
	mut target_table := core.Table{}
	mut error_state := false
	for i in 1 .. 102 {
		command := 'insert $i user user@user.com'
		core.process_command(command, mut target_table) or {
			println(err)
			error_state = true
		}
	}
	assert error_state == true
}
