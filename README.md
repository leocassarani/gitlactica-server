# Gitlactica Server

[Gitlactica](https://github.com/carlmw/gitlactica) is a space-themed, WebGL-based, GitHub activity visualisation.

It is a work in progress and constantly evolving as we refine its scope and features.

### Get the frontend

Go to [https://github.com/carlmw/gitlactica](https://github.com/carlmw/gitlactica) and follow the instructions on how to build the JavaScript assets.

Then symlink the frontend into the `public` directory:

    $ ln -s public /path/to/gitlactica-frontend

### Start the server

    $ bundle install
    $ bundle exec foreman start

This will start a local server running on localhost:5000.
