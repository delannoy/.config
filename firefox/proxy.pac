function FindProxyForURL(url, host) {
    var cernHosts = {
        "cds.cern.ch": false,
        "landb.cern.ch": true,
        "timber.cern.ch": true,
        "twiki.cern.ch": true,
        "wrap.cern.ch": false,
    }
    if (cernHosts[host]) {
        return "SOCKS5 localhost:10888; DIRECT";
    }
    if (shExpMatch(host, "*.cms")) {
        return "SOCKS5 localhost:10880";
    }
    return "DIRECT";
}
