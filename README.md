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

_Master Key_
```
a8c7cf7a96525ead70b37e51679cbb8b
```

_Development Key_
```
7ce997a0e3ac9e8cfc742b63d370713b
```

_Test Key_
```
4a4cb881d2e4ee19bd61099684806227
```

1. `git clone git@github.com:adiwids/tripla_assignment.git`
2. `cd tripla_assignment`
3. `touch config/master.key && echo "a8c7cf7a96525ead70b37e51679cbb8b" > config/master.key`
4. `touch config/credentials/development.key && echo "7ce997a0e3ac9e8cfc742b63d370713b" > config/credentials/development.key`
5. `touch config/credentials/test.key && echo "4a4cb881d2e4ee19bd61099684806227" > config/credentials/test.key`
6. `bundle install && yarn install`
7. `bundle exec rails db:setup`

**Run Tests**

```
bundle exec rspec
```

**Run API Server**

```
bundle exec rails s
```

## Tech Documentations

- [API Documentation](/API_DOCS.md)

## How To

**Generate User Token**

1. Get User ID from `rails console`
2. Run Rake task `bundle exec rails user:generate_token[{user_id}]`
   Change `{user_id}` with ID from step 1.
3. Copy token output from console.
