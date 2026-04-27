## ADDED Requirements

### Requirement: Database initialization
The system SHALL initialize a SQLite database when the application starts, stored in the application's default database directory with the filename `imh.db`.

#### Scenario: First launch database creation
- **WHEN** the application launches for the first time
- **THEN** the system creates the database file at the default path
- **AND** the system executes the onCreate callback to create initial tables
- **AND** the database version is set to 1

### Requirement: Database version management
The system SHALL support database versioning and migration through onUpgrade callback.

#### Scenario: Database version upgrade
- **WHEN** the existing database version is lower than the required version
- **THEN** the system calls the onUpgrade callback with old and new version numbers
- **AND** the system executes migration scripts to update the schema

### Requirement: Single database instance
The system SHALL use a singleton pattern to ensure only one database instance exists throughout the application lifecycle.

#### Scenario: Multiple database access requests
- **WHEN** multiple components request database access simultaneously
- **THEN** the system returns the same database instance
- **AND** the system maintains connection integrity

### Requirement: Database connection closure
The system SHALL provide a method to properly close the database connection when needed.

#### Scenario: Application termination
- **WHEN** the application is terminating
- **THEN** the system closes the database connection properly
- **AND** all pending transactions are completed
