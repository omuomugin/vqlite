module core

pub struct Table {
pub mut:
	pager Pager
}

pub fn db_open(filepath string) ?Table {
	pager := pager_open(filepath) or {
		return error(err)
	}
	return Table{
		pager: pager
	}
}

fn (mut t Table) insert(row Row) ? {
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
