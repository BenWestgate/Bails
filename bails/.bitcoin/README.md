This directory is not the datadir, it will be copied to dotfiles which symlinks it into $HOME. It will contain the bitcoin.conf with the datadir= key set. This prevents accidentally ever using /home/amneisa/.bitcoin, the default datadir that won't persist, even when bitcoin is launched from the command line so long as dotfiles are on. 

This file will be clobbered by the README.md from bitcoin-core later.
