# "Good Night" API Documentation

**HTTP 4xx, 5xx Example Response**

```
{
  "message": "Error message"
}
```

**Pagination Parameters and Response**

Parameters:

`page[size]={record per page}`

`page[number]={page number}`


Response:

`meta.total` Returns total records count
`meta.pages` Returns total pages available

`links.self` Returns current URL
`links.prev` Returns URL to access previous page
`links.next` Returns URL to access next page
`links.first` Returns URL to access first page
`links.last` Returns URL for last page

_Notes:_

- `links.next` and `links.last` will not be returned if current page is the last

- `links.prev` and `links.first` will not be returned if current page is the first page

- Only return `links.self` if the data returned is the only page (`meta.pages=1`)

## GET /api/user/sleep_cycles?page%5Bsize%5D=2

_Returns all current user's sleep cycles log, including completed and active cycles, ordered by creation time from latest to oldest._

**cURL Example Request**

```
curl --header "Authorization: Bearer {token}" --header "Accept: application/json" -X GET "http://localhost:3000/api/sleep_cycles?page%5Bsize%5D=2"
```

**HTTP 200 Example Response**

```
{
	"data": [
		{
			"id": "4",
			"type": "sleep_cycle",
			"attributes": {
				"set_wake_up_time": "2023-04-17T07:13:48.000Z",
				"actual_wake_up_time": "2023-04-17T11:13:48.000Z",
				"duration_seconds": 11100,
				"status": "inactive",
				"created_at": "2023-04-17T08:08:47.977Z"
			},
			"relationships": {
				"user": {
					"data": {
						"id": "1",
						"type": "user"
					}
				}
			}
		},
		{
			"id": "3",
			"type": "sleep_cycle",
			"attributes": {
				"set_wake_up_time": "2023-04-17T07:13:48.000Z",
				"actual_wake_up_time": "2023-04-17T11:13:48.000Z",
				"duration_seconds": 13861,
				"status": "inactive",
				"created_at": "2023-04-17T07:22:46.686Z"
			},
			"relationships": {
				"user": {
					"data": {
						"id": "1",
						"type": "user"
					}
				}
			}
		}
	],
	"meta": {
		"total": 3,
		"pages": 2
	},
	"links": {
		"self": "http://localhost:3000/api/user/sleep_cycles?page[size]=2",
		"next": "http://localhost:3000/api/user/sleep_cycles?page[number]=2&page[size]=2",
		"last": "http://localhost:3000/api/user/sleep_cycles?page[number]=2&page[size]=2"
	}
}
```

## GET /api/user/sleep_cycles?include_followings=true&only_completed=true&order_by=duration%20desc&page%5Bsize%5D=2

_Returns completed sleep cycles of current user and it's followed users, ordered by higest duration to lower._

**cURL Example Request**

```
curl --header "Authorization: Bearer {token}" --header "Accept: application/json" -X GET "http://localhost:3000/api/sleep_cycles?include_followings=true&only_completed=true&order_by=duration%20desc&page%5Bsize%5D=2"
```

**HTTP 200 Example Response**

```
{
	"data": [
		{
			"id": "3",
			"type": "sleep_cycle",
			"attributes": {
				"set_wake_up_time": "2023-04-17T07:13:48.000Z",
				"actual_wake_up_time": "2023-04-17T11:13:48.000Z",
				"duration_seconds": 13861,
				"status": "inactive",
				"created_at": "2023-04-17T07:22:46.686Z"
			},
			"relationships": {
				"user": {
					"data": {
						"id": "1",
						"type": "user"
					}
				}
			}
		},
		{
			"id": "4",
			"type": "sleep_cycle",
			"attributes": {
				"set_wake_up_time": "2023-04-17T07:13:48.000Z",
				"actual_wake_up_time": "2023-04-17T11:13:48.000Z",
				"duration_seconds": 11100,
				"status": "inactive",
				"created_at": "2023-04-17T08:08:47.977Z"
			},
			"relationships": {
				"user": {
					"data": {
						"id": "1",
						"type": "user"
					}
				}
			}
		}
	],
	"meta": {
		"total": 5,
		"pages": 3
	},
	"links": {
		"self": "http://localhost:3000/api/user/sleep_cycles?include_followings=true&only_completed=true&order_by=duration desc&page[size]=2",
		"next": "http://localhost:3000/api/user/sleep_cycles?include_followings=true&only_completed=true&order_by=duration desc&page[number]=2&page[size]=2",
		"last": "http://localhost:3000/api/user/sleep_cycles?include_followings=true&only_completed=true&order_by=duration desc&page[number]=3&page[size]=2"
	}
}
```

## GET /api/user/sleep_cycles?include_followings=true&only_completed=true&order_by=duration%20desc&since=2023-04-07T13:05:39.000Z&page%5Bsize%5D=2

_Returns completed sleep cycles of current user and it's followed users done in past week, ordered by higest duration to lower._

**cURL Example Request**

```
curl --header "Authorization: Bearer {token}" --header "Accept: application/json" -X GET "http://localhost:3000/api/sleep_cycles?include_followings=true&only_completed=true&order_by=duration%20desc&since=2023-04-07T13:05:39.000Z&page%5Bsize%5D=2"
```

**HTTP 200 Example Response**

```
{
	"data": [
		{
			"id": "3",
			"type": "sleep_cycle",
			"attributes": {
				"set_wake_up_time": "2023-04-17T07:13:48.000Z",
				"actual_wake_up_time": "2023-04-17T11:13:48.000Z",
				"duration_seconds": 13861,
				"status": "inactive",
				"created_at": "2023-04-17T07:22:46.686Z"
			},
			"relationships": {
				"user": {
					"data": {
						"id": "1",
						"type": "user"
					}
				}
			}
		},
		{
			"id": "4",
			"type": "sleep_cycle",
			"attributes": {
				"set_wake_up_time": "2023-04-17T07:13:48.000Z",
				"actual_wake_up_time": "2023-04-17T11:13:48.000Z",
				"duration_seconds": 11100,
				"status": "inactive",
				"created_at": "2023-04-17T08:08:47.977Z"
			},
			"relationships": {
				"user": {
					"data": {
						"id": "1",
						"type": "user"
					}
				}
			}
		}
	],
	"meta": {
		"total": 5,
		"pages": 3
	},
	"links": {
		"self": "http://localhost:3000/api/user/sleep_cycles?include_followings=true&only_completed=true&order_by=duration desc&page[size]=2",
		"next": "http://localhost:3000/api/user/sleep_cycles?include_followings=true&only_completed=true&order_by=duration desc&page[number]=2&page[size]=2",
		"last": "http://localhost:3000/api/user/sleep_cycles?include_followings=true&only_completed=true&order_by=duration desc&page[number]=3&page[size]=2"
	}
}
```

## GET /api/users/{user_id}/sleep_cycles?only_completed=true&order_by=duration%20desc&page%5Bsize%5D=2

_Returns completed sleep cycles of a followed user, ordered by higest duration to lower._

**cURL Example Request**

```
curl --header "Authorization: Bearer {token}" --header "Accept: application/json" -X GET "http://localhost:3000/api/users/2/sleep_cycles?only_completed=true&order_by=duration%20desc&page%5Bsize%5D=2"
```

**HTTP 200 Example Response**

```
{
	"data": [
		{
			"id": "6",
			"type": "sleep_cycle",
			"attributes": {
				"set_wake_up_time": "2023-04-17T07:13:48.000Z",
				"actual_wake_up_time": "2023-04-17T11:13:48.000Z",
				"duration_seconds": -330896,
				"status": "inactive",
				"created_at": "2023-04-21T07:08:44.844Z"
			},
			"relationships": {
				"user": {
					"data": {
						"id": "2",
						"type": "user"
					}
				}
			}
		},
		{
			"id": "5",
			"type": "sleep_cycle",
			"attributes": {
				"set_wake_up_time": "2023-04-17T07:13:48.000Z",
				"actual_wake_up_time": "2023-04-17T11:13:48.000Z",
				"duration_seconds": 11003,
				"status": "inactive",
				"created_at": "2023-04-17T08:10:24.264Z"
			},
			"relationships": {
				"user": {
					"data": {
						"id": "2",
						"type": "user"
					}
				}
			}
		}
	],
	"meta": {
		"total": 2,
		"pages": 1
	},
	"links": {
		"self": "http://localhost:3000/api/users/2/sleep_cycles?page[size]=2"
	}
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
      "duration_seconds": null,
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

## PUT /api/user/sleep_cycles

_Set actual wake up time to latest active sleep cycle and calculate sleep duration._

** cURL Request Example**

```
curl --header "Authorization: Bearer {token}" --header "Accept: application/json" --header "Content-Type: application/json" --data "{sleep_cycle:{actual_wake_up_time:\"2023-04-23T14:52:27.000Z\"}}" -X PUT "http://localhost:3000/api/user/sleep_cycles"
```

** HTTP 200 Response Example**

```
{
  "data": {
    "attributes": {
      "actual_wake_up_time": "2023-04-15T14:52:27.000Z",
      "created_at": "2023-04-15T06:52:27.074Z",
      "duration_seconds": 218000,
      "set_wake_up_time": "2023-04-15T14:52:27.000Z",
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
  }
}
```

## GET /api/users?page%5Bsize%5D=2

_Returns users except current user._

**cURL Example Request**

```
curl --header "Authorization: Bearer {token}" --header "Accept: application/json" -X GET "http://localhost:3000/api/users?page%5Bsize%5D=2"
```

**HTTP 200 Example Response**

```
{
	"data": [
		{
			"id": "2",
			"type": "user",
			"attributes": {
				"name": "Jerry",
				"is_following": true,
				"is_followed": true
			}
		},
		{
			"id": "3",
			"type": "user",
			"attributes": {
				"name": "Bella",
				"is_following": false,
				"is_followed": false
			}
		}
	],
	"meta": {
		"total": 2,
		"pages": 1
	},
	"links": {
		"self": "http://localhost:3000/api/users?page[size]=2"
	}
}
```

## POST /api/users/{user_id}/follow

_Follow specific user_

**cURL Request Example**

```
curl --header "Authorization: Bearer {token}" --header "Accept: application/json" -X POST "http://localhost:3000/api/users/2/follow"
```

**HTTP 200 Response Example**

```
{
  "data": {
    "attributes": {
      "created_at": "2023-04-15T10:39:19.217Z",
      "status": "approved",
      "updated_at": "2023-04-15T10:39:19.224Z"
    },
    "id": "1",
    "relationships": {
      "followed": {
        "data": {
          "id": "2",
          "type": "user"
        }
      },
      "follower": {
        "data": {
          "id": "1",
          "type": "user"
        }
      }
    },
    "type": "following"
  }
}
```

## DELETE /api/users/{user_id}/unfollow

_Unfollow followed user_

**cURL Request Example**

```
curl --header "Authorization: Bearer {token}" --header "Accept: application/json" -X DELETE "http://localhost:3000/api/users/2/unfollow"
```

**HTTP 204 Response**

_no content_

## GET /api/user/followers?page%5Bsize%5D=2

_Returns current user's followers._

**cURL Example Request**

```
curl --header "Authorization: Bearer {token}" --header "Accept: application/json" -X GET "http://localhost:3000/api/user/followers?page%5Bsize%5D=2"
```

**HTTP 200 Example Response**

```
{
	"data": [
		{
			"id": "2",
			"type": "user",
			"attributes": {
				"name": "Jerry",
				"is_followed": true
			}
		}
	],
	"meta": {
		"total": 1,
		"pages": 1
	},
	"links": {
		"self": "http://localhost:3000/api/user/followers?page[size]=2"
	}
}
```

## GET /api/user/followings?page%5Bsize%5D=2

_Returns current user's followed users._

**cURL Example Request**

```
curl --header "Authorization: Bearer {token}" --header "Accept: application/json" -X GET "http://localhost:3000/api/user/followings?page%5Bsize%5D=2"
```

**HTTP 200 Example Response**

```
{
	"data": [
		{
			"id": "2",
			"type": "user",
			"attributes": {
				"name": "Jerry"
			}
		}
	],
	"meta": {
		"total": 1,
		"pages": 1
	},
	"links": {
		"self": "http://localhost:3000/api/user/followings?page[size]=2"
	}
}
```
