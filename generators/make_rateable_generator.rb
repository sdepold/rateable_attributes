class MakeRateableGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.migration_template 'migration.rb', 'db/migrate', :migration_file_name => "make_rateable_migration"
      m.directory "public/images/ratings"
      m.file "star_rated.png", "public/images/ratings/star_rated.png"
      m.file "star_unrated.png", "public/images/ratings/star_unrated.png"
    end
  end
end
