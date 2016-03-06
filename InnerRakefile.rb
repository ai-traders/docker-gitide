require 'dockerimagerake'

ENV['DOCKERIMAGERAKE_LOG_LEVEL'] = 'debug'
opts = DockerImageRake::Options.new(
  image_name: 'docker-registry.ai-traders.com/gitide')
DockerImageRake::DockerImage.new(opts)

namespace 'itest' do
  desc 'Run end user tests'
  RSpec::Core::RakeTask.new(:end_user_test) do |t|
    # env variables like AIT_DOCKER_IMAGE_NAME are set by dockerimagerake gem
    t.rspec_opts = [].tap do |a|
      a.push('--pattern test/integration/end_user/**/*_spec.rb')
      a.push('--color')
      a.push('--tty')
      a.push('--format documentation')
      a.push('--format h')
      a.push('--out ./rspec.html')
    end.join(' ')
  end

  desc 'Test if configuration files exist to fail fast'
  task :end_user_test_prep do
    # copy real identity files into a directory which will be mounted as
    # /ide/identity
    real_identity_dir = File.join(
      File.dirname(__FILE__), 'test/integration/end_user/real_identity/')

    mkdir_p("#{real_identity_dir}/.bashrc.d/")
    if !File.directory?("#{ENV['HOME']}/.ssh")
      fail "#{ENV['HOME']}/.ssh does not exist"
    else File.file?("#{ENV['HOME']}/.bashrc.d/openstack")
      cp_r("#{ENV['HOME']}/.ssh", "#{real_identity_dir}/")
    end

    if File.file?("#{ENV['HOME']}/.gitconfig")
      cp("#{ENV['HOME']}/.gitconfig/", "#{real_identity_dir}/")
    end
  end
  task end_user_test: :end_user_test_prep
end

# mapped tasks for Go Server, no desc
namespace 'go' do
  namespace 'itest' do
    task :end_user_test do
      Rake::Task['itest:end_user_test'].invoke
    end
  end
end
