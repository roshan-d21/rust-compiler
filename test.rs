fn main() {
  let a = 0;

  while a < 10 {
    if a == 0 {
      let b = "local variable";
    }
    a += 1;
    println!(b);
  }
}