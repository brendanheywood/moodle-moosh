
= Usage =

 moosh

This missing Moodle shell.




 moosh backup

 moosh restore


 moosh reset cata

press tab

 moosh reset admin

- resets to a random string and shows you the string


 moosh reset admin mynewpassword

- resets to that password


= Q/A =



== Shouldn't this be part of moodle like drush is part of drupal? ==

Maybe?

For security it's probably best if this is separate anyway.

It's also highly lighly that this set of utils could evolve quicker to catch up with Moodle


== What about the stuff in /admin/cli/ ==

Yeah but it kinda sucks. This is the start of a framework that could actually be a pleasure to use.


== This is magic! How does it work? ==

Use the source. It is built on the awesome 'sub' project from 27 signals.

It then autodetects that it is inside a moodle directory, reads it's config script and goes from there.


== What's it need to run ==

In theory, nothing that wouldn't be on the server anyway.




