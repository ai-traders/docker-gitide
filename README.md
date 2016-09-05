# docker-gitide

An example [IDE](https://github.com/ai-traders/ide) docker image. Allows
 you to run Git commands in Docker. Illustrates how to build and test
 IDE docker image.

## Usage
1. Install [IDE](https://github.com/ai-traders/ide)
2. Provide an Idefile:
```
IDE_DOCKER_IMAGE="gitide:0.3.0"
```
3. Run, example command:
```bash
ide "git clone https://github.com/ai-traders/docker-gitide && ls -la ide && pwd"
```



By default, current directory in docker container is `/ide/work`.

You have to update the [ide-setup-identity.sh](image/etc_ide.d/scripts/20-ide-setup-identity.sh)
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

### Dependencies
Bash, IDE, and Docker daemon. Needed is docker IDE image with:
  * Docker daemon
  * IDE (we run IDE in IDE)
  * ruby

All the below tests are supposed to be invoked inside an IDE docker image:
```bash
ide
bundle install
```

### Fast tests
```bash
# Run repocritic linting.
bundle exec rake style
```

Normally you could create here a docker image just with IDE configs installed and
 test it, to fail fast. (2 Dockerfiles idea). But, since gitide is very simple, there is nothing more
 to install once IDE configs (and git) are installed.

### Build
Build gitide docker image. This will generate imagerc file
(dockerimagerake gem is responsible for this).

```bash
bundle exec rake build
```

### Long tests
Having built the gitide docker image, there are 2 kind of tests available:

```bash
# Test-Kitchen tests, test that IDE configs are set and that system packages are
# installed
bundle exec rake kitchen


# RSpec tests invoke ide command using Idefiles and the just built gitide docker
# image
bundle exec rake install_ide # TODO: IDE should be installed in IDE docker image
bundle exec rake install_bats # TODO: Bats should be installed in IDE docker image
bundle exec rake end_user
```

**OR** you can run Test-Kitchen tests also this way:
```bash
source image/imagerc
bundle exec kitchen converge default
bundle exec kitchen verify default
bundle exec kitchen destroy default
```

Here `.kitchen.image.yml` is used.

## License

This project is licensed under the [GNU Lesser General Public License v3.0](http://choosealicense.com/licenses/lgpl-3.0/) license.
