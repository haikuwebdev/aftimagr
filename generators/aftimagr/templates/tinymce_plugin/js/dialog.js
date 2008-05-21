tinyMCEPopup.requireLangPack();

var <%= dialog_name %> = {
	init : function() {},

	insert : function() {
		img_html = '<img src="' + img_src + '" />'
		tinyMCEPopup.editor.execCommand('mceInsertContent', false, img_html);
		tinyMCEPopup.close();
	},
	
  // edit : function(url) {
  //  var name = 'picnik_window';
  //  var features = 'height=600,width=1000,location=no,menubar=no,resizable=no,toolbar=no';
  //  window.open(url, name, features);
  // },
  // 
  // show_edited_image : function(image_id) {
  //  new Ajax.Request('/<%= plural_name %>/' + image_id.toString(), { asynchronous:true, evalScripts:true, method:'get' });
  //  return false;
  // }
};

tinyMCEPopup.onInit.add(<%= dialog_name %>.init, <%= dialog_name %>);
