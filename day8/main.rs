use std::fs;
use std::collections::{HashMap, HashSet};

// 1128 low
fn minus(a: (isize, isize), b: (isize, isize)) -> (isize, isize) {
  return (a.0 - b.0, a.1 - b.1);
}
fn plus(a: (isize, isize), b: (isize, isize)) -> (isize, isize) {
  return (a.0 + b.0, a.1 + b.1);
}

fn part1() {
  let contents = fs::read_to_string("./real_input.txt").expect("file should be there");
  let length: isize = contents.find('\n').unwrap() as isize;
  let lines = contents.len() as isize/(length+1);
  let mut nodes: HashMap<char, Vec<(isize, isize)>>  =  HashMap::new();
  for (i, c) in contents.chars().enumerate() {
    if c != '.' && c != '\n' {
      nodes.entry(c).or_insert(Vec::new());
      nodes
        .entry(c)
        .and_modify(|coords| coords.push((i as isize%(length+1), i as isize/(length+1))));
    }
  }

  let mut alreade_place = Vec::new();
  let mut result = 0;
  for (_key, antennas) in  nodes.iter() {
    for i in 0..antennas.len() {
      for j in i+1..antennas.len() {
        let diff = minus(antennas[i], antennas[j]);
        let before = minus(antennas[j], diff);
        let after = plus(antennas[i], diff);
        if before.0 >= 0 && before.0 < length && before.1 >= 0 && before.1 < lines && !alreade_place.contains(&before) {
          alreade_place.push(before);
          result += 1;
        }
        if after.0 >= 0 && after.0 < length && after.1 >= 0 && after.1 < lines && !alreade_place.contains(&after) {
          alreade_place.push(after);
          result += 1;
        }
      }
    }
  }
  println!("{result}");
}

fn main() {
  let contents = fs::read_to_string("./real_input.txt").expect("file should be there");
  let length: isize = contents.find('\n').unwrap() as isize;
  let lines = contents.len() as isize/(length+1);
  let mut nodes: HashMap<char, Vec<(isize, isize)>>  =  HashMap::new();
  for (i, c) in contents.chars().enumerate() {
    if c != '.' && c != '\n' {
      nodes.entry(c).or_insert(Vec::new());
      nodes
        .entry(c)
        .and_modify(|coords| coords.push((i as isize%(length+1), i as isize/(length+1))));
    }
  }

  let mut alreade_place = HashSet::new();
  for (_key, antennas) in  nodes.iter() {
    alreade_place.extend(antennas.iter());
    for i in 0..antennas.len() {
      for j in i+1..antennas.len() {
        let diff = minus(antennas[i], antennas[j]);
        let mut before = minus(antennas[j], diff);
        let mut after = plus(antennas[i], diff);
        while before.0 >= 0 && before.0 < length && before.1 >= 0 && before.1 < lines {
          alreade_place.insert(before);
          before = minus(before, diff);
        }
        while after.0 >= 0 && after.0 < length && after.1 >= 0 && after.1 < lines {
          alreade_place.insert(after);
          after = plus(after, diff);
        }
      }
    }
  }
  println!("{}", alreade_place.len());
}
