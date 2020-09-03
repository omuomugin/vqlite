## What
https://cstack.github.io/db_tutorial/
sqlite clone written in vlang (original article are with C)

## Contents
- [x] Part 1 - Introduction and Setting up the REPL
- [x] Part 2 - World’s Simplest SQL Compiler and Virtual Machine
- [x] Part 3 - An In-Memory, Append-Only, Single-Table Database
- [x] Part 4 - Our First Tests (and Bugs)
- [ ] Part 5 - Persistence to Disk
    - [x] without cache
    - [ ] with cache
- [ ] Part 6 - The Cursor Abstraction
- [ ] Part 7 - Introduction to the B-Tree
- [ ] Part 8 - B-Tree Leaf Node Format
- [ ] Part 9 - Binary Search and Duplicate Keys
- [ ] Part 10 - Splitting a Leaf Node
- [ ] Part 11 - Recursively Searching the B-Tree
- [ ] Part 12 - Scanning a Multi-Level B-Tree
- [ ] Part 13 - Updating Parent Node After a Split

## Structure
```
.
├── README.md
├── bin         # build artifacts
│   └── main
├── check.sh    # check with v fmt
├── run.sh      # build and run v program
└── src         # source
    └── main.v
```

![architecture overview](./assets/architecture.gif)  
by https://www.sqlite.org/arch.html
