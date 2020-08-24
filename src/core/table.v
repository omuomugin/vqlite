module core

const (
	table_max_size = 100
)

pub struct Table {
pub mut:
	num_rows u32
	pages    []Row
}

fn (mut t Table) insert(row Row) {
	t.pages << row
	t.num_rows = t.num_rows + 1
}
