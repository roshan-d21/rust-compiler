# Rust-Compiler

## Introduction

**Problem Statement:** Build a basic Rust compiler.

The compiler performs the following tasks:
  1. Lexical Analysis
  2. Symbol Table Generation
  3. Syntax Analysis

## Usage

```bash
$ flex parser.l
$ yacc parser.y
$ gcc y.tab.c -lfl -w
$ ./a.out test.rs
```