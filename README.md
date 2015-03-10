# MrHyde

Mr. Hyde lets you generate and manage as many sites as you want.

It's based on [Jekyll](https://github.com/jekyll/jekyll), in fact Mr. Hyde wraps Jekyll to give you the possibilty of managing many sites.

The current version is based on [Jekyll 2.5.3](https://github.com/jekyll/jekyll/tree/v2.5.3).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mr_hyde'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mr_hyde

## Usage

In order to use Mr. Hyde the first thing you must do is creating the Mr. Hyde rootl folder with the next command:

```bash
$ mrhyde new [PATH]
```

The previuos command creates the basic structure folder in the passed in PATH or in the same folder if no PATH given.

Once created get in the Mr. Hyde root folder and you can execute the next commands:

* site new NAME[ NAME ... n]
* site build NAME [NAME ... n]
* site remove NAME [NAME ... n]

One example is 

    $ mrhyde site new site_example

You can see more information about the commands with the command line --help option:

    $ mrhyde site new --help


## Contributing

1. Fork it ( https://github.com/[my-github-username]/mr_hyde/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
