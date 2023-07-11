# Test Strategy

## git status tests

Testing the bash function that gathers git information.

`prepare/` contains scripts and a docker container to generate the git status --porcelain output that is parsed to figure out the status of the repo.

`test_git-status.sh` is the test script.

##TODO

* find a way to define that particaulr configs should give particular values _and all other configs should give a default_ this will be a much better kind of test
