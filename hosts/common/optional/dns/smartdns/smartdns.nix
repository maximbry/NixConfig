{ config, pkgs, ... }: {
  services.smartdns = {
    enable = true;
    bindPort = 53;
    settings = {
      force-AAAA-SOA = true;
      speed-check-mode = "ping,tcp:443,tcp:80";
      response-mode = "fastest-ip";
      cache-size = 32768;
      prefetch-domain = true;
      serve-expired = true;
      serve-expired-ttl = 259200;
      serve-expired-reply-ttl = 3;
      edns-client-subnet = "178.70.32/24";
      server = [
        "1.1.1.1 -bootstrap-dns"
        "8.26.56.26" # Comodo Secure DNS
        "8.20.247.20" # Comodo Secure DNS
        "54.174.40.213" # DNSWatchGO
        "52.3.100.184" # DNSWatchGO
        "216.146.35.35" # DynDNS
        "216.146.36.36" # DynDNS
        "80.80.80.80" # Freenom World
        "80.80.81.81" # Freenom World
        "180.131.144.144" # Nawala Childprotection DNS
        "180.131.145.145" # Nawala Childprotection DNS
        "156.154.70.5" # Neustar Recursive DNS
        "156.154.71.5" # Neustar Recursive DNS
        # "195.46.39.39" # Safe DNS # Filtering
        # "195.46.39.40" # Safe DNS # Filtering
        "104.155.237.225" # Safe Surfer
        "104.197.28.121" # Safe Surfer
        "64.6.64.6" # Verisign Public DNS
        "64.6.65.6" # Verisign Public DNS
      ];
      server-https = [
        "https://unfiltered.adguard-dns.com/dns-query"
        "https://dns.bebasid.com/unfiltered"
        "https://doh.sandbox.opendns.com/dns-query"
        "https://doh.cleanbrowsing.org/doh/security-filter/"
        "https://dns.cloudflare.com/dns-query"
        "https://dns.decloudus.com/dns-query"
        "https://dns.google/dns-query"
        "https://dns.alidns.com/dns-query"
        "https://dns.cfiec.net/dns-query"
        "https://freedns.controld.com/p0"
        "https://doh.dns.sb/dns-query"
        "https://doh.pub/dns-query"
        "https://doh.mullvad.net/dns-query" # causes problems
        "https://dns.nextdns.io"
        "https://anycast.dns.nextdns.io"
        "https://ada.openbld.net/dns-query"
        "https://zero.dns0.eu/"
        "https://dns11.quad9.net/dns-query"
        "https://basic.rethinkdns.com/"
        "https://doh.360.cn/dns-query"
        "https://dns.comss.one/dns-query" # comms.one (Poland and Russia)
        "https://77.88.8.8:443" # YandexDNS (Russia)
      ];
    };
  };
}
