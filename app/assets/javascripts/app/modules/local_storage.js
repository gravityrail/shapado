var LocalStorage = {
  initialize: function(){
    if(Modernizr.localstorage){
      Storage.prototype.setObject = function(key, value) {
          this.setItem(key, JSON.stringify(value));
      }

      Storage.prototype.getObject = function(key) {
          return JSON.parse(this.getItem(key));
      }
    }

    LocalStorage.load_textareas();
    LocalStorage.initialize_text_areas();
  },
  remove: function(key, id) {
    if(LocalStorage.hasStorage()){
      var ls = localStorage[key];
      if(typeof(ls)=='string'){
        var storageArr = localStorage.getObject(key);

        storageArr = $.map(storageArr, function(n, i){
            if(n.id == id){
              return null;
            } else {
                return n;
            }
        });
        localStorage.setObject(key, storageArr);
      }
    }
  },
  initialize_text_areas: function() {
    $("form").live('submit', function() {
      var textarea = $(this).find('textarea');
      LocalStorage.remove(location.href, textarea.attr('id'));
      window.onbeforeunload = null;
    });

    $('textarea').live('keyup',function(){
      var value = $(this).val();
      var id = $(this).attr('id');
      LocalStorage.add(location.href, id, value);
    });
  },
  hasStorage: function(){
    if (Modernizr.localstorage
        && localStorage['setObject']
        && localStorage['getObject']){
      return true;
    } else {
        return false;
    }
  },
  load_textareas: function(){
     if(LocalStorage.hasStorage() && localStorage[location.href]!=null && localStorage[location.href]!='null'){
         localStorageArr = localStorage.getObject(location.href);
         $.each(localStorageArr, function(i, n){
             $("#"+n.id).val(n.value);
             $("#"+n.id).parents('form.commentForm').show();
             $("#"+n.id).parents('form.nestedAnswerForm').show();
         })
      }
  },
  add: function(key, id, value){
    if(LocalStorage.hasStorage()){
      var ls = localStorage[key];
      if($.trim(value)!=""){
        if(ls == null || ls == "null" || typeof(ls)=="undefined"){
            localStorage.setObject(key,[{id: id, value: value}]);
        } else {
            var storageArr = localStorage.getObject(key);
            var isIn = false;
            storageArr = $.map(storageArr, function(n, i){
                if(n.id == id){
                  n.value = value;
                  isIn = true;
                }
            return n;
          })
        if(!isIn)
          storageArr = $.merge(storageArr, [{id: id, value: value}]);
        localStorage.setObject(key, storageArr);
      }
      } else {LocalStorage.remove(key, id);}
    }
  }

};
