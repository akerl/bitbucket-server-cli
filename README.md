# Atlassian Stash Command Line Tools

## Installing this tool
This command line helper for Stash is written in Ruby and is deployed as a [Ruby Gem](https://rubygems.org/gems/atlassian-stash/). Installation is easy, simply run the following command

```
#!text
$> gem install atlassian-stash
```

(Protip: you might need to `sudo`)

Once the gem is installed, the command `stash` will be in your `$PATH`

## Configuration and usage
Run `stash configure`. This will prompt for details about your Stash instance. If no password is provided, then you will be prompted for a password when executing commands to Stash. Currently, the password is stored in plain text in a configuration file, `~/.stashconfig.yml` which is protected with a permission bit of `0600`. 

### Creating a pull request
Use the `pull-request` command to create a pull request in Stash. For example:

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

### Opening the Stash web UI
Use the `browse` command to open the Stash UI for your repository in the browser.

```
#!text
$> stash browse -b develop
Open the browser at the Stash repository page for the branch 'develop'
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
username: seb # username to connect to stash server.
password: s3cr3t # password for user. If ommitted, you will be prompted at the terminal when making a request to Stash
stash_url: https://stash.server.com # fully qualified stash url
open: true # opens newly created pull requests in the browser
ssl_no_verify: true # do not check ssl certificates for the configured stash server
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

Just as easy:

```
$> rake test
```