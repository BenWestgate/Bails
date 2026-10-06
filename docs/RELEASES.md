# Authenticated CipherStick Releases

CipherStick network updates use signed annotated Git tags. The installed updater
contains a pinned copy of the maintainer release public key and accepts only
tags whose signature verifies in an isolated GnuPG keyring containing that key.

Release key fingerprint:

`89E6 BEF5 A4F5 1B71 CA8F AA35 A9AC CFC9 F87C B111`

Unsigned tags, lightweight tags, mutable branches, and a valid signature from
any other key are rejected. The updater chooses the highest valid version tag
and refuses a downgrade from the installed version.

## Initial installation

The first install must establish the release-key trust root **before any
downloaded CipherStick code executes**. Obtain both the 40-hex release-key
fingerprint and the exact release tag through an independent trusted channel.
Do not use values printed on this GitHub page as the trust source for the first
install.

On Tails, open a terminal and run the following. The commands fetch repository
objects as data, import only the key matching the independently supplied
fingerprint, fetch only the independently selected release tag, verify that the
annotated tag is signed by that key and bound to the same tag name, and execute
only its verified archive.

```bash
set -euo pipefail

read -rp 'CipherStick release-key fingerprint from an independent source: ' expected_fingerprint
expected_fingerprint="$(printf '%s' "$expected_fingerprint" | tr -d '[:space:]' | tr '[:lower:]' '[:upper:]')"
[[ "$expected_fingerprint" =~ ^[0-9A-F]{40}$ ]] || {
    echo 'Expected a 40-hex OpenPGP fingerprint.' >&2
    exit 1
}

read -rp 'Exact CipherStick release tag from an independent source: ' release_tag
[[ "$release_tag" =~ ^v[0-9][0-9A-Za-z._-]*$ ]] || {
    echo 'Unexpected release tag format.' >&2
    exit 1
}

tmp="$(mktemp -d)"
trap 'rm -rf -- "$tmp"' EXIT
mkdir -m 700 "$tmp/gnupg"
git init --quiet "$tmp/repo"
git -C "$tmp/repo" remote add origin https://github.com/BenWestgate/Bails.git

# Fetch the mutable branch only as data so the candidate public key can be
# fingerprinted. Nothing from it is executed.
git -C "$tmp/repo" fetch --quiet --depth=1 origin master
git -C "$tmp/repo" show \
    FETCH_HEAD:bails/.local/share/bails/release-key.asc \
    >"$tmp/release-key.asc"

GNUPGHOME="$tmp/gnupg" gpg --batch --import "$tmp/release-key.asc" >/dev/null 2>&1
imported_fingerprint="$(
    GNUPGHOME="$tmp/gnupg" gpg --batch --with-colons --fingerprint |
        awk -F: '$1 == "pub" { primary = 1; next }
                 primary && $1 == "fpr" { print $10; primary = 0 }'
)"
[ "$imported_fingerprint" = "$expected_fingerprint" ] || {
    echo 'Downloaded release key does not match the independent fingerprint.' >&2
    exit 1
}

git -C "$tmp/repo" fetch --quiet --depth=1 origin \
    "refs/tags/$release_tag:refs/tags/$release_tag"
[ "$(git -C "$tmp/repo" cat-file -t "refs/tags/$release_tag" 2>/dev/null)" = tag ] || {
    echo 'The selected release is not an annotated tag.' >&2
    exit 1
}
signed_tag="$(
    git -C "$tmp/repo" cat-file tag "refs/tags/$release_tag" |
        awk '/^tag / { print substr($0, 5); exit }'
)"
[ "$signed_tag" = "$release_tag" ] || {
    echo 'The signed tag name does not match the selected release.' >&2
    exit 1
}
GNUPGHOME="$tmp/gnupg" git -C "$tmp/repo" verify-tag "$release_tag" >/dev/null 2>&1 || {
    echo 'The selected release is not signed by the authenticated release key.' >&2
    exit 1
}

mkdir "$tmp/release"
git -C "$tmp/repo" archive "$release_tag" | tar -x -C "$tmp/release"
printf 'Installing authenticated CipherStick release %s\n' "$release_tag"
"$tmp/release/b"
```

If the key, tag, or signature does not match the independently obtained values,
installation stops without executing downloaded CipherStick code. A hand-to-hand
copy of an already authenticated release can carry the same established trust
root.

## Publishing a release

Maintainers create a versioned annotated tag using the release key, for example:

```bash
git tag -s v0.8.0 -u 89E6BEF5A4F51B71CA8FAA35A9ACCFC9F87CB111 \
    -m 'CipherStick v0.8.0'
git push origin v0.8.0
```

The tag must point at the exact reviewed release commit. The private release key
must not be stored in this repository or on installation media.
