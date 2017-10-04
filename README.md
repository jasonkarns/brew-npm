# `brew-npm` -- Install npm apps as Homebrew Formulas

`brew npm` allows you to install any `npm` app as a homebrew formula.

It works by generating a stub formula for homebrew, which looks something like this:

```
class Ronn < Formula
  def initialize(*args)
    @name = "ronn"
    @version = "0.7.3"
    super
  end

  def install
    system "npm", "install", name, "--version", version, "--install-dir", prefix
  end
end
```

This formula installs and unpacks all the dependencies under the Cellar path, so the package is completely self contained and within the Homebrew directories.

## Dependencies

This requires a system rubygems version of 2.3 or greater. There is a bug prior to 2.3 that doesn't install the full dependency tree properly when you use the install-dir flag.

```
sudo /usr/bin/gem update --system
```

## Install

There are two ways to install `brew-npm`: via Homebrew or via Rubygems.

Usually, the Rubygems release will track ahead of the Homebrew recipe, so to receive the latest features the quickest, use the Rubygems install instructions.

_Warning_: If you previously installed `brew-npm` with Homebrew, the Rubygems install method will fail. Run `brew unlink brew-npm` or `brew uninstall brew-npm` first.

### Via Rubygems:

```
gem install brew-npm
brew-gem install brew-npm
```

### Via Homebrew:

```
brew install brew-npm
```

## Usage

```
brew npm install heroku
```

To install a specific version:

```
brew npm install heroku 3.8.3
```

To upgrade:

```
brew npm upgrade heroku
```

To uninstall:

```
brew npm uninstall heroku
```

To check information:

```
brew npm info heroku
```

Note:

Installed npm apps are listed in `brew list` with prefix of `npm-`, like `npm-heroku`.

## BASH/ZSH Completions

To make use of completions for npm, you need to install the `bash-completion` formula:

```
brew install bash-completion
```

And then install a gem with the completion files in the following locations:

- A directory named either `completion` or `completions` with the file being the name of the gem appended with the completion type.

  For example: `completions/tmuxinator.bash`

- A file somewhere in your repo named `<your_gem_name>_completion.zsh`.

Files with `.bash` and `.sh` will be associated with bash and files ending in `.zsh` will be associated with zsh.

## Philosophy

This is **not** for installing development libraries, but for standalone binary tools that you want system wide - aka for RUNNING apps, not for working on as a developer.

## Troubleshooting

If your seeing build errors similar to this:

```shell
==> Fetching opsicle from gem source
==> gem install /Library/Caches/Homebrew/opsicle-0.4.2.gem --no-rdoc --no-ri --no-user-install --install-dir /usr/local/Cellar/opsicle/0.4.2 --bindir /usr/local/Cellar/opsicle/0.4.2/bin
make: *** [generator.bundle] Error 1
Gem files will remain installed in /usr/local/Cellar/opsicle/0.4.2/gems/json-1.8.1 for inspection.
Results logged to /usr/local/Cellar/opsicle/0.4.2/gems/json-1.8.1/ext/json/ext/generator/gem_make.out
READ THIS: https://github.com/Homebrew/homebrew/wiki/troubleshooting
```

You probably have xcode 5.1 installed which changed the way the compilers handle flags.

You'll need to set `ARCHFLAGS=-Wno-error=unused-command-line-argument-hard-error-in-future` before installing. _You may want to add this to your profile so you don't have to set it each time._
