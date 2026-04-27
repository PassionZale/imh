## ADDED Requirements

### Requirement: Avatar storage directory
The system SHALL store avatar images in an `avatars` subdirectory within the application's documents directory.

#### Scenario: Directory creation
- **WHEN** the first avatar is saved
- **THEN** the system creates the avatars directory if it does not exist
- **AND** the directory is located at `{applicationDocumentsDirectory}/avatars`

### Requirement: Avatar file naming
The system SHALL generate unique filenames for stored avatar images using the format `{userId}_{timestamp}.jpg` or `{timestamp}.jpg` when userId is not available.

#### Scenario: Filename generation with userId
- **WHEN** an avatar is saved for a user with an existing ID
- **THEN** the filename uses the format `{userId}_{timestamp}.jpg`
- **AND** the timestamp represents milliseconds since epoch

#### Scenario: Filename generation without userId
- **WHEN** an avatar is saved before a user ID is assigned
- **THEN** the filename uses the format `{timestamp}.jpg`
- **AND** the timestamp represents milliseconds since epoch

### Requirement: Supported image formats
The system SHALL accept jpg, jpeg, png, and gif image formats for avatar uploads.

#### Scenario: Upload JPEG image
- **WHEN** a user selects a .jpg or .jpeg image
- **THEN** the system accepts and saves the image

#### Scenario: Upload PNG image
- **WHEN** a user selects a .png image
- **THEN** the system accepts and saves the image

#### Scenario: Upload GIF image
- **WHEN** a user selects a .gif image
- **THEN** the system accepts and saves the image

### Requirement: Image source selection
The system SHALL allow users to select avatar images from the device's gallery or camera.

#### Scenario: Select from gallery
- **WHEN** the user chooses to select an image from the gallery
- **THEN** the system opens the image picker with gallery source
- **AND** the system returns the selected image file

#### Scenario: Capture from camera
- **WHEN** the user chooses to capture a new photo
- **THEN** the system opens the camera interface
- **AND** the system returns the captured image file

### Requirement: Save avatar to local storage
The system SHALL save selected avatar images to the application's internal storage and return the absolute file path.

#### Scenario: Save avatar successfully
- **WHEN** a valid image file is provided to the saveAvatar method
- **THEN** the system copies the file to the avatars directory
- **AND** the system returns the absolute path of the saved file
- **AND** the image is stored in its original format (no compression)

### Requirement: Delete avatar file
The system SHALL provide a method to delete avatar files from local storage.

#### Scenario: Delete existing avatar
- **WHEN** a valid avatar file path is provided to the deleteAvatar method
- **THEN** the system deletes the file from the avatars directory
- **AND** the system confirms deletion was successful

#### Scenario: Delete non-existent avatar
- **WHEN** a non-existent file path is provided
- **THEN** the system handles the error gracefully
- **AND** the system does not throw an exception

#### Scenario: Delete null or empty path
- **WHEN** null or empty string is provided to deleteAvatar
- **THEN** the system returns without action

### Requirement: Update avatar (replace)
The system SHALL provide a method to replace an existing avatar with a new image.

#### Scenario: Update with new image
- **WHEN** a new image and an old avatar path are provided
- **THEN** the system saves the new image to storage
- **AND** the system does NOT delete the old avatar file (simplified logic)
- **AND** the system returns the new avatar file path

### Requirement: Default avatar
The system SHALL display a default avatar image when a user has no avatar set.

#### Scenario: Display default avatar
- **WHEN** a user's avatar field is null or empty
- **THEN** the system displays the default avatar from assets/images/default_avatar.jpeg

### Requirement: Avatar path storage
The system SHALL store the absolute file path of the avatar image in the database's avatar field.

#### Scenario: Store avatar path
- **WHEN** an avatar is saved successfully
- **THEN** the absolute file path is stored in the users table's avatar column
- **AND** the path can be used to load the image directly
