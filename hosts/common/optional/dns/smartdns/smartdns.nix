{ config, pkgs, ... }: {
  services.smartdns = let
    https = {
      reliable = [
        "https://dns.cloudflare.com/dns-query"
        "https://dns.google/dns-query"
        "https://dns11.quad9.net/dns-query"
        "https://dns.adguard-dns.com/dns-query"
      ];
      russian = [
        "https://dns.comss.one/dns-query" # comms.one (Poland and Russia)
        "https://77.88.8.8:443" # YandexDNS (Russia)
      ];
    };
    plain = { russian = [ "193.58.251.251" ]; };
  in {
    enable = true;
    bindPort = 53;
    settings = {
      force-AAAA-SOA = true;
      speed-check-mode = "ping,tcp:443,tcp:80";
      response-mode = "fastest-ip";
      cache-size = 32768;
      cache-persist = true;
      cache-file = "/var/cache/smartdns/smartdns.cache";
      cache-checkpoint-time = 86400;
      serve-expired-prefetch-time = 21600;
      prefetch-domain = true;
      serve-expired = true;
      serve-expired-ttl = 259200;
      serve-expired-reply-ttl = 3;
      edns-client-subnet = "178.70.22.18/24";
      server-https = https.reliable ++ https.russian;
      server = plain.russian;
    };
  };
}
