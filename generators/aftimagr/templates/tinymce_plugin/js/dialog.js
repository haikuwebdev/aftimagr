tinyMCEPopup.requireLangPack();

var <%= dialog_name %> = {
	init : function() {},

	insert : function() {
		img_html = '<img src="' + img_src + '" alt="' + img_alt + '" />'
		tinyMCEPopup.editor.execCommand('mceInsertContent', false, img_html);
		tinyMCEPopup.close();
	},

	<%- if options[:with_editable_image] -%>
  edit : function(url) {
    var name = 'editable_image_window';
    var features = 'height=600,width=1000,location=0,menubar=0,resizable=1,scrollbars=1,toolbar=0';
    window.open(url, name, features);
  },
  
  show_edited_image : function(image_id) {
    // asynchronous:true, evalScripts:true, method:'get'
    new Ajax.Request('/<%= plural_name %>/' + image_id.toString(), { evalJS:'force', method:'get' });
    return false;
  }
  <%- end -%>
};

tinyMCEPopup.onInit.add(<%= dialog_name %>.init, <%= dialog_name %>);
