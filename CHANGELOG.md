# 0.3.0 (2 Sep 2016)

* install IDE image configs from https://github.com/ai-traders/ide.git
* change base image to alpine, so that gitide is now <30MB
* do not install Chef-client for tests
* replace InnerRakefile and Rakefile with only Rakefile

# 0.2.0

* #8906 separated from ide git repository
* #8906 added test-kitchen tests and end_user tests
* #8906 can be ci released
* #8906 added gocd pipelines
* #8832 `~/.ssh/config` contains git.ai-traders.com and gitlab.ai-traders.com

# 0.0.1

Initial release
