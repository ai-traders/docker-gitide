require 'oversion'
require 'gitrake'
require 'kitchen'

GitRake::GitTasks.new

image_dir = File.expand_path("#{File.dirname(__FILE__)}/image")

# This can be easily done in bash
desc 'Gets next_version from Consul and saves to version file'
task :save_version do
  version = OVersion.get_version()
  version_file = "#{image_dir}/etc_ide.d/variables/60-variables.sh"
  text = File.read(version_file)
  new_contents = text.gsub(/IMAGE_VERSION/, version)
  File.open(version_file, "w") {|file| file.puts new_contents }
end

task :build do
  Dir.chdir(image_dir) do
    version = OVersion.get_version()
    Rake.sh("docker build -t gitide:#{version} .")
    File.write("#{image_dir}/imagerc","export AIT_DOCKER_IMAGE_NAME=\"gitide\"
export AIT_DOCKER_IMAGE_TAG=\"#{version}\"")
  end
end
task build: [:save_version]

desc 'Run Test-Kitchen tests on built image'
task :kitchen do
  Rake.sh(". #{image_dir}/imagerc && export KITCHEN_YAML='#{File.dirname(__FILE__)}/.kitchen.image.yml' && kitchen test")
end

task :install_ide do
  Rake.sh('sudo bash -c "`curl -L https://raw.githubusercontent.com/ai-traders/ide/0.5.0/install.sh`"')
end
task :install_bats do
  Rake.sh('git clone --depth 1 https://github.com/sstephenson/bats.git && \
    git clone --depth 1 https://github.com/ztombol/bats-support.git && \
    git clone --depth 1 https://github.com/ztombol/bats-assert.git && \
    sudo ./bats/install.sh /usr/local')
end
desc 'Run end user tests'
task :end_user do
  if !File.file?("#{image_dir}/imagerc")
    fail "#{image_dir}/imagerc does not exist"
  end
  test_dir = File.expand_path("#{File.dirname(__FILE__)}/test/")
  test_ide_work = File.expand_path("#{test_dir}/integration/end_user/test_ide_work")
  begin
  Rake.sh(". #{image_dir}/imagerc && echo "\
    "\"IDE_DRIVER=docker
IDE_DOCKER_IMAGE=\\\"${AIT_DOCKER_IMAGE_NAME}:${AIT_DOCKER_IMAGE_TAG}\\\"
IDE_IDENTITY=\\\"#{test_dir}/integration/identities/full\\\"\" > "\
    "#{test_ide_work}/Idefile && "\
    "echo \"IDE_DRIVER=docker
IDE_DOCKER_IMAGE=\\\"${AIT_DOCKER_IMAGE_NAME}:${AIT_DOCKER_IMAGE_TAG}\\\"
IDE_IDENTITY=\\\"#{test_dir}/integration/identities/no_id_rsa\\\"\" > "\
    "#{test_ide_work}/NoIdRsaIdefile && "\
    "bats #{test_dir}/integration/end_user/bats")
  ensure
    FileUtils.rm("#{test_ide_work}/Idefile")
    FileUtils.rm("#{test_ide_work}/NoIdRsaIdefile")
  end
end
