class <%= controller_class_name %>Controller < ApplicationController
  # You may want to implement more specific security measures.
  protect_from_forgery :except => :update
  
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
    redirect_to Picnik.url(@<%= singular_name %>.full_filename, picnik_params)
  end
  
  # PUT /<%= plural_name %>/1
  def update
    @<%= singular_name %> = <%= model_class_name %>.find(params[:id])
    # Clear cached public paths for updated image
    ActionView::Base.computed_public_paths.delete_if do |key, value|
      key.include?(@<%= singular_name %>.public_filename)
    end
    if @<%= singular_name %>.update_attributes(params[:<%= singular_name %>])
      # Avoid browser balking at XSS.
      redirect_to :action => 'update_js', :id => @<%= singular_name %>.id
    else
      set_flash :error, 'There was an error updating the image.'
      redirect_to <%= singular_name %>_path(@<%= singular_name %>)
    end
  end
  
  def update_js
    @<%= singular_name %> = <%= model_class_name %>.find(params[:id])
    set_flash :notice, 'Image was successfully updated.'
  end
  <%- end -%>
  
  # DELETE /<%= plural_name %>/1
  def destroy
    @<%= singular_name %> = <%= model_class_name %>.find(params[:id])
    @<%= singular_name %>.destroy
    set_flash :notice, 'Image has been deleted.'
    respond_to do |format|
      format.html { redirect_to <%= plural_name %>_path }
      format.js { index_js }
    end
  end
  
  protected
  
  def index_js
    @thumbnails = <%= model_class_name %>.thumbnails
    render :update do |page|
      page.replace_html :message_area, :partial => 'messages'
      page.replace_html :image_area, :partial => 'thumbnails'
      page.replace_html :button_area, :partial => 'upload'
    end
    flash.discard
  end
  
  def show_js
    render :update do |page|
      page.replace_html :message_area, :partial => 'messages'
      page.replace_html :image_area, :partial => 'image', :locals => {:image => @<%= singular_name %>}
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
    { # required
      :apikey => 'YOUR_API_KEY_HERE',
      # not required by Picnik, but needed to save images back
      :export => "http://YOUR_URL_HERE/<%= plural_name %>/#{@<%= singular_name %>.id}", 
      :export_field => '<%= singular_name %>[uploaded_data]',
      '_method' => 'put',
      # not required
      :exclude => 'in,out'
    }
  end
  <%- end -%>
end