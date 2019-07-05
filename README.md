# Pkgnew 

The shell script **pkgnew** is designed as alternative of
[CRUX](https://crux.nu) package management utilities *ports* and *pkgmk*.

The shell script **pkguse** is a simple network package manager using
the results of the work **pkgnew**.

## Goals

1. Compatible with *ports* and *pkgmk*
2. Easy update port collections and build changed packages
3. Easy change *official* ports for local use
4. Build a *basic* package and a *developer* package from the single port
5. Auto add user for package if required
6. Auto run *post-install* script for package if required
7. Save package build log on error
8. Show current task and total time
9. Remove unused packages and sources for its
10. Installing packages for the system in accordance with its functional role
11. Updating packages over the network
