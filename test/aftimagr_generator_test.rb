require File.dirname(__FILE__) + '/test_helper'

class AftimagrGeneratorTest < GeneratorTestCase
  
  def test_generates_controller
    run_generator('aftimagr', %w(article_image))
    assert_generated_controller_for :article_images
  end

end
