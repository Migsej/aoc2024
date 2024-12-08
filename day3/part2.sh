#!/usr/bin/env bash
grep -oP "(mul\(\d+,\d+\))|(do\(\))|(don't\(\))" input |
sed -E "s/don't\(\)/\/*/g" |
sed -E "s/do\(\)/*\//g" |
sed -E 's/mul\(([0-9]+),([0-9]+)\)/\1 * \2/g' |
bc |
paste -s -d+ |
bc


