# Atlassian Stash Command Line Tools

## Installing this tool
This command line helper for Stash is written in Ruby and is deployed as a [Ruby Gem](https://rubygems.org/gems/atlassian-stash/). Installation is easy, simply run the following command

    $> gem install atlassian-stash

(Protip: you might need to `sudo`)

Once the gem is installed, the command `stash` will be in your `$PATH`, so be 

## Configuration
1. run `stash configure`
2. From your git repository, run `git create-pull-request master` to create a pull request from your current branch to master

See the usage help for more information by running

    stash help

## Troubleshooting
Q: I installed the gem, but the `stash` command doesn't work.
A: Do you have another command called `stash` or do you have an alias? Have a look where the command maps to
    $> which -a stash
Then check the value of your $PATH

## I want to contribute
Thanks! Please [fork this project](https://bitbucket.org/atlassian/atlassian-stash-rubygem/fork) and create a pull request to submit changes back to the original project.

### Build instructions
Building this gem is easy. To get started, run the following commands:
    $> gem install bundler
    $> bundler install

Now start hacking, and run the stash command by invoking `./bin/stash command`
