# Working with the MTRA Web Site

## Workstation setup for mtragj site (Ruby and Jekyll)

```bash
# Install asdf runtime manager
sudo apt install curl git
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.15.0

# Add following lines to end of your .bashrc file
. "$HOME/.asdf/asdf.sh"
. "$HOME/.asdf/completions/asdf.bash"

# Start a new shell

# Install ruby plugin dependencies for your OS, below is for Ubuntu
sudo apt-get install autoconf patch build-essential rustc libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libgmp-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev uuid-dev

# Add the ruby plugin
asdf plugin add ruby

# Create asdf config
touch ~/.asdfrc

# Add the following line to your asdf config
legacy_version_file = yes

# Clone the mtra git project and chdir
# Use --recurse-submodules so the dirt-bike-game submodule is checked out too
git clone --recurse-submodules git@github.com:mtragj/mtragj.git
cd mtragj

# Install Ruby and gems
asdf install ruby
bundle install
```

## Common Commands
* Fire up a local copy of the web site: `bundle exec jekyll server --config _config_dev.yml, _config.yml`
  * output will include a local URL to copy into your browser. E.G. `http://127.0.0.1:4000/mtra/`
  * For most content updates the site will auto-regenerate when you edit a file
  * For more substantial changes (coding/templates) you may want to ctrl-c the exec command restart the local server with the above command

## Submodules

The dirt bike game lives in its own repo and is pulled in as a git submodule at `dirt-bike-game/`. GitHub Pages clones it automatically during the site build.

* If you cloned without `--recurse-submodules`, initialize the submodule once:
  ```bash
  git submodule update --init
  ```
* To pull in newer commits from the game repo (after the game has been updated):
  ```bash
  git submodule update --remote dirt-bike-game
  git add dirt-bike-game
  git commit -m "bump dirt-bike-game submodule"
  ```
  The bumped pointer is what triggers the new game version on the live site.
* After pulling mtragj changes that updated the submodule pointer, run `git submodule update` to sync your local checkout.
