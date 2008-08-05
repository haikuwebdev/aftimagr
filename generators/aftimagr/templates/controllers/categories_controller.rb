class <%= categories_controller_class_name %>Controller < ApplicationController
  # GET /<%= categories_table_name %>
  # GET /<%= categories_table_name %>.xml
  def index
    @<%= categories_table_name %> = <%= category_class_name %>.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @<%= categories_table_name %> }
    end
  end

  # GET /<%= categories_table_name %>/1
  # GET /<%= categories_table_name %>/1.xml
  def show
    @<%= category_name %> = <%= category_class_name %>.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @<%= category_name %> }
    end
  end

  # GET /<%= categories_table_name %>/new
  # GET /<%= categories_table_name %>/new.xml
  def new
    @<%= category_name %> = <%= category_class_name %>.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @<%= category_name %> }
    end
  end

  # GET /<%= categories_table_name %>/1/edit
  def edit
    @<%= category_name %> = <%= category_class_name %>.find(params[:id])
  end

  # POST /<%= categories_table_name %>
  # POST /<%= categories_table_name %>.xml
  def create
    @<%= category_name %> = <%= category_class_name %>.new(params[:<%= category_name %>])

    respond_to do |format|
      if @<%= category_name %>.save
        flash[:notice] = '<%= category_class_name %> was successfully created.'
        format.html { redirect_to(@<%= category_name %>) }
        format.xml  { render :xml => @<%= category_name %>, :status => :created, :location => @<%= category_name %> }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @<%= category_name %>.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /<%= categories_table_name %>/1
  # PUT /<%= categories_table_name %>/1.xml
  def update
    @<%= category_name %> = <%= category_class_name %>.find(params[:id])

    respond_to do |format|
      if @<%= category_name %>.update_attributes(params[:<%= category_name %>])
        flash[:notice] = '<%= category_class_name %> was successfully updated.'
        format.html { redirect_to(@<%= category_name %>) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @<%= category_name %>.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /<%= categories_table_name %>/1
  # DELETE /<%= categories_table_name %>/1.xml
  def destroy
    @<%= category_name %> = <%= category_class_name %>.find(params[:id])
    @<%= category_name %>.destroy

    respond_to do |format|
      format.html { redirect_to(<%= categories_table_name %>_url) }
      format.xml  { head :ok }
    end
  end
end
