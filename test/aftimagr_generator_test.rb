require File.dirname(__FILE__) + '/test_helper'

class AftimagrGeneratorTest < GeneratorTestCase
  
  # APPTODO: Test --with-editable-image option. Will need to dig into produced output.
  
  def test_generates_names
    g = Rails::Generator::Base.instance('aftimagr', %w(product_line))
    assert_equal "product_line", g.name
    assert_equal "product_lines", g.table_name
    assert_equal "product_lines", g.controller_underscore_name
    assert_equal "product_lines", g.controller_file_name
    assert_equal "ProductLine", g.model_class_name
    assert_equal "ProductLines", g.controller_class_name
    assert_equal [], g.controller_class_path
    assert_equal [], g.class_path
  end
  
  def test_generates_controller
    run_generator('aftimagr', %w(article_image))
    assert_generated_controller_for :article_images
  end
  
  def test_generates_views
    run_generator('aftimagr', %w(article_image))
    assert_generated_views_for :article_images, 
        '_buttons.html.erb', '_image.html.erb', '_messages.html.erb', '_thumbnails.html.erb',
        '_upload.html.erb', 'index.html.erb', 'new.html.erb', 'show.html.erb', 'update_js.html.erb'
  end
  
  def test_generates_route
    run_generator('aftimagr', %w(article_image))
    assert_added_route_for :article_images
  end
  
  def test_generates_namespaced_controller
    run_generator('aftimagr', %w(admin::image))
    assert_generated_controller_for "admin::images"
  end
  
  def test_generates_names_for_namespaced_controller
    namespaced_strings = %w(admin/image Admin::Image)
    namespaced_strings.each do |namespaced_string|
      g = Rails::Generator::Base.instance('aftimagr', [namespaced_string])
      assert_equal 'Admin::Images', g.controller_class_name
      assert_equal ['admin'], g.controller_class_path
      assert_equal 'images', g.plural_name
    end
  end

end
