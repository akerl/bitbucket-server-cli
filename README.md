# Atlassian Stash Command Line Tools

## Build instructions
1. gem install bundler
2. bundle install

## Configuration
1. run `stash setup`
2. Setup a Git alias! 

    create-pull-request = !stash pull-request "$@" 

3. From your git repository, run `git create-pull-request master` to create a pull request from your current branch to master

See the usage help for more information by running

    stash help
