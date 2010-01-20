class RateableAttributesGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.migration_template 'migration.rb', 'db/migrate', :migration_file_name => "rateable_attributes_migration"
      m.directory "public/images/ratings"
      m.file "star_rated.png", "public/images/ratings/star_rated.png"
      m.file "star_unrated.png", "public/images/ratings/star_unrated.png"
      m.file "star_hover.png", "public/images/ratings/star_hover.png"
      m.file "rateable_attributes.js", "public/javascripts/rateable_attributes.js"
    end
  end
end
