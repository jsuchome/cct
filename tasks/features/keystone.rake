namespace :feature do
  feature_name "Keystone"

  namespace :keystone do
    desc "First feature task"
    feature_task :first, tags: :@first

    feature_task :all
  end

  desc "Complete verification of 'Keystone' feature"
  task :keystone => "keystone:all"
end
