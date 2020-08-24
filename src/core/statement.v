module core

struct Statement {
	statement_type StatementType
	row_to_insert  Row
}

enum StatementType {
	type_insert
	type_select
}
