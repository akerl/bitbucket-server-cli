# Bitbucket Server Command Line Tools

[ ![Build Status](https://bitbucket-badges.useast.atlassian.io/badge/atlassian/bitbucket-server-cli.svg)](https://bitbucket.org/atlassian/bitbucket-server-cli/addon/pipelines/home)

This command line tool is a utility for Bitbucket Server (where you download and host bitbucket yourself). If you are
a user of Bitbucket Cloud (bitbucket.org) then this tool is not for you.

## Installing this tool
This tool is written in Ruby and is deployed as a [Ruby Gem](https://rubygems.org/gems/atlassian-stash/). Installation is easy, simply run the following command

```
#!text
$> gem install atlassian-stash
```

(Protip: you might need to `sudo`)

Once the gem is installed, the command `stash` will be in your `$PATH`

## Configuration and usage
Run `stash configure`. This will prompt for details about your Bitbucket Server instance. If no password is provided, then you will be prompted for a password when executing commands to Bitbucket Server.

The global configuration file lives at `$HOME/.stashconfig.yml` and any options in a similarly named `.stashconfig.yml` file in the root of a git repository will take precedence.

### Passwords
There are currently two ways to store your password in the configuration file. You may store it as plain text with the key `password`, for example:

```
password: s3cre7
```

Or you may store a command string with the `passwordeval` key which allows you to use any encrypted method you like in order to store your password. For example, if using gpg:

```
passwordeval: gpg --no-tty --quiet --decrypt ~/.secret.gpg
```

The `stash configure` utility will not prompt you for this. If you wish to use `passwordeval`, omit a password during the configuration and add it to `~/.stashconfig.yml` afterwards.


### Creating a pull request
Use the `pull-request` command to create a pull request in Bitbucket Server. For example:

```
#!text
$> stash pull-request topicBranch master @michael
Create a pull request from branch 'topicBranch' into 'master' with 'michael' added as a reviewer
```

See the usage for command details 

```
#!text
$> stash help pull-request
```

### Opening the Bitbucket Server web UI
Use the `browse` command to open the Bitbucket Server UI for your repository in the browser.

```
#!text
$> stash browse -b develop
Open the browser at the Bitbucket Server repository page for the branch 'develop'
```

For more options, see the help

```
#!text
stash help browse
```

## Configuration options

Running `stash configure` will prepopulate `~/.stashconfig.yml` with a variety of options. Complete options are:

```
#!yaml
username: seb # username to connect to Bitbucket Server server.
password: s3cr3t # password for user. If ommitted, you will be prompted at the terminal when making a request to Bitbucket Server
stash_url: https://bitbucket.server.com # fully qualified Bitbucket Server url
remote: upstream # Pull requests will be created in the Bitbucket Server repository specified by this remote
open: true # opens newly created pull requests in the browser
ssl_no_verify: true # do not check ssl certificates for the configured Bitbucket Server server
```

## Troubleshooting
Q: I installed the gem, but the `stash` command doesn't work.  
A: Do you have another command called `stash` or do you have an alias? Have a look where the command maps to

```
#!text
$> which -a stash
```

Then check the value of your $PATH

## I want to contribute
Thanks! Please [fork this project](https://bitbucket.org/atlassian/stash-command-line-tools/fork) and create a pull request to submit changes back to the original project.

### Build instructions
Building this gem is easy. To get started, run the following commands:

```
#!text
$> gem install bundler
$> bundle install
```

Now start hacking, and run the stash command by invoking `./bin/stash command`

### Testing

Easy:

```
$> rake test
```

### Releasing

#### Bumping versions

Use `rake version`:

```
version             -- displays the current version
version:bump:major  -- bump the major version by 1
version:bump:minor  -- bump the a minor version by 1
version:bump:patch  -- bump the patch version by 1
version:write       -- writes out an explicit version
```

#### Releasing

```
$> rake release
```