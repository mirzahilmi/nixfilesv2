{
  nix = {
    settings = {
      experimental-features = toString ["nix-command" "flakes"];
    };
  };
}
