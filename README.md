# README

# Device Registry
This is a Ruby on Rails application for managing device assignments between users. It allows users to assign devices to themselves, and return them.
 
### Features 

- User can assign the device only to themself.
- User can't assign the device already assigned to another user.
- Only the user who assigned the device can return it.
- If the user returned the device in the past, they can't ever re-assign the same device to themself.

### Prerequisites
- Ruby 3.2.3
- Rails 7.1
- Sqlite3 1.4

## Running the app

1. Clone this repository
```bash
git clone https://github.com/dominik-sek/device_registry.git
cd device_registry
```
2. Install the dependencies
```
bundle install
```
>
> This project requires **Ruby 3.2.3**.
>
>If you're using a version manager like `rbenv`, this should be automatically detected via the `.ruby-version` file.
>
>You can also run the following commands inside the project folder to ensure the correct Ruby version:
>```bash
>rbenv install 3.2.3
>rbenv local 3.2.3
>```
3. Set up the test database
```bash
rake db:test:prepare 
```
4. Run the test suites using:
```bash
rspec spec
```
or for nice formatting:
```bash
rspec spec --format documentation 
```
## Database
The application uses sqlite3 as its database

### Schema

#### Users
- `id`: integer (primary key)
- `created_at`: datetime
- `updated_at`: datetime

#### Devices
- `id`: integer (primary key)
- `serial_number`: string (unique)
- `created_at`: datetime
- `updated_at`: datetime

#### DeviceAssignments
- `id`: integer (primary key)
- `user_id`: integer (foreign key)
- `device_id`: integer (foreign key)
- `assigned_at`: datetime
- `returned_at`: datetime
- `created_at`: datetime
- `updated_at`: datetime

#### ApiKeys
- `id`: integer (primary key)
- `bearer_id`: integer (foreign key)
- `bearer_type`: string
- `token`: string (unique)
- `created_at`: datetime
- `updated_at`: datetime

### Relationships
- User has many devices through device_assignments
- User has many device_assignments
- Device has many users through device_assignments
- Device has many device_assignments
- User has many api_keys

## Error handling
This application uses an error handling service that provides consistent error responses with custom messages:
```json
{
  "error": "Error message"
}
```
## Tests

The test suite covers:
- Controller tests:
  - `devices_controller`
- Service tests:
  - `assign_device_to_user`
  - `return_device_from_user`
  - `error_handler`

## Authentication
The application uses API key authentication. Each request must include a valid API key in the session token.

## API routes
```http
POST /api/assign
{
  "new_owner_id": 1,
  device: {
    "serial_number":1234567
  }
}
```

```http
POST /api/unassign
{
  "from_user": 1,
  device: {
    "serial_number":1234567
  }
}
```

--- 
# Task requirements
Your task is to implement the part of the application that helps track devices assigned to users within an organization.

For now, we have two ActiveRecord models: User and Device.
User can have many devices; the device should be active only for one assigned user.
There are 2 actions a User can take with the Device: assign the device to User or return the Device.

Here are the product requirements:
- User can assign the device only to themself. 
- User can't assign the device already assigned to another user.
- Only the user who assigned the device can return it. 
- If the user returned the device in the past, they can't ever re-assign the same device to themself.


TODO:
 - Clone this repo to your local machine - DON'T FORK IT.
 - Fix the config, so you can run the test suite properly.
 - Implement the code to make the tests pass for `AssignDeviceToUser` service.
 - Following the product requirements listed above, implement tests for returning the device and then implement the code to make them pass.
 - In case you are missing additional product requirements, use your best judgment. Have fun with it.
 - Refactor at will. Do you see something you don't like? Change it. It's your code. Remember to satisfy the outlined product requirements though.
 - Remember to document your progress using granular commits and meaningful commit messages.
 - Publish your code as a public repo using your Github account.
