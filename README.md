
# What is it? #

 moosh

This missing Moodle shell.


# To install #

```
cd ~
git clone git@github.com:brendanheywood/moodle-moosh.git moosh
```

Add a couple lines to ~/.bashrc 

```
export PATH="$PATH:~/moosh/bin"
eval "$(~/moosh/bin/moosh init -)"
```

# Usage #

moosh

It is self documenting so that's all you need. 



# Shouldn't this be part of moodle like drush is part of drupal? #

Maybe?

For security it's probably best if this is separate anyway.

It's also highly lighly that this set of utils could evolve quicker to catch up with Moodle


# What about the stuff in /admin/cli/ #

Yeah but it kinda sucks. This is the start of a framework that could actually be a pleasure to use.


# This is magic! How does it work? #

Use the source. It is built on the awesome 'sub' project from 27 signals.

It then autodetects that it is inside a moodle directory, reads it's config script and goes from there.


# What's it need to run #

In theory, nothing that wouldn't be on the server anyway as part of a moodle install.




