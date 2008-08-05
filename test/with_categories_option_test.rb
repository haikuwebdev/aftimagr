require File.join(File.dirname(__FILE__), 'test_helper')

class WithCategoriesOptionTest < GeneratorTestCase
  
  def test_generates_names
    # APPTODO: Fix naming with CamelCased arg, e.g., ProductLine
    %w(product_line).each do |arg|
      g = Rails::Generator::Base.instance('aftimagr', arg.to_a)
      assert_equal "product_line_category", g.category_name
      assert_equal "product_line_category", g.category_singular_name
      assert_equal "CreateProductLineCategories", g.categories_migration_name
      assert_equal "product_line_categories", g.categories_table_name
      assert_equal "product_line_categories", g.categories_plural_name
      assert_equal "product_line_categories", g.categories_controller_file_name
    end
  end
  
  def test_generates_routes
    run_generator('aftimagr', %w(article_image --with-categories))
    assert_added_route_for :article_image_categories
  end
  
  def test_generates_migration
    run_generator('aftimagr', %w(article_image --with-categories))
    assert_generated_migration :create_article_image_categories
  end
  
  def test_generates_model
    run_generator('aftimagr', %w(article_image --with-categories))
    assert_generated_model_for :article_image_category
  end
  
  def test_does_not_generate_model
    run_generator('aftimagr', %w(article_image))
    assert_skipped_model :article_image_category
  end
  
  def test_generates_controller
    run_generator('aftimagr', %w(article_image --with-categories))
    assert_generated_controller_for :article_image_categories
  end
  
  def test_generates_namespaced_controller
    run_generator('aftimagr', %w(admin::image --with-categories))
    assert_generated_controller_for "admin::image_categories"
  end
  
  def test_generates_names_for_namespaced_controller
    %w(admin/image Admin::Image).each do |namespaced_string|
      g = Rails::Generator::Base.instance('aftimagr', [namespaced_string, '--with-categories'])
      assert_equal 'Admin::ImageCategories', g.categories_controller_class_name
      assert_equal ['admin'], g.controller_class_path
      assert_equal 'image_categories', g.categories_table_name
    end
  end
  
  def test_generates_views
    run_generator('aftimagr', %w(article_image --with-categories))
    assert_generated_views_for :article_image_categories, 'index.html.erb',
        'edit.html.erb', 'new.html.erb', 'show.html.erb'
  end
  
end