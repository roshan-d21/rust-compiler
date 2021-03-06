use std::io;

fn main() {
  let a = 0b1010;
  let c = 0o77;
  let d = 0xfff;

  io::stdin().read_line(&a);

  while a < 10 {
    if a == 0 {
      let b = "local variable";
    }
    a += 1;
    println!(b);
  }
}