load '/ide/work/bats-support/load.bash'
load '/ide/work/bats-assert/load.bash'

test_ide_work="/ide/work/test/integration/end_user/test_ide_work"

@test "when no_id_rsa_identity: fails: /ide/identity/.ssh/id_rsa does not exist" {
  cd ${test_ide_work}
  run ide --idefile NoIdRsaIdefile "whoami"
  assert_output --partial "/ide/identity/.ssh/id_rsa does not exist"
  assert_equal "$status" 1
}
@test "when full identity: it is correctly initialized; pwd shows /ide/work" {
  cd ${test_ide_work}
  run ide "pwd && whoami"
  assert_output --partial "ide init finished"
  assert_output --partial "/ide/work"
  assert_output --partial "ide"
  assert_output --partial "gitide"
  assert_equal $(echo "$output" | grep "root" -c) 0
  assert_equal "$status" 0
}
@test "when full identity: it copied ~/.ssh/id_rsa" {
  cd ${test_ide_work}
  run ide "cat ~/.ssh/id_rsa"
  assert_output --partial "ide init finished"
  assert_output --partial "inside id_rsa"
  assert_equal "$status" 0
}
@test "when full identity: it can git clone from github" {
  rm -rf "${test_ide_work}/docker-gitide"
  cd ${test_ide_work}
  run ide "git clone https://github.com/ai-traders/docker-gitide"
  assert_output --partial "Cloning into 'docker-gitide'..."
  assert_equal "$status" 0
  rm -rf "${test_ide_work}/docker-gitide"
}
