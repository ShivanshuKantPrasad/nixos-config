# Make nix-search-cli query only the newest search.nixos.org index.
#
# nix-search-cli 0.3 searches the wildcard `latest-*-nixos-<channel>`, which
# matches every index generation search.nixos.org still keeps alive. Because
# several generations exist at once (currently 45 through 53), the tool can
# return packages from stale nixpkgs snapshots, e.g. ripgrep 15.1.0 even though
# the current index has 15.2.0.
#
# The patch resolves the newest `latest-<N>-...` alias for the requested
# channel at runtime, falling back to the old wildcard if the lookup fails.
final: prev: {
  nix-search-cli = prev.nix-search-cli.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./nix-search-cli-newest-index.patch ];

    meta = (old.meta or { }) // {
      description = (old.meta.description or "CLI for searching packages on search.nixos.org")
        + " (patched to use only the newest search index)";
    };
  });
}
