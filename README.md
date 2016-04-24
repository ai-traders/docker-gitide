# gitide

An example [IDE](https://github.com/ai-traders/ide) docker image. Allows
 you to run Git commands in Docker.

## Usage
Example Idefile:
```
IDE_DOCKER_IMAGE="gitide:0.2.0"
```

By default, current directory in docker container is `/ide/work`.

Example command:
```bash
ide "git clone git@github.com:ai-traders/ide.git && ls -la ide && pwd"
```

You have to update the [ide-setup-identity.sh](scripts/ide-setup-identity.sh)
 file in order to make this work with your private git server (just the
 `${ide_home}/.ssh/config` file generation).

### Configuration
Those files are used inside gitide docker image:
1. `~/.ssh/config` -- will be generated on docker container start
2. `~/.ssh/id_rsa` -- it must exist locally, because it is a secret
2. `~/.gitconfig` -- if exists locally, will be copied
3. `~/.profile` -- will be generated on docker container start, in
   order to ensure current directory is `/ide/work`.

## Development
The **actual code** is:
 * `Dockerfile`
 * `scripts/` directory

*There are some test tools which are not open source (yet)*

The **tests** are:
 * `test/integration/default` - a default Test-Kitchen suite
 * `test/integration/dummy_identity` - contains secrets/configuration files
    for tests (for Test-Kitchen and end user tests). Permissions of
    dummy `~/.ssh/id_rsa` should be 600, but git does not preserve them anyways.
 * `test/integration/dummy_work` - just an empty directory which will be mounted
    when testing, so that `ide-fix-uid-gid.sh` works
 * `test/integration/end_user` - end user RSpec tests, to test the real usage
 with `docker run commands`

All the **test rake tasks**:
```bash
# Run repocritic linting.
$ rake style
# Build gitide docker image. This will generate imagerc file
# (dockerimagerake gem is responsible for this).
$ rake build
# This is crucial to make .kitchen.image.yml a valid yaml file, it needs some
# environment variables, which are in imagerc file.
$ source imagerc
# Run Test-Kitchen tests using dummy identity.
$ chef exec bundle exec kitchen converge default-docker-image
$ chef exec bundle exec kitchen verify default-docker-image
# Run end user tests using both: dummy and real identities.
$ rake itest:end_user_test
```

There is a `docker_image_version.txt` file in `scripts` directory which keeps
 this docker image version. Perhaps that is wrong.

**Gem dockerimagerake** is used to:
 * provide test rake tasks
 * create imagerc file
 * provide docker image build rake task
 * provide release and publish rake tasks
Those rake tasks are used in `ci.gopipeline.json` file.