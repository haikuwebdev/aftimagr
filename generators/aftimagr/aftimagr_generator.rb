if Rails::VERSION::MAJOR >= 2 && Rails::VERSION::MINOR >= 1
  class Rails::Generator::Commands::Base
    protected
    def next_migration_string(padding = 3)
      sleep(1)
      Time.now.utc.strftime("%Y%m%d%H%M%S") 
    end
  end
end

class AftimagrGenerator < Rails::Generator::NamedBase
  default_options :with_editable_image => false, :skip_model => false, :skip_migration => false
  
  attr_reader :controller_class_path,
              :controller_class_name,
              :model_class_name,
              :controller_underscore_name
  alias_method :controller_file_name, :controller_underscore_name
  
  def initialize(args, options = {})
    super
    @controller_name = @name.pluralize
    base_name, @controller_class_path, @controller_file_path, @controller_class_nesting, @controller_class_nesting_depth = extract_modules(@controller_name)
    @controller_class_name_without_nesting, @controller_underscore_name, @controller_plural_name = inflect_names(base_name)
    @controller_singular_name=base_name.singularize
    if @controller_class_nesting.empty?
      @controller_class_name = @controller_class_name_without_nesting
    else
      @controller_class_name = "#{@controller_class_nesting}::#{@controller_class_name_without_nesting}"
    end
    @model_class_name = @controller_class_name.singularize
  end
  
  def manifest
    # APPTOD: DRY up the code in this method.
    record do |m|
      # Check for class naming collisions.
      m.class_collisions(controller_class_path, "#{controller_class_name}Controller")
      m.class_collisions(class_path, "#{class_name}")
      
      m.directory('app/models')
      m.directory(File.join('app/controllers', controller_class_path))
      m.directory(views_dir)
      
      # Models
      m.template 'models/attfu_model.rb', "app/models/#{name}.rb" unless options[:skip_model]
      m.template 'models/category_model.rb', "app/models/#{name}_category.rb" if options[:with_categories]
      
      # Migrations
      unless options[:skip_model] || options[:skip_migration]
        m.migration_template 'migrations/attfu_migration.rb', 'db/migrate',
                             :assigns => { :migration_name => migration_name },
                             :migration_file_name => "create_#{table_name}"
      end

      if options[:with_categories] && !options[:skip_migration]
        # sleep(1) # So we don't duplicate the timestamp of the model migration file.
        m.migration_template 'migrations/category_migration.rb', 'db/migrate',
                             :assigns => { :migration_name => category_migration_name },
                             :migration_file_name => "create_#{name}_categories"
      end
      
      # Controller
      m.template 'controllers/controller.rb',
                 File.join('app/controllers', class_path, "#{plural_name}_controller.rb")
                 
      # Views
      m.template 'views/_buttons.html.erb', File.join(views_dir, '_buttons.html.erb')
      m.file 'views/_image.html.erb', File.join(views_dir, '_image.html.erb')
      m.file 'views/_messages.html.erb', File.join(views_dir, '_messages.html.erb')
      m.file 'views/_show_form.html.erb', File.join(views_dir, '_show_form.html.erb')
      m.template 'views/_thumbnails.html.erb', File.join(views_dir, '_thumbnails.html.erb')
      m.template 'views/_upload.html.erb', File.join(views_dir, '_upload.html.erb')
      m.template 'views/index.html.erb', File.join(views_dir, 'index.html.erb')
      m.template 'views/new.html.erb', File.join(views_dir, 'new.html.erb')
      m.template 'views/show.html.erb', File.join(views_dir, 'show.html.erb')
      m.template 'views/update_js.html.erb', File.join(views_dir, 'update_js.html.erb')
      
      # TinyMCE plugin
      m.directory(tinymce_plugin_dir)
      m.template 'tinymce_plugin/dialog.htm', File.join(tinymce_plugin_dir, 'dialog.htm')
      m.template 'tinymce_plugin/editor_plugin.js', File.join(tinymce_plugin_dir, 'editor_plugin.js')
      m.directory(File.join(tinymce_plugin_dir, 'css'))
      m.file 'tinymce_plugin/css/aftimagr.css', File.join(tinymce_plugin_dir, 'css', "#{name}.css")
      m.directory(File.join(tinymce_plugin_dir, 'img'))
      m.file 'tinymce_plugin/img/aftimagr.gif', File.join(tinymce_plugin_dir, 'img', "#{name}.gif")
      m.directory(File.join(tinymce_plugin_dir, 'js'))
      m.template 'tinymce_plugin/js/dialog.js', File.join(tinymce_plugin_dir, 'js', 'dialog.js')
      m.directory(File.join(tinymce_plugin_dir, 'langs'))
      m.template 'tinymce_plugin/langs/en.js', File.join(tinymce_plugin_dir, 'langs', 'en.js')
      m.template 'tinymce_plugin/langs/en_dlg.js', File.join(tinymce_plugin_dir, 'langs', 'en_dlg.js')
      
      # Resource routes hack for getting correct output with :member option.
      # The correct way to do this might involve a change to route_resources.
      route_string = ":#{controller_file_name}, :member => { :update_js => :get }"
      def route_string.to_sym; to_s; end
      def route_string.inspect; to_s; end
      m.route_resources route_string
    end
  end
  
  def migration_name
    "Create#{controller_class_name}"
  end
  
  def category_migration_name
    "Create#{model_class_name}Categories"
  end
  
  def category_table_name
    "#{name}_categories"
  end
  
  protected
  
  def banner
    "Usage: #{$0} aftimagr attachment_fu_model_name"
  end
  
  def views_dir
    File.join('app/views', controller_class_path, controller_file_name)
  end
  
  def tinymce_plugin_dir
    File.join('public/javascripts/tinymce/jscripts/tiny_mce/plugins', singular_name)
  end
  
  def window_title
    model_class_name + ' Manager'
  end
  
  def dialog_name
    model_class_name + 'Dialog'
  end
  
  def add_options!(opt)
    opt.separator ''
    opt.separator 'Options:'
    opt.on("--with-editable-image", 
           "Generate code for integrating with editable-image") { |v| options[:with_editable_image] = v }
    opt.on("--skip-migration",
           "Don't generate a migration for this model") { |v| options[:skip_migration] = v }
    opt.on("--skip-model",
           "Don't genereate a model file.") { |v| options[:skip_model] = v }
    opt.on("--with-categories",
           "Generate a category model and associate the image model with it.") { |v| options[:with_categories] = v }
  end

end
