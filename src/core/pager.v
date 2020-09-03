module core

import os
import encoding.binary

struct Pager {
pub:
	filepath string
}

const (
	page_size            = 4096
	column_id_size       = int(sizeof(u32))
	column_username_size = int(32)
	column_email_size    = int(255)
	row_size             = column_id_size + column_username_size + column_email_size
	id_offset            = 0
	username_offset      = id_offset + column_id_size
	email_offset         = username_offset + column_username_size
)

fn pager_open(filepath string) ?Pager {
	return Pager{
		filepath: filepath
	}
}

fn (pager Pager) get_page() ?[]Row {
	mut f := os.open_file(pager.filepath, 'rb', 0o666) or {
		return error('[Error] get_page - Failed to open file : $err')
	}
	defer {
		f.close()
	}
	file_size := os.file_size(pager.filepath)
	num_rows := file_size / row_size
	mut rows := []Row{}
	for i in 0 .. num_rows {
		row_head_pos := i * row_size
		id := binary.little_endian_u32(f.read_bytes_at(column_id_size, row_head_pos + id_offset))
		username := f.read_bytes_at(column_username_size, row_head_pos + username_offset).bytestr()
		email := f.read_bytes_at(column_email_size, row_head_pos + email_offset).bytestr()
		rows << Row{
			id: id
			username: username
			email: email
		}
	}
	return rows
}

fn (mut p Pager) write_page(row Row) ? {
	mut f := os.open_file(p.filepath, 'wb+', 0o666) or {
		return error('[Error] write_page - Failed to open file : $err')
	}
	defer {
		f.close()
	}
	if os.file_size(p.filepath) + row_size > page_size {
		return error('[Error] Table is full.')
	}
	// `write_bytes` will use fwrite internally and it will move fd to end of file.
	f.write_bytes(row.id, column_id_size)
	f.write_bytes(row.username.str, column_username_size)
	f.write_bytes(row.email.str, column_email_size)
}
