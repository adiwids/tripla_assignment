# Project Intro

["Good Night" Application](/ASSIGNMENT.md) in Ruby on Rails using:

* Ruby 3.2
* SQLite3

_Project initialized by command_

```
rails new . --database=sqlite3 --javascript=webpack --css=bootstrap --skip-test --skip-system-test
```

![Main Branch](https://github.com/adiwids/tripla_assignment/actions/workflows/test.yml/badge.svg?branch=main)

**Prepare for Development/Testing**

_Development Master Key_
```
a8c7cf7a96525ead70b37e51679cbb8b
```

1. `git clone git@github.com:adiwids/tripla_assignment.git`
2. `cd tripla_assignment`
3. `touch config/master.key && echo "a8c7cf7a96525ead70b37e51679cbb8b" > config/master.key`
3. `bundle install && yarn install`
4. `bundle exec rails db:setup`

**Run Tests**

```
bundle exec rspec
```

***Run Web Application**

```
bundle exec rails s
```

Then open `http://localhost:3000` on your browser.
