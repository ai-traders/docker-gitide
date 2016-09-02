require 'dockerimagerake'

ENV['DOCKERIMAGERAKE_LOG_LEVEL'] = 'debug'
opts = DockerImageRake::Options.new(
  image_name: 'gitide',
  image_dir: "#{File.dirname(__FILE__)}")

desc 'Runs style tests: RepoCritic'
task style: ['style:repocritic']
desc 'Runs all small tests'
task test: ['style']
desc 'Runs all test-kitchen suites for all platforms'
task itest: ['itest:kitchen:all']
task default: :test

# creates validate_repo task
DockerImageRake::DestructiveValidateRepo.new(opts)
# creates style:repocritic task
DockerImageRake::RepoCritic.new(opts)
# creates all kitchen tasks in itest namespace
DockerImageRake::Kitchen.new(opts)
# creates release:code rake task
DockerImageRake::Code.new(opts)
# creates release:publish rake task
DockerImageRake::Publish.new(opts)

# custom build task, in order to not push to any registry
desc 'Builds docker image and pushes it to docker registry'
task :build do
  image_name = opts.image_name
  if opts.image_tag.nil? || opts.image_tag == ''
    info = GitInfo.new(opts.repo_dir)
    image_tag = info.last_git_sha()
  else
    image_tag = opts.image_tag
  end

  Dir.chdir(opts.repo_dir) do
   Rake.sh("docker build -t #{image_name}:#{image_tag} #{opts.cookbook_dir}")
  end
end

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

  desc 'Clean before test and provide real identity'
  task :end_user_test_prep do
    # Clean test files
    if File.directory?('test/integration/dummy_work/bash')
      FileUtils.rm_r('test/integration/dummy_work/bash')
    end

    # copy real identity files into a directory which will be mounted as
    # /ide/identity
    real_identity_dir = File.join(
      File.dirname(__FILE__), 'test/integration/end_user/real_identity/')

    FileUtils.mkdir_p(real_identity_dir)
    if !File.directory?("#{ENV['HOME']}/.ssh")
      fail "#{ENV['HOME']}/.ssh does not exist"
    else
      FileUtils.cp_r("#{ENV['HOME']}/.ssh", "#{real_identity_dir}/")
    end

    if File.file?("#{ENV['HOME']}/.gitconfig")
      cp("#{ENV['HOME']}/.gitconfig", "#{real_identity_dir}/")
    end
  end
  task end_user_test: :end_user_test_prep

  task :kitchen do
    Rake.sh(". ./imagerc && kitchen converge default-docker-image && kitchen exec default-docker-image -c \"bats /tmp/bats\" ; kitchen destroy default-docker-image")
  end
end

# mapped tasks for Go Server, no desc
namespace 'go' do
  namespace 'itest' do
    task :end_user_test do
      Rake::Task['itest:end_user_test'].invoke
    end
  end
end
