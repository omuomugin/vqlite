import core

fn test_process_command__insert_single() {
	mut target_table := core.Table{}
	command := 'insert 1 user user@user.com'
	core.process_command(command, mut target_table) or {
		// do nothing
	}
	assert target_table.num_rows == 1
}

fn test_process_command__insert_single_zero_id() {
	mut target_table := core.Table{}
	mut error_state := false
	command := 'insert 0 user user@user.com'
	core.process_command(command, mut target_table) or {
		error_state = true
	}
	assert error_state == true
	assert target_table.num_rows == 0
}

fn test_process_command__insert_single_negative_id() {
	mut target_table := core.Table{}
	mut error_state := false
	command := 'insert -1 user user@user.com'
	core.process_command(command, mut target_table) or {
		error_state = true
	}
	assert error_state == true
	assert target_table.num_rows == 0
}

fn test_process_command__insert_single_long_username() {
	mut target_table := core.Table{}
	// username with 32 char long
	mut long_username := ''
	for _ in 0 .. 32 {
		long_username += 'a'
	}
	command := 'insert 1 $long_username user@user.com'
	core.process_command(command, mut target_table) or {
		// do nothing
	}
	assert target_table.num_rows == 1
}

fn test_process_command__insert_single_long_username_error() {
	mut target_table := core.Table{}
	mut error_state := false
	// username with 33 char long
	mut long_username := ''
	for _ in 0 .. 33 {
		long_username += 'a'
	}
	command := 'insert 1 $long_username user@user.com'
	core.process_command(command, mut target_table) or {
		error_state = true
	}
	assert error_state == true
	assert target_table.num_rows == 0
}

fn test_process_command__insert_single_long_email() {
	mut target_table := core.Table{}
	// email with 255 char long
	mut long_email := ''
	for _ in 0 .. 255 {
		long_email += 'a'
	}
	command := 'insert 1 user $long_email'
	core.process_command(command, mut target_table) or {
		// do nothing
	}
	assert target_table.num_rows == 1
}

fn test_process_command__insert_single_long_email_error() {
	mut target_table := core.Table{}
	mut error_state := false
	// email with 256 char long
	mut long_email := ''
	for _ in 0 .. 256 {
		long_email += 'a'
	}
	command := 'insert 1 user $long_email'
	core.process_command(command, mut target_table) or {
		error_state = true
	}
	assert error_state == true
	assert target_table.num_rows == 0
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
	assert target_table.num_rows == 100
}
