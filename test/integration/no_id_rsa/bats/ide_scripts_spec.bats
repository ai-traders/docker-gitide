load '/bats-support/load.bash'
load '/bats-assert/load.bash'

@test "/usr/bin/entrypoint.sh returns 0" {
  run /usr/bin/entrypoint.sh whoami 2>&1
  assert_equal "$status" 1
  assert_line --partial "/ide/identity/.ssh/id_rsa does not exist"
}
