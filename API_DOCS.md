# "Good Night" API Documentation

**HTTP 4xx, 5xx Example Response**

```
{
  "message": "Error message"
}
```

## GET /api/user/sleep_cycles

_Returns all current user's sleep cycles log, including completed and active cycles, ordered by creation time from latest to oldest._

**cURL Example Request**

```
curl --header "Authorization: Bearer {token}" --header "Accept: application/json" -X GET "http://localhost:3000/api/sleep_cycles"
```

**HTTP 200 Example Response**

```
{
  "data": [
    {
      "attributes": {
        "actual_wake_up_time": null,
        "created_at": "2023-04-15T05:09:57.841Z",
        "duration_miliseconds": 0,
        "set_wake_up_time": "2023-04-15T13:09:57.840Z",
        "status": "inactive"
      },
      "id": "5",
      "relationships": {
        "user": {
          "data": {
            "id": "1",
            "type": "user"
          }
        }
      },
      "type": "sleep_cycle"
    },
    {
      "attributes": {
        "actual_wake_up_time": null,
        "created_at": "2023-04-15T05:09:57.836Z",
        "duration_miliseconds": 0,
        "set_wake_up_time": "2023-04-15T13:09:57.835Z",
        "status": "active"
      },
      "id": "4",
      "relationships": {
        "user": {
          "data": {
            "id": "1",
            "type": "user"
          }
        }
      },
      "type": "sleep_cycle"
    },
    {
      "attributes": {
        "actual_wake_up_time": "2023-04-14T12:09:57.000Z",
        "created_at": "2023-04-14T05:09:57.000Z",
        "duration_miliseconds": 18000,
        "set_wake_up_time": "2023-04-14T13:09:57.000Z",
        "status": "inactive"
      },
      "id": "3",
      "relationships": {
        "user": {
          "data": {
            "id": "1",
            "type": "user"
          }
        }
      },
      "type": "sleep_cycle"
    }
  ]
}
```

## GET /api/user/sleep_cycles?include_followings=true&only_completed=true&order_by=duration%20desc

_Returns completed sleep cycles of current user and it's followed users, ordered by higest duration to lower._

**cURL Example Request**

```
curl --header "Authorization: Bearer {token}" --header "Accept: application/json" -X GET "http://localhost:3000/api/sleep_cycles?include_followings=true&only_completed=true&order_by=duration%20desc"
```

**HTTP 200 Example Response**

```
{
  "data": [
    {
      "attributes": {
        "actual_wake_up_time": "2023-04-14T12:05:39.000Z",
        "duration_miliseconds": 21600,
        "set_wake_up_time": "2023-04-14T13:05:39.000Z",
        "status": "inactive"
      },
      "id": "3",
      "relationships": {
        "user": {
          "data": {
            "id": "1",
            "type": "user"
          }
        }
      },
      "type": "sleep_cycle"
    },
    {
      "attributes": {
        "actual_wake_up_time": "2023-04-14T12:05:39.000Z",
        "duration_miliseconds": 18000,
        "set_wake_up_time": "2023-04-14T13:05:39.000Z",
        "status": "inactive"
      },
      "id": "2",
      "relationships": {
        "user": {
          "data": {
            "id": "2",
            "type": "user"
          }
        }
      },
      "type": "sleep_cycle"
    }
  ]
}
```

## GET /api/user/sleep_cycles?include_followings=true&only_completed=true&order_by=duration%20desc&since=2023-04-07T13:05:39.000Z

_Returns completed sleep cycles of current user and it's followed users done in past week, ordered by higest duration to lower._

**cURL Example Request**

```
curl --header "Authorization: Bearer {token}" --header "Accept: application/json" -X GET "http://localhost:3000/api/sleep_cycles?include_followings=true&only_completed=true&order_by=duration%20desc&since=2023-04-07T13:05:39.000Z"
```

**HTTP 200 Example Response**

```
{
  "data": [
    {
      "attributes": {
        "actual_wake_up_time": "2023-04-14T12:05:39.000Z",
        "duration_miliseconds": 21600,
        "set_wake_up_time": "2023-04-14T13:05:39.000Z",
        "status": "inactive"
      },
      "id": "3",
      "relationships": {
        "user": {
          "data": {
            "id": "1",
            "type": "user"
          }
        }
      },
      "type": "sleep_cycle"
    },
    {
      "attributes": {
        "actual_wake_up_time": "2023-04-14T12:05:39.000Z",
        "duration_miliseconds": 18000,
        "set_wake_up_time": "2023-04-14T13:05:39.000Z",
        "status": "inactive"
      },
      "id": "2",
      "relationships": {
        "user": {
          "data": {
            "id": "2",
            "type": "user"
          }
        }
      },
      "type": "sleep_cycle"
    }
  ]
}
```

## GET /api/users/{user_id}/sleep_cycles?only_completed=true&order_by=duration%20desc

_Returns completed sleep cycles of a followed user, ordered by higest duration to lower._

**cURL Example Request**

```
curl --header "Authorization: Bearer {token}" --header "Accept: application/json" -X GET "http://localhost:3000/api/users/2/sleep_cycles?only_completed=true&order_by=duration%20desc"
```

**HTTP 200 Example Response**

```
{
  "data": [
    {
      "attributes": {
        "actual_wake_up_time": "2023-04-14T12:12:41.000Z",
        "created_at": "2023-04-14T05:12:41.000Z",
        "duration_miliseconds": 14400,
        "set_wake_up_time": "2023-04-14T13:12:41.000Z",
        "status": "inactive"
      },
      "id": "1",
      "relationships": {
        "user": {
          "data": {
            "id": "1",
            "type": "user"
          }
        }
      },
      "type": "sleep_cycle"
    },
    {
      "attributes": {
        "actual_wake_up_time": null,
        "created_at": "2023-04-15T05:12:41.900Z",
        "duration_miliseconds": 0,
        "set_wake_up_time": "2023-04-15T13:12:41.900Z",
        "status": "active"
      },
      "id": "3",
      "relationships": {
        "user": {
          "data": {
            "id": "1",
            "type": "user"
          }
        }
      },
      "type": "sleep_cycle"
    }
  ]
}
```

## POST /api/user/sleep_cycles

_Start to sleep and planned wake up time (clock-in)_

** cURL Request Example**

```
curl --header "Authorization: Bearer {token}" --header "Accept: application/json" --header "Content-Type: application/json" --data "{sleep_cycle:{set_wake_up_time:\"2023-04-15T14:52:27.000Z\"}}" -X POST "http://localhost:3000/api/user/sleep_cycles"
```

** HTTP 200 Response Example**

```
{
  "data": {
    "attributes": {
      "actual_wake_up_time": null,
      "created_at": "2023-04-15T06:52:27.074Z",
      "duration_miliseconds": null,
      "set_wake_up_time": "2023-04-15T14:52:27.000Z",
      "status": "active"
    },
    "id": "1",
    "relationships": {
      "user": {
        "data": {
          "id": "1",
          "type": "user"
        }
      }
    },
    "type": "sleep_cycle"
  }
}
```
