use std::io;

fn main() {
  int a = 5;
  int i = 0;

  loop {
    a = a + 1;
  }

  while a < 10 {
    a = a + 1;
  }
  
  for i in 3..a {
    println!("i");
    int b = 5;
    int c = b + a;
  }

  return;
}