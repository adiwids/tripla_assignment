## Assumptions

- Following feature only covers to follow and unfollow user, request management is out-of scope of this assignment.
- User authentication flow is not covered in this assignment, and replaced by generating JWT token manually.

## Limitation

- Sign in API replaced by generating JWT token manually via Rake task.

## Acceptance Criteria

### Feature: Clock-in to sleep

```
Scenario: User is going to sleep
  Given User is awake
  When User wants to go to sleep
  Then User sets the desired wake up time
```

```
Scenario: User want to clock-in, but forgot to stop after awake
  Given User has been sleeping
  When User wakes up
    And User doesn't complete previous sleep
    And User want to sets another wake up time
  Then User will be prohibitted to do so until complete the previous one
```

### Feature: Sleep duration calculation

```
Scenario: User wake up from sleep
  Given User has been awake from sleep
  When User sets previous sleep as completed by setting the actual wake up time
  Then sleep duration calculated from the actual wake up time
```

### Feature: User's sleep Durations List

```
Scenario: User has followed users and they are actively clock-in
  Given User requests for sleep duration length list for past week
  When data is available
  Then User sees list of completed sleep cycles ordered by duration from his/her followed users logged from 7 days ago till now
```

### Feature: Follow other user

```
Scenario: User is browsing users to be followed
  Given User is viewing list of users
  When User follows an another user
  Then Followed User appears in followings list
    And User is appeared in Followed User's followers list
```

### Feature: Unfollow user

```
Scenario: User only follow, but the user followed is not following back
  Given User is viewing his/her followings list
  When User unfollows a user
    Then user who-is-unfollowed disappear from User's followings list
      And User disappear on followers list of user who already unfollowed
```

```
Scenario: User and the other one following each others
  Given User is following Other User
    And Other User is following User as well
  When User unfollows Other User
  Then Other User disappear from User's followings list
    And Other User keep remaining on User's followers
    And User disappear from Other User's followers list
    And User keep remaining on Other User's followings list
```
