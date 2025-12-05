#!/usr/bin/env nix-shell
#! nix-shell -i python3 -p python3Packages.tomlkit
"""Convert TOML file to use inline tables for all nested tables."""
import sys

import tomlkit


def to_inline_table(value):
    """Convert nested dicts to inline tables recursively."""
    if isinstance(value, dict):
        inline = tomlkit.inline_table()
        for k, v in value.items():
            inline[k] = to_inline_table(v)
        return inline
    elif isinstance(value, list):
        return [to_inline_table(item) for item in value]
    else:
        return value


def main():
    if len(sys.argv) != 2:
        print("Usage: toml-inline-gen.py <toml-file>", file=sys.stderr)
        sys.exit(1)

    with open(sys.argv[1], "r") as f:
        data = tomlkit.parse(f.read())

    # Keep top-level as table, convert nested values to inline tables
    result = tomlkit.table()
    for key, value in data.items():
        result[key] = to_inline_table(value)

    print(tomlkit.dumps(result), end="")


if __name__ == "__main__":
    main()
