var exec = require('cordova/exec');
var cordova = require('cordova');

var Preferences = exports;

Preferences.put = function(key, value, success, error) {
    value = JSON.stringify(value);
    exec(success, error, "Preferences", "setValue", [key, value]);
};

Preferences.get = function(key, success, error) {
    suc = function(value) {
      if(value === "" ) {
        return success(null)
      }
      try {
        str = JSON.parse(value)
        return success(str)
      } catch (e) {
        return error(e)
      }
    }
    exec(suc, error, "Preferences", "getValue", [key]);
};
