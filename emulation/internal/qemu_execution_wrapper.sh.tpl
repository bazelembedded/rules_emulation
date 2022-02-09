#!/bin/bash
echo $1
set -euo pipefail
{QEMU} {ARGS} -kernel $1