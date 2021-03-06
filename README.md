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
docker image build -t compiler:latest .
```
```bash
docker container run --name cdproject -v "$(pwd)":/root/rust-compiler -it compiler:latest
````

## Usage

Using `make`:

```bash
make parse
```
Or compile each file individually:

```bash
$ flex parser.l
$ yacc parser.y
$ gcc y.tab.c -lfl -w
$ ./a.out test.rs
```

## Team Members

- Naveen K Murthy - PES2201800051
- Siva Surya Babu - PES2201800475
- Roshan Daivajna - PES2201800372