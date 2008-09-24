module Aftimagr
  class Utilities
    
    # APPTODO: Improve (and consolidate) these regular expressions.
    #
    # Current limitations:
    # - Each CSS selector must be on its own line. For example:
    #   /* This works */
    #   img.className,
    #   img.class-name {
    #     /* styles go here */
    #   }
    #   /* This DOES NOT work currently. It will only match the first img class selector on the line */
    #   img.className, img.class-name {
    #     /* styles go here */
    #   }
    IMG_CLASS_RE = /img\.([A-Za-z0-9\-_]+)/
    STAR_CLASS_RE = /\*\.([A-Za-z0-9\-_]+)/
    NO_STAR_CLASS_RE = /\A\.([A-Za-z0-9\-_]+)/
    
    def self.generate_img_css_classes
      returning img_css_classes = [] do
        yaml = YAML.load_file("#{RAILS_ROOT}/config/aftimagr.yml")
        if yaml
          stylesheet_paths = yaml['stylesheets'] ? yaml['stylesheets'].split(' ') : []
          stylesheet_paths.each do |stylesheet_path|
            File.open("#{RAILS_ROOT}/public/stylesheets/#{stylesheet_path}") do |f|
              f.readlines.each do |line|
                match = IMG_CLASS_RE.match(line) || STAR_CLASS_RE.match(line) || NO_STAR_CLASS_RE.match(line)
                if match
                  match.captures.each { |c| img_css_classes << c }
                end
              end
            end
          end
        end
      end
    end
  end
end
  
