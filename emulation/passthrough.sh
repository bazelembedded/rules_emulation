#!/bin/bash

set -euo pipefail

exec -a $1 $1 ${@:2}