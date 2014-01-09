## About

Simple server-side injector. Implementation is in lib/inject.coffee. Implements "injection scopes" as a first-class concept (similar to google's guice). The injector doesn't prescribe any particular scopes; this app implements two useful ones, "application" and "request".

App itself is a simple toy with lots missing.

## Run

1. npm install
2. sudo npm install -g nodemon
3. nodemon main.coffee

