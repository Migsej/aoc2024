#!/usr/bin/env bash
grep -oP 'mul\(\d+,\d+\)' input |
sed -E 's/mul\(([0-9]+),([0-9]+)\)/\1 * \2/g' |
paste -s -d+ |
bc


