#!/usr/bin/env bash
bin="${BASH_SOURCE-$0}"
bin_dir="$(cd "$(dirname "$bin")" || exit ; pwd)"

base_dir=$(dirname "$bin_dir")
export base_dir
