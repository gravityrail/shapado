var Utils = {
  url_vars: function() {
    var vars = {}, hash;
    var hashes = {}
    if(window.location.href.indexOf('?') > 0) {
      window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
    }

    for(var i = 0; i < hashes.length; i++) {
      hash = hashes[i].split('=');
      vars[hash[0]] = hash[1];
    }
    return vars;
  },
  append_params: function(url, params) {
    if(url.indexOf('?')==-1)
      url += '?'+params;
    else
      url += '&'+params;

    return url;
  },
  log: function(data) {
    window.console && window.console.log(data);
  }
};