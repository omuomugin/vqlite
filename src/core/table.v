module core

pub struct Table {
pub mut:
	num_rows int
	pager    Pager
}

pub fn db_open(filepath string) ?Table {
	pager := pager_open(filepath) or {
		return error(err)
	}
	num_rows := 0
	return Table{
		num_rows: num_rows
		pager: pager
	}
}

fn (mut t Table) insert(row Row) ? {
	t.num_rows = t.num_rows + 1
	t.pager.write_page(row) or {
		return error(err)
	}
}

fn (t Table) select_all() []Row {
	row := t.pager.get_page() or {
		return []
	}
	return row
}
