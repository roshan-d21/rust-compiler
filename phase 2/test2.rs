use std::io;

fn main() {
  int age = 5;

  if age >= 18 {
    int canVote = 1;
    println!("Old enough");
  } else {
    int canVote = 0;
    println!("Too young");
  }

  return;
}