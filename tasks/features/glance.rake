namespace :feature do
  feature_name "Glance"

  namespace :glance do
    desc "Create image"
    feature_task :create_image, tags: :@create_image
    feature_task :all
 end

  desc "Complete verification of 'Glance' feature"
  task :glance => "glance:all"
end
