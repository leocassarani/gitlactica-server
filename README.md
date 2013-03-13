# gitlactica-server

[Gitlactica](https://github.com/carlmw/gitlactica) is a space-themed, WebGL-based, GitHub activity visualisation.

It is a work in progress and constantly evolving as we refine its scope and features.

## Installation

### Authenticate with GitHub

Copy the example `auth.yml` file:

    cp config/auth.yml.example config/auth.yml

Then edit `config/auth.yml` with your GitHub username and password (OAuth support is in the pipeline).

### Run the server

    bundle install
    bundle exec bin/gitlactica

### Get the frontend

Go to [https://github.com/carlmw/gitlactica](https://github.com/carlmw/gitlactica) and follow the instructions.

### Profit

Point your (WebGL-capable) browser at [http://localhost:8000](http://localhost:8000).
