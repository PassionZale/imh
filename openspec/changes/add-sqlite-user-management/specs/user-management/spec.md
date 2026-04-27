## ADDED Requirements

### Requirement: User model structure
The system SHALL define a User model with the following properties: id (integer, auto-generated), name (text, required), nickname (text, required), avatar (text, optional), created_at (integer timestamp, required), updated_at (integer timestamp, required).

#### Scenario: User object creation
- **WHEN** a new User object is instantiated
- **THEN** the system accepts name and nickname as required parameters
- **AND** the system accepts avatar as an optional parameter
- **AND** the system automatically generates created_at and updated_at timestamps

### Requirement: Create user
The system SHALL provide a method to create a new user in the database.

#### Scenario: Successful user creation
- **WHEN** a valid User object is provided to the create method
- **THEN** the system inserts the user record into the users table
- **AND** the system returns the User object with the generated id
- **AND** the updated_at timestamp is set to the current time

#### Scenario: Create user with avatar
- **WHEN** a User object with an avatar path is created
- **THEN** the system stores the avatar path in the database
- **AND** the avatar path can be retrieved later

#### Scenario: Create user without avatar
- **WHEN** a User object without an avatar is created
- **THEN** the system stores NULL for the avatar field
- **AND** the user can still be created and retrieved

### Requirement: Get user by ID
The system SHALL provide a method to retrieve a user by their ID.

#### Scenario: Existing user retrieval
- **WHEN** a valid user ID is provided to the getById method
- **THEN** the system returns the corresponding User object
- **AND** all user properties including optional avatar are populated

#### Scenario: Non-existent user retrieval
- **WHEN** a non-existent user ID is provided
- **THEN** the system returns null

### Requirement: Get all users
The system SHALL provide a method to retrieve all users from the database.

#### Scenario: Retrieve all users
- **WHEN** the getAll method is called
- **THEN** the system returns a list of all User objects
- **AND** the list is ordered by id in descending order (most recent first)

#### Scenario: Empty database
- **WHEN** the getAll method is called on an empty database
- **THEN** the system returns an empty list

### Requirement: Update user
The system SHALL provide a method to update an existing user's information.

#### Scenario: Successful user update
- **WHEN** a User object with a valid id is provided to the update method
- **THEN** the system updates the corresponding database record
- **AND** the updated_at timestamp is automatically updated to current time
- **AND** the system confirms the update was successful

#### Scenario: Update non-existent user
- **WHEN** a User object with a non-existent id is provided
- **THEN** the system returns an error or zero rows affected

### Requirement: Delete user
The system SHALL provide a method to delete a user by their ID.

#### Scenario: Successful user deletion
- **WHEN** a valid user ID is provided to the delete method
- **THEN** the system removes the user record from the database
- **AND** the system confirms the deletion was successful

#### Scenario: Delete user with avatar
- **WHEN** a user with an avatar is deleted
- **THEN** the system removes the user record from the database
- **AND** the avatar file is NOT deleted (simplified logic)

#### Scenario: Delete non-existent user
- **WHEN** a non-existent user ID is provided
- **THEN** the system returns zero rows affected
