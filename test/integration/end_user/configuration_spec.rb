require_relative './spec_helper'
require 'English'

context 'configuration' do

  context 'when only /ide/work mounted as volume' do
    it 'fails: /ide/identity/.ssh/id_rsa does not exist' do
      cmd = "docker run --rm -v #{dummy_work}:/ide/work "\
        " #{docker_image} \"pwd && whoami\""

      puts "running: #{cmd}".cyan
      output = `#{cmd} 2>&1`
      exit_status = $CHILD_STATUS.exitstatus
      puts output

      expect(output).to include('/ide/identity/.ssh does not exist')
      expect(output).not_to include('root')
      expect(exit_status).to eq 1
    end
  end
  context 'when /ide/work and dummy /ide/identity mounted as volume' do
    it 'correctly initialized; pwd shows /ide/work' do
      cmd = "docker run --rm -v #{dummy_work}:/ide/work "\
        "-v #{dummy_identity}:/ide/identity:ro "\
        " #{docker_image} \"pwd && whoami\""

      puts "running: #{cmd}".cyan
      output = `#{cmd} 2>&1`
      exit_status = $CHILD_STATUS.exitstatus
      puts output

      expect(output).to include('ide init finished (not interactive shell)')
      expect(output).to include('/ide/work')
      expect(output).to include('ide')
      expect(output).not_to include('root')
      expect(exit_status).to eq 0
    end
    it '.gitconfig exist' do
      cmd = "docker run --rm -v #{dummy_work}:/ide/work "\
        "-v #{dummy_identity}:/ide/identity:ro "\
        " #{docker_image} \"ls /home/ide/.gitconfig\""

      puts "running: #{cmd}".cyan
      output = `#{cmd} 2>&1`
      exit_status = $CHILD_STATUS.exitstatus
      puts output

      expect(output).to include('ide init finished (not interactive shell)')
      expect(exit_status).to eq 0
    end
  end
end
