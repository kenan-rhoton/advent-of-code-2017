use std::env;

fn main() {
    let args: Vec<String> = env::args().collect();

    let size: usize = args[1].chars().count();
    let mut lastpos: usize = size/2;
    let mut last: u32 = args[1].chars().nth(lastpos).unwrap().to_digit(10).unwrap();
    let mut res: u32 = 0;

    for d in args[1].chars() {
        let this = d.to_digit(10).unwrap();
        if last == this {
            res += this;
        }
        println!(" this: {:?} last: {:?} pos: {:?}", this, last, lastpos);
        lastpos += 1;
        lastpos = lastpos % size;
        last = args[1].chars().nth(lastpos).unwrap().to_digit(10).unwrap();
    }
    println!("result is: {:?}", res);
}
