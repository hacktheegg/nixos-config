#!/usr/bin/env bash

FILE="channels.nix"

sed -nE 's/^[[:space:]]*url[[:space:]]*=[[:space:]]*"([^"]+)".*/\1/p' "$FILE" |
while IFS= read -r url; do

    # hash=$(nix-prefetch-url --unpack "$url")
    # sri=$(nix hash convert --hash-algo sha256 --to sri "$hash" \
        # --extra-experimental-features nix-command)

    # printf '  %s\n\n' "$sri"


    echo "$url"
    echo "sha256:$(nix-prefetch-url --unpack "$url")"
done
