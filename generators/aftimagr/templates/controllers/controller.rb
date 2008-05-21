class <%= controller_class_name %>Controller < ApplicationController
  
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
        set_flash(:notice, 'Image was successfully uploaded and saved.')
        format.html { redirect_to <%= singular_name %>_path(@<%= singular_name %>) }
        format.js { responds_to_parent { show_js } }
      else
        set_flash(:error, 'There was an error saving the image.')
        format.html { render :action => :new }
        format.js { responds_to_parent { index_js } }
      end
    end
  end
  
  # DELETE /<%= plural_name %>/1
  def destroy
    @<%= singular_name %> = <%= model_class_name %>.find(params[:id])
    @<%= singular_name %>.destroy
    set_flash(:notice, 'Image has been deleted.')
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
    if request.xhr?
      flash.now[key] = msg
    else
      flash[key] = msg
    end
  end
  
end