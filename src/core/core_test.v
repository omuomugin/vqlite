import core
import os

const (
	test_db_file_name = './test.db'
)

fn create_db() {
	mut f := os.create(test_db_file_name) or {
		panic('[Error] failed to create test')
	}
	defer {
		f.close()
	}
}

fn delete_db() {
	os.rm(test_db_file_name) or {
		assert false
		return
	}
}

fn test_process_command__insert_single() {
	create_db()
	// target
	mut target_table := core.db_open(test_db_file_name) or {
		assert false
		return
	}
	// actual
	command := 'insert 1 user user@user.com'
	core.process_command(command, mut target_table) or {
		// do nothing
	}
	actual_entries_size := target_table.select_all().len
	// expect
	assert actual_entries_size == 1
	delete_db()
}

fn test_process_command__insert_single_zero_id() {
	create_db()
	// target
	mut target_table := core.db_open(test_db_file_name) or {
		assert false
		return
	}
	mut error_state := false
	// actual
	command := 'insert 0 user user@user.com'
	core.process_command(command, mut target_table) or {
		error_state = true
	}
	actual_entries_size := target_table.select_all().len
	// expect
	assert error_state == true
	assert actual_entries_size == 0
	delete_db()
}

fn test_process_command__insert_single_negative_id() {
	create_db()
	// target
	mut target_table := core.db_open(test_db_file_name) or {
		assert false
		return
	}
	mut error_state := false
	// actual
	command := 'insert -1 user user@user.com'
	core.process_command(command, mut target_table) or {
		error_state = true
	}
	actual_entries_size := target_table.select_all().len
	// expect
	assert error_state == true
	assert actual_entries_size == 0
	delete_db()
}

fn test_process_command__insert_single_long_username() {
	create_db()
	// target
	mut target_table := core.db_open(test_db_file_name) or {
		assert false
		return
	}
	// username with 32 char long
	mut long_username := ''
	for _ in 0 .. 32 {
		long_username += 'a'
	}
	assert long_username.len == 32
	// actual
	command := 'insert 1 $long_username user@user.com'
	core.process_command(command, mut target_table) or {
		// do nothing
	}
	actual_entries_size := target_table.select_all().len
	// expect
	assert actual_entries_size == 1
	delete_db()
}

fn test_process_command__insert_single_long_username_error() {
	create_db()
	// target
	mut target_table := core.db_open(test_db_file_name) or {
		assert false
		return
	}
	mut error_state := false
	// username with 33 char long
	mut long_username := ''
	for _ in 0 .. 33 {
		long_username += 'a'
	}
	// actual
	command := 'insert 1 $long_username user@user.com'
	core.process_command(command, mut target_table) or {
		error_state = true
	}
	actual_entries_size := target_table.select_all().len
	// expect
	assert error_state == true
	assert actual_entries_size == 0
	delete_db()
}

fn test_process_command__insert_single_long_email() {
	// start
	create_db()
	// target
	mut target_table := core.db_open(test_db_file_name) or {
		assert false
		return
	}
	// email with 255 char long
	mut long_email := ''
	for i in 0 .. 255 {
		if i == 128 {
			long_email += '@'
		} else {
			long_email += 'a'
		}
	}
	// actual
	command := 'insert 1 user $long_email'
	core.process_command(command, mut target_table) or {
		// do nothing
	}
	actual_entries_size := target_table.select_all().len
	// expect
	assert actual_entries_size == 1
	// end
	delete_db()
}

fn test_process_command__insert_single_long_email_error() {
	// start
	create_db()
	// target
	mut target_table := core.db_open(test_db_file_name) or {
		assert false
		return
	}
	mut error_state := false
	// email with 256 char long
	mut long_email := ''
	for i in 0 .. 256 {
		if i == 128 {
			long_email += '@'
		} else {
			long_email += 'a'
		}
	}
	// actual
	command := 'insert 1 user $long_email'
	core.process_command(command, mut target_table) or {
		error_state = true
	}
	actual_entries_size := target_table.select_all().len
	// expect
	assert error_state == true
	assert actual_entries_size == 0
	// end
	delete_db()
}

fn test_process_command__insert_single_email_without_at_sign() {
	// start
	create_db()
	// target
	mut target_table := core.db_open(test_db_file_name) or {
		assert false
		return
	}
	mut error_state := false
	// actual
	command := 'insert 1 user aaaaaa'
	core.process_command(command, mut target_table) or {
		error_state = true
	}
	actual_entries_size := target_table.select_all().len
	// expect
	assert error_state == true
	assert actual_entries_size == 0
	// end
	delete_db()
}

fn test_process_command__insert_multiple() {
	// start
	create_db()
	// target
	mut target_table := core.db_open(test_db_file_name) or {
		assert false
		return
	}
	// actual
	for i in 1 .. 3 {
		command := 'insert $i user user@user.com'
		core.process_command(command, mut target_table) or {
			// do nothing
		}
	}
	actual_entries_size := target_table.select_all().len
	// expect
	assert actual_entries_size == 2
	// end
	delete_db()
}

fn test_process_command__insert_max() {
	// start
	create_db()
	// target
	mut target_table := core.db_open(test_db_file_name) or {
		assert false
		return
	}
	// actual
	// table size is 4096 and row_size is 291
	// so 291 * 14 = 4074 is the max entry size
	for i in 1 .. 15 {
		command := 'insert $i user user@user.com'
		core.process_command(command, mut target_table) or {
			// do nothing
		}
	}
	actual_entries_size := target_table.select_all().len
	// expect
	assert actual_entries_size == 14
	// end
	delete_db()
}

fn test_process_command__insert_more_then_max() {
	// start
	create_db()
	// target
	mut target_table := core.db_open(test_db_file_name) or {
		assert false
		return
	}
	mut error_state := false
	// actual
	// table size is 4096 and row_size is 291
	// so 291 * 14 = 4074 is the max entry size
	for i in 1 .. 16 {
		command := 'insert $i user user@user.com'
		core.process_command(command, mut target_table) or {
			error_state = true
		}
	}
	actual_entries_size := target_table.select_all().len
	// expect
	assert error_state == true
	assert actual_entries_size == 14
	// end
	delete_db()
}
