def this_dir
  File.dirname(__FILE__)
end

rule(//) do |task|
  # All rake tasks use main Gemfile
  ENV['BUNDLE_GEMFILE'] = File.expand_path("#{this_dir}/Gemfile")
  unless ENV['SKIP_ALL_DEPENDENCIES'] || ENV['SKIP_RUBY_DEPENDENCIES']
    puts "running bundle install for rake task: #{task.name}"
    sh 'chef exec bundle install'
  end
  inner_rakefile = File.expand_path("#{this_dir}/InnerRakefile.rb")
  sh "chef exec bundle exec rake #{task.name} -f #{inner_rakefile}"
end
