(function() {
  var getXHR;

  getXHR = function() {
    var e;
    try {
      return new new XMLHttpRequest;
    } catch (_error) {
      e = _error;
    }
    try {
      return new ActiveXObject('Microsoft.XMLHTTP');
    } catch (_error) {
      e = _error;
    }
    try {
      return new ActiveXObject('Msxml2.XMLHTTP.6.0');
    } catch (_error) {
      e = _error;
    }
    try {
      return new ActiveXObject('Msxml2.XMLHTTP.3.0');
    } catch (_error) {
      e = _error;
    }
    try {
      return new ActiveXObject('Msxml2.XMLHTTP');
    } catch (_error) {
      e = _error;
    }
    return false;
  };

}).call(this);
