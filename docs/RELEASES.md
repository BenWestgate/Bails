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

The pinned key can protect updates only after CipherStick is already installed.
Until the release fingerprint has been obtained through an independent trusted
channel and the selected release tag has been verified against it, do not treat
a mutable GitHub checkout as authenticated installation media. A hand-to-hand
copy of an already authenticated release can carry the established trust root
without executing newly fetched branch content.

## Publishing a release

Maintainers create a versioned annotated tag using the release key, for example:

```bash
git tag -s v0.8.0 -u 89E6BEF5A4F51B71CA8FAA35A9ACCFC9F87CB111 \
    -m 'CipherStick v0.8.0'
git push origin v0.8.0
```

The tag must point at the exact reviewed release commit. The private release key
must not be stored in this repository or on installation media.
