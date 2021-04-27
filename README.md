# Rust-Compiler

## Introduction

**Problem Statement:** Build a basic Rust compiler.

The compiler performs the following tasks:
  1. Lexical Analysis
  2. Symbol Table Generation
  3. Syntax Analysis

## Installing Dependencies

This project uses `lex` and `yacc`

```bash
sudo apt-get install -y flex byacc bison
```

Or use the `Dockerfile` instead:

```bash
docker image build -t lex-yacc:latest .
```
```bash
docker container run --name cdproject -it lex-yacc:latest
```

## Usage

### For Phase 1 of the compiler (Lexical and Syntactical Analysis)

```bash
cd phase\ 1
```

Using `make`:

```bash
make parse
```
Or compile each file individually:

```bash
flex parser.l
yacc parser.y
gcc y.tab.c -lfl -w
./a.out test.rs
```

---

### For Phase 2 of the compiler (ICG and Code Optimization)

```bash
cd phase\ 2
```

To Generate ICG:

```bash
make parse
```

Or compile each file individually:

```bash
flex parser-v2.l
yacc parser-v2.y
gcc y.tab.c -lfl -w
./a.out test.rs
```

To optimize ICG code:

```bash
python3 code_optimizer.py icg.txt
```

## Team Members

- Naveen K Murthy - PES2201800051
- Siva Surya Babu - PES2201800475
- Roshan Daivajna - PES2201800372