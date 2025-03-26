# Code modfified from https://github.com/notthebee/nix-config
{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.wireguard-netns;
in {
  options.services.wireguard-netns = with types; {
    enable = mkEnableOption "Enable Wireguard client network namespace";
    namespace = mkOpt str "wg_client" "Network namespace to be created";
    configFile = mkOption {
      type = path;
      description = "Path to a file with Wireguard config (not a wg-quick one!)";
      example = literalExpression ''
        pkgs.writeText "wg0.conf" '''
          [Interface]
          Address = 192.168.2.2
          PrivateKey = <client's privatekey>
          ListenPort = 21841

          [Peer]
          PublicKey = <server's publickey>
          Endpoint = <server's ip>:51820
        '''
      '';
    };
    privateIP = mkOption {
      type = str;
    };
    dnsIP = mkOption {
      type = str;
    };
  };
  config = mkIf cfg.enable {
    systemd.services."netns@" = {
      description = "%I network namespace";
      before = ["network.target"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.iproute2}/bin/ip netns add %I";
        ExecStop = "${pkgs.iproute2}/bin/ip netns del %I";
      };
    };
    environment.etc."netns/${cfg.namespace}/resolv.conf".text = "nameserver ${cfg.dnsIP}";

    systemd.services.${cfg.namespace} = {
      description = "${cfg.namespace} network interface";
      bindsTo = ["netns@${cfg.namespace}.service"];
      requires = ["network-online.target"];
      after = ["netns@${cfg.namespace}.service"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = with pkgs;
          writers.writeBash "wg-up" ''
            see -e
            ${iproute2}/bin/ip link add wg0 type wireguard
            ${iproute2}/bin/ip link set wg0 netns ${cfg.namespace}
            ${iproute2}/bin/ip -n ${cfg.namespace} address add ${cfg.privateIP} dev wg0
            ${iproute2}/bin/ip netns exec ${cfg.namespace} \
            ${pkgs.wireguard-tools}/bin/wg setconf wg0 ${cfg.configFile}
            ${iproute2}/bin/ip -n ${cfg.namespace} link set wg0 up
            ${iproute2}/bin/ip -n ${cfg.namespace} link set lo up
            ${iproute2}/bin/ip -n ${cfg.namespace} route add default dev wg0
          '';
        ExecStop = with pkgs;
          writers.writeBash "wg-down" ''
            see -e
            ${iproute2}/bin/ip -n ${cfg.namespace} route del default dev wg0
            ${iproute2}/bin/ip -n ${cfg.namespace} link del wg0
          '';
      };
    };
  };
}
