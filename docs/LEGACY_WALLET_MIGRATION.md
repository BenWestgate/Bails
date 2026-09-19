# Legacy `bails-wallet` migration

The custom `bails-wallet` application and its bundled Codex32/key-handling code
have been removed from CipherStick. CipherStick now focuses on installing and
configuring Tails, Bitcoin Core, and Sparrow.

## Before upgrading

If you still depend on a wallet created by the legacy flow, do not delete your
existing Persistent Storage or paper backups. Boot the version that created the
wallet and confirm that you can recover the wallet before changing software.

Use Bitcoin Core's own backup/export capabilities to make a recovery artifact
that does not depend on `bails-wallet`, and verify that artifact before relying
on the new CipherStick version. Keep the original Codex32 backup material until
the replacement restoration flow tracked in issue #215 has been independently
reviewed and tested with your backup format.

## After upgrading

CipherStick will no longer launch or expose the legacy wallet interface. Sparrow
is the supported wallet coordinator. Existing Bitcoin Core wallet data remains
Bitcoin Core data; removing `bails-wallet` does not intentionally delete the
Bitcoin Core data directory.

If an upgrade has already removed the legacy helper before you completed
migration, use the previous CipherStick revision that created the wallet to
perform recovery. Git history retains the removed source for that purpose, but
running old software should be done only for migration and with the same care
used for any legacy wallet code.
