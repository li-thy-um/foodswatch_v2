$.fn.numeralinput = function() {
  $(this).css("ime-mode", "disabled");
  this.bind("keypress", function(e) {
    if (e.charCode === 0) return true;  //非字符键 for firefox
    var code = (e.keyCode ? e.keyCode : e.which);  //兼容火狐 IE    
    return code >= 48 && code <= 57;
  });
  this.bind("blur", function() {
    if (!/\d+/.test(this.value)) {
      this.value = "";
    }
  });
  this.bind("paste", function() {
    if (window.clipboardData) {
      var s = clipboardData.getData('text');
      if (!/\D/.test(s)) {
        value = parseInt(s, 10);
        return true;
      }
    }
    return false;
  });
  this.bind("dragenter", function() {
    return false;
  });
  this.bind("keyup", function() {
    if (this.value !== '0' && /(^0+)/.test(this.value)) {
      this.value = parseInt(this.value, 10);
    }
  });
  this.bind("propertychange", function(e) {
    if (isNaN(this.value))
    this.value = this.value.replace(/\D/g, "");
  });
  this.bind("input", function(e) {
    if (isNaN(this.value))
    this.value = this.value.replace(/\D/g, "");
  });
};
