import readline

fn main() {
	prompt := 'db > '
	mut readline := readline.Readline{}
	for {
		oline := readline.read_line(prompt) or {
			println('[Error] cannot read line')
			break
		}
		line := oline.trim_space()
		if line == '.exit' {
			break
		} else {
			println('Unrecognized command $line')
		}
	}
}
