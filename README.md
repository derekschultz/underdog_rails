## Overview

To get a base level understanding of how you approach real life problems, we’d like you to complete this small code challenge. We don’t want to waste your time, so while we’re interested in how you can tackle this creatively, we don’t want you to use more than 3 or 4 hours. We’re interested in how you structure your code for organization and extensibility purposes as well clarity.

## Step 1

Import and persist the players from the following CBS API for baseball, football, and basketball. This should be build in a way where data can be periodically imported and update existing records in the database

[http://api.cbssports.com/fantasy/players/list?version=3.0&SPORT=baseball&response_format=JSON](http://api.cbssports.com/fantasy/players/list?version=3.0&SPORT=baseball&response_format=JSON)

## Step 2

Create a JSON API endpoint for a player. Like seen below:

```json
{
  "id": "123",
  "name_brief": "P. Mahomes",
  "first_name": "Patrick",
  "last_name": "Mahomes",
  "position": "QB",
  "age": "26",
  "average_position_age_diff": "1"
}
```

---

Each element in the JSON should be self explanatory except for the following two:

- `name_brief`
  - For football players it should be the first initial and their last name like “P. Manning”.
  - For basketball players it should be first name plus last initial like “Kobe B.”.
  - For baseball players it should just be the first initial and the last initial like “G. S.”.
- `average_position_age_diff`
  - This value should be the difference between the age of the player vs the average age for the player’s position.

## Step 3

Create a basic search JSON API endpoint that will return player data shown in Step 2 for all players found based on any combination of the following parameters:

- Sport
- First letter of last name
- A specific age (ex. 25)
- A range of ages (ex. 25 - 30)
- The player’s position (ex: “QB”)

## Setup Instructions

Install required dependencies:

`bundle install`

Run database migrations:

`rails db:migrate`

Import the player data from the CBS API:

`rake import:players`

## Endpoints

`localhost:3000/players/:id`

`localhost:3000/search` (params: `sport`, `position`, `age`, `min_age`, `max_age`, `initial`)
