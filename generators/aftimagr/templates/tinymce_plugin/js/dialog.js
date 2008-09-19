tinyMCEPopup.requireLangPack();

var <%= dialog_name %> = {
	init : function() {},

	insert : function() {
	  alt = document.forms[0].alt.value;
	  url = document.forms[0].url.value;
	  css_class = document.forms[0].css_class.value;
	  img_html = '<img src="' + img_src + '" alt="' + alt + '" class="' + css_class + '" />';
	  if (url.length > 0) {
	    img_html = img_html.link(url)
	  }
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
    new Ajax.Request('/<%= plural_name %>/' + image_id.toString(), { evalJS:'force', method:'get' });
    return false;
  }
  <%- end -%>
};

tinyMCEPopup.onInit.add(<%= dialog_name %>.init, <%= dialog_name %>);
