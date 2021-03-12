use std::io;

fn main() {
  let a = 0b1010;
  static c = 0o77;
  const d = 0xfff;

  io::stdin().read_line(&a);

  loop {
    a += 1;
  }

  for i in (3...a) {
    println!(i);
  }
}