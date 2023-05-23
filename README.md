# Brine assignment 

This app uses Rails 6 with PostgreSQL and it is also containerized using docker.

## Requirements
- Create a rest API endpoint for the user’s to create an alert `alerts/create/` -> `COMPLETED`
- Create a rest API endpoint for the user’s to delete an alert `alerts/delete/` -> `COMPLETED`
- Create a rest API endpoint to fetch all the alerts that the user has created. -> `COMPLETED` 
     - The response should also include the status of the alerts
  (created/deleted/triggered/.. or any other status you feel needs to be included)
    - Paginate the response.
- Include filter options based on the status of the alerts. Eg: if the user wanted
  only the alerts that were triggered, then the endpoint should provide just that)
- When the price of the coin reaches the price specified by the users, send an email to
  the user that set the alert at that price. (send mail using Gmail SMTP, SendGrid, etc)
  If this is taking too much time, just print the output to the console. `COMPLETED`
  
**NOTE:** [You might have to add your own SMTP creds for sending the email. The functionality is built and exists]()

## Steps to Run the application

Please ensure you are using `Docker Compose V2`. This project relies on the `docker compose` command

## Initial setup
```
cp .env.example .env
docker compose build
docker compose run --rm web bin/rails db:setup
```

## Running the Rails app
```
docker compose up
```
This command will start the application and run redis, sidekiq, db and rails server.

## To attach to a particular container 
```
docker compose ps 
docker attach `id`
```
This command will attach the required container. [Used for debugging]


## Running the Rails console
When no container running yet, start up a new one:
```
docker compose run --rm web bin/rails c
```
## EndPoints
- Create Endpoint - [POST] `http://localhost:3000/api/v1/alerts`
- Create Endpoint - [POST] `http://localhost:3000/api/v1/alerts`
- Create Endpoint - [POST] `http://localhost:3000/api/v1/alerts`



# API endpoints
## POST
`Create a new alert` [/api/v1/alerts]() <br/>

Creates a new alert for a particular user for crypto id and sets a target price for the alert

**Parameters**

|          Name | Required |  Type   | Description                                                                                                                                                           |
| -------------:|:--------:|:-------:| --------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|     `user_id` | required | integer  | The is the user id of the user. <br/><br/>
|     `cryptocurrency_id` | required | integer  | The is the cryptocurrency id of the crypto. <br/><br/>
|     `target_price` | required | decimal  | This the target price for the alert.

**Response**
```
// creates a new alert for a user id with target price of 400000
{
    "id": 11,
    "user_id": 1,
    "cryptocurrency_id": 1,
    "target_price": "400000.0",
    "status": "active",
    "created_at": "2023-05-23T09:50:23.580Z",
    "updated_at": "2023-05-23T09:50:23.580Z"
}

// alert already exists for the user with same price
{
    "error": "User already has an active alert for this cryptocurrency"
}
```


## DELETE
`Delete an existing alert` [api/v1/alerts/{id}]() <br/>

Soft delete an alert for a particular user.

**Parameters**

|          Name | Required |  Type   | Description                                                                                                                                                           |
| -------------:|:--------:|:-------:| --------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|     `alert_id` | required | integer  | The is the alert id to be deleted. <br/><br/>

**Response**
```
// alert deleted 
{
    "success": true,
    "message": "Alert deleted successfully"
}

// alert not found
{
    "error": "Alert not found"
}
```


## GET
`fetch all alerts of a user` [/api/v1/alerts]() <br/>
Fetched all the alerts of the user.

**Parameters**

|          Name | Required |  Type   | Description                                                                                                                                                           |
| -------------:|:--------:|:-------:| --------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|     `user_id` | required | integer  | This is the user id of the user. <br/><br/>
|     `page` | optional | integer  | current page of pagination. <br/><br/>
|     `per_page` | optional | decimal  | objects per page. <br/><br/>
|     `status` | optional | decimal  | filtering of alerts by status. <br/><br/> Supported values: `deleted` or `active` or `triggered`.

**Response**
```
// lists the alerts of the user
{
    "alert": {
        "data": [
            {
                "id": "1",
                "type": "alert",
                "attributes": {
                    "id": 1,
                    "user_id": 1,
                    "target_price": "33000.0",
                    "status": "deleted"
                }
            },
            {
                "id": "2",
                "type": "alert",
                "attributes": {
                    "id": 2,
                    "user_id": 1,
                    "target_price": "32000.0",
                    "status": "active"
                }
            },
            {
                "id": "3",
                "type": "alert",
                "attributes": {
                    "id": 3,
                    "user_id": 1,
                    "target_price": "31000.0",
                    "status": "active"
                }
            },
            {
                "id": "4",
                "type": "alert",
                "attributes": {
                    "id": 4,
                    "user_id": 1,
                    "target_price": "30000.0",
                    "status": "active"
                }
            },
            {
                "id": "5",
                "type": "alert",
                "attributes": {
                    "id": 5,
                    "user_id": 1,
                    "target_price": "34000.0",
                    "status": "active"
                }
            },
            {
                "id": "11",
                "type": "alert",
                "attributes": {
                    "id": 11,
                    "user_id": 1,
                    "target_price": "400000.0",
                    "status": "active"
                }
            }
        ],
        "meta": {
            "pagination": {
                "page": 1,
                "per_page": 10
            }
        }
    }
}

OR

// list the alerts filtered by status = deleted

{
    "alert": {
        "data": [
            {
                "id": "4",
                "type": "alert",
                "attributes": {
                    "id": 4,
                    "user_id": 1,
                    "target_price": "30000.0",
                    "status": "deleted"
                }
            },
            {
                "id": "5",
                "type": "alert",
                "attributes": {
                    "id": 5,
                    "user_id": 1,
                    "target_price": "34000.0",
                    "status": "deleted"
                }
            }
        ],
        "meta": {
            "pagination": {
                "page": 1,
                "per_page": 10,
                "total": 2
            }
        }
    }
}
```
# Sending Alerts
- **Cron Job**: A cron job is scheduled to run at regular intervals which runs every 15th minute.
  - The cron job enqueues the Sidekiq job to check the cryptocurrency price and trigger alerts.
  - The frequency of the cron job can be adjusted based on the desired level of real-time monitoring and system resources.

  
- **Sidekiq & Redis**: A Sidekiq worker[`AlertEmailWorker`] is responsible for checking the cryptocurrency price against the target price for each active alert.
  - The job periodically fetches the latest price of the cryptocurrency from the CoinGecko API.
  - It compares the fetched price with the target price of each active alert.
  - If the fetched price matches or exceeds the target price, the alert status is updated to "triggered" and an email notification is sent to the user.
  - WEB UI URL: http://localhost:3000/sidekiq/



- **CoinGecko API**: CoinGecko API is used to fetch the latest cryptocurrency prices in real-time.
  - **NOTE**: I have added the code for webhook as well, but it was not working due to api key setup. However the code will work when the key is present with minor changes and reusing the existing alerting system.
  - **NOTE**: The coin gecko api was giving rate limit error , so i have captured the response and hardcoded it as well incase it doesnt run during the testing at your end.

  
- **Email Notification**: 
  - When an alert is triggered, an email notification is sent to the user who set the alert.
  - The email contains details about the cryptocurrency, the target price, and the current price at which the alert was triggered.
  - SMTP is used to send the email notifications.
  - **NOTE:** [You might have to add your own SMTP creds for sending the email. The functionality is built and exists]()
  - **NOTE:** [I have added a console log as well incase the SMTP fails at your end during testing]() `app/mailers/alert_mailer.rb`


# Postman Collection with examples

I am attaching the postman collection with examples of the above api endpoints.

___

  








