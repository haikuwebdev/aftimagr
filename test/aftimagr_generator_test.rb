require File.join(File.dirname(__FILE__), 'test_helper')

class AftimagrGeneratorTest < GeneratorTestCase
  
  # APPTODO: Test --with-editable-image option. Will need to dig into produced output.

  def test_generates_names
    # APPTODO: Fix naming with CamelCased arg, e.g., ProductLine
    %w(product_line).each do |arg|
      g = Rails::Generator::Base.instance('aftimagr', arg.to_a)
      assert_equal "product_line", g.name
      assert_equal "product_line", g.file_name
      assert_equal "product_lines", g.table_name
      assert_equal "product_lines", g.controller_underscore_name
      assert_equal "product_lines", g.controller_file_name
      assert_equal "ProductLine", g.model_class_name
      assert_equal "ProductLines", g.controller_class_name
      assert_equal "CreateProductLines", g.migration_name
      assert_equal [], g.controller_class_path
      assert_equal [], g.class_path
    end
  end
  
  def test_generates_namespaced_names
    %w(admin/image Admin::Image).each do |namespaced_string|
      g = Rails::Generator::Base.instance('aftimagr', [namespaced_string])
      assert_equal 'Admin::Images', g.controller_class_name
      assert_equal ['admin'], g.controller_class_path
      assert_equal 'images', g.plural_name
    end
  end
  
  def test_generates_route
    run_generator('aftimagr', %w(article_image))
    assert_added_route_for :article_images
  end
  
  def test_generates_controller
    run_generator('aftimagr', %w(article_image))
    assert_generated_controller_for :article_images
  end
  
  def test_generates_namespaced_controller
    run_generator('aftimagr', %w(admin::image))
    assert_generated_controller_for "admin::images"
  end
  
  def test_generates_views
    run_generator('aftimagr', %w(article_image))
    assert_generated_views_for :article_images, 
        '_buttons.html.erb', '_image.html.erb', '_messages.html.erb', '_thumbnails.html.erb',
        '_upload.html.erb', 'index.html.erb', 'new.html.erb', 'show.html.erb', 'update_js.html.erb'
  end
  
  def test_generates_model
    run_generator('aftimagr', %w(article_image))
    assert_generated_model_for :article_image
  end
  
  def test_does_not_generate_model
    run_generator('aftimagr', %w(article_image --skip-model))
    assert_skipped_model :article_image
  end
  
  def test_generates_migration
    run_generator('aftimagr', %w(article_image))
    assert_generated_migration :create_article_images
    # APPTODO: The next assertion passes due to bug in Rails. Fix.
    assert_skipped_migration :create_article_images
  end
  
  def test_does_not_generate_migration
    # APPTODO: test_does_not_generate_migration
  end
  
end
