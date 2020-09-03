module core

struct Row {
	id       u32
	username string
	email    string
}

fn create_row_with_validation(id u32, username, email string) ?Row {
	if id < 1 {
		return error('field id should be positive integer')
	}
	if username.len > 32 {
		return error('field username should be less than 32')
	}
	if email.len > 255 {
		return error('field email should be less than 255')
	}
	if !email.contains('@') {
		return error('field email should be valid format')
	}
	return Row{
		id: id
		username: username
		email: email
	}
}
