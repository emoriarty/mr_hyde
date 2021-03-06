[![Gem Version](https://badge.fury.io/rb/mr_hyde.svg)](https://badge.fury.io/rb/mr_hyde)

<img src="https://raw.githubusercontent.com/emoriarty/mr_hyde/master/resources/mrhyde-logo.png" alt="Mr.Hyde logo" height="100"/>
# MrHyde
Mr. Hyde lets you generate and manage as many static sites as you like, all nested from a parent site, for example, you can have several nested sites sharing the same assets than parent site and other nested sites with its own assets.

All this works thanks to [Jekyll](http://jekyllrb.com) tool, in fact Mr. Hyde wraps Jekyll so if you know Jekyll there is no much to learn about Mr. Hyde.

The current version is based on [Jekyll 3.1.1](https://github.com/jekyll/jekyll/tree/v3.1.1).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mr_hyde'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install mr_hyde
```

## Usage

In order to use Mr. Hyde the first thing you must do is creating the Mr. Hyde root folder using the next command:

```bash
$ mrhyde new [NAME]
```

The previuos command creates the basic structure folder within the new folder NAME, in case the name is not provided then the same folder will be used.

Once created cd the Mr. Hyde root folder (or the same if no NAME was given) and you can execute the next commands:

```bash
$ cd PATH
$ mrhyde site new SITE_NAME
$ mrhyde site build SITE_NAME
```

The above commands give you first site, by now if you want to run on a server get in the site/SITE_NAME and executes:

```bash
$ cd root_folder/site/site_name
$ jekyll serve
```

If you want to know more about this, please refer to [Jekyll](http://jekyllrb.com/).

Removing the built site is:

```bash
$ mrhyde site rm SITE_NAME
$ mrhyde site rm SITE_NAME --full
```

The last command with the _--full_ option removes the site source as well, so take care with this option.

You can see more information about the commands with the command line _--help_ option:

```bash
$ mrhyde site new --help
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/mr_hyde/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
