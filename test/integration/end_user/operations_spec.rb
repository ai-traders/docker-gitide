require_relative './spec_helper'
require 'English'

context 'operations' do
  context 'when /ide/work and dummy /ide/identity mounted as volume' do
    it 'git clone sth fails' do
      cmd = "docker run --rm -v #{dummy_work}:/ide/work "\
        "-v #{dummy_identity}:/ide/identity:ro "\
        " #{docker_image} \"git clone git@git.ai-traders.com:edu/bash.git "\
        "&& ls -la bash && pwd\""

      puts "running: #{cmd}".cyan
      output = `#{cmd} 2>&1`
      exit_status = $CHILD_STATUS.exitstatus
      puts output

      expect(output).to include(
        'Please make sure you have the correct access rights')
      expect(exit_status).not_to eq 0
    end
  end
  context 'when /ide/work and real /ide/identity mounted as volume' do
    it 'git clone sth works' do
      cmd = "docker run --rm -v #{dummy_work}:/ide/work "\
        "-v #{real_identity}:/ide/identity:ro "\
        " #{docker_image} \"git clone git@git.ai-traders.com:edu/bash.git "\
        "&& ls -la bash && pwd\""

      puts "running: #{cmd}".cyan
      output = `#{cmd} 2>&1`
      exit_status = $CHILD_STATUS.exitstatus
      puts output

      expect(output).to include("Cloning into 'bash'")
      expect(exit_status).to eq 0
    end
  end
end
