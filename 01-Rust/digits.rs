use std::env;

fn main() {
    let args: Vec<String> = env::args().collect();

    let mut last: u32 = args[1].chars().last().unwrap().to_digit(10).unwrap();
    let mut res: u32 = 0;

    for d in args[1].chars() {
        let this = d.to_digit(10).unwrap();
        println!("last: {:?} this: {:?}", last, this);
        if last == this {
            res += this;
        }
        last = this;
    }
    println!("result is: {:?}", res);
}
