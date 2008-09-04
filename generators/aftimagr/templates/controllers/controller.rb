class <%= controller_class_name %>Controller < ApplicationController
  # You may want to implement more specific security measures.
  protect_from_forgery :except => :update

  <%- if options[:with_editable_image] -%>
  before_filter :set_flash_from_params, :only => [:show, :update_js]
  <%- end -%>
  
  # GET /<%= plural_name %>
  def index
    respond_to do |format|
      format.html { @thumbnails = <%= model_class_name %>.thumbnails }
      format.js { index_js }
    end
  end
  
  # GET /<%= plural_name %>/1
  def show
    @<%= singular_name %> = <%= model_class_name %>.find(params[:id])
    <%- if options[:with_categories] -%>
    @active_category = @<%= singular_name %>.category
    <%- end -%>
    respond_to do |format|
      format.html
      format.js { show_js }
    end
  end
  
  # POST /<%= plural_name %>
  def create
    @<%= singular_name %> = <%= model_class_name %>.new(params[:<%= singular_name %>])
    respond_to do |format|
      if @<%= singular_name %>.save
        set_flash :notice, 'Image was successfully uploaded and saved.'
        format.html { redirect_to <%= singular_name %>_path(@<%= singular_name %>) }
        format.js { responds_to_parent { show_js } }
      else
        set_flash :error, 'There was an error saving the image.'
        format.html { render :action => :new }
        format.js { responds_to_parent { index_js } }
      end
    end
  end
  
  <%- if options[:with_editable_image] -%>
  # GET /<%= plural_name %>/1/edit
  def edit
    @<%= singular_name %> = <%= model_class_name %>.find(params[:id])
    redirect_to EditableImage::Picnik.url(@<%= singular_name %>.full_filename, picnik_params)
  rescue EditableImage::EditableImageError => e
    set_flash :error, e.message
  end
  
  # PUT /<%= plural_name %>/1
  def update
    @<%= singular_name %> = <%= model_class_name %>.find(params[:id])
    params[:<%= singular_name %>][:filename] = @<%= singular_name %>.filename
    
    # Clear cached public paths for updated image
    ActionView::Base.computed_public_paths.delete_if do |key, value|
      key.include?(@<%= singular_name %>.public_filename)
    end
    
    redirect_opts = { :id => @<%= singular_name %>.id }

    if @<%= singular_name %>.update_attributes(params[:<%= singular_name %>])
      redirect_opts[:flash_notice] = 'Image was successfully updated.'
    else
      redirect_opts[:flash_error] = 'There was an error updating the image.'
    end

    redirect_opts[:action] = request_from_popup? ? 'update_js' : 'show'
    redirect_to redirect_opts    
  end
  
  def update_js
    @<%= singular_name %> = <%= model_class_name %>.find(params[:id])
    set_flash :notice, 'Image was successfully updated.'
  end
  <%- end -%>
  
  # DELETE /<%= plural_name %>/1
  def destroy
    @<%= singular_name %> = <%= model_class_name %>.find(params[:id])
    <%- if options[:with_categories] -%>
    @active_category = @<%= singular_name %>.category
    <%- end -%>
    @<%= singular_name %>.destroy
    set_flash :notice, 'Image has been deleted.'
    respond_to do |format|
      format.html { redirect_to <%= plural_name %>_path }
      format.js { index_js }
    end
  end
  
  protected
  
  def index_js
    <%- if options[:with_categories] -%>
    @categories = <%= model_class_name %>Category.find(:all)
    @active_category = @active_category || <%= model_class_name %>Category.find_by_id(params[:category]) || <%= model_class_name %>Category.default
    @thumbnails = @active_category.thumbnails
    <%- else -%>
    @thumbnails = <%= model_class_name %>.thumbnails
    <%- end -%>
    render :update do |page|
      <%- if options[:with_categories] -%>
      page.replace_html :category_area, :partial => '<%= categories_table_name %>/category', :collection => @categories
      <%- end -%>
      page.replace_html :message_area, :partial => 'messages'
      page.replace_html :image_area, :partial => 'thumbnails'
      # APPTODO: Better way to remove html from an element.
      page.replace_html :form_area, ''
      page.replace_html :button_area, :partial => 'upload'
    end
    flash.discard
  end
  
  def show_js
    render :update do |page|
      page.replace_html :message_area, :partial => 'messages'
      page.replace_html :image_area, :partial => 'image', :locals => {:image => @<%= singular_name %>}
      page.replace_html :form_area, :partial => 'show_form', :locals => {:image => @<%= singular_name %>}
      page.replace_html :button_area, :partial => 'buttons', :locals => {:image => @<%= singular_name %>}
      page.assign :img_src, @<%= singular_name %>.public_filename
    end
    flash.discard
  end
  
  def set_flash(key, msg)
    request.xhr? ? flash.now[key] = msg : flash[key] = msg
  end
  
  <%- if options[:with_editable_image] -%>
  def picnik_params
    ret = { # required
            :apikey => 'YOUR_API_KEY_HERE',
            # not required by Picnik, but needed to save images back
            :export => "http://YOUR_URL_HERE/<%= plural_name %>/#{@<%= singular_name %>.id}", 
            :export_field => '<%= singular_name %>[uploaded_data]',
            '_method' => 'put',
            # not required
            :exclude => 'in,out' }
    request_from_popup? ? ret.merge(:popup => 'true') : ret
  end
  
  def request_from_popup?
    !!params[:popup]
  end
  
  def set_flash_from_params
    flash_keys = params.keys.select { |key| key.index('flash_') == 0 }
    flash_keys.each do |key|
      arr = key.split('_')
      arr.delete_at(0)
      flash[arr.join('_').to_sym] = params[key]
    end
  end
  <%- end -%>
end