## 1. Project Setup

- [x] 1.1 Add dependencies to pubspec.yaml (sqflite, path, path_provider, image_picker)
- [x] 1.2 Create directory structure (database, repositories, services, pages)
- [x] 1.3 Add default_avatar.jpeg to assets/images/
- [x] 1.4 Configure assets in pubspec.yaml

## 2. Database Layer

- [x] 2.1 Create DatabaseHelper class with singleton pattern
- [x] 2.2 Implement database initialization with getDatabasesPath()
- [x] 2.3 Create users table SQL schema (id, name, nickname, avatar, created_at, updated_at)
- [x] 2.4 Implement onCreate callback for table creation
- [x] 2.5 Implement onUpgrade callback for version management
- [ ] 2.6 Test database creation and connection

## 3. Model Layer

- [x] 3.1 Create User model class with properties (id, name, nickname, avatar, created_at, updated_at)
- [x] 3.2 Implement toMap() method for database serialization
- [x] 3.3 Implement fromMap() factory constructor for database deserialization
- [x] 3.4 Add timestamp generation in constructors (created_at, updated_at)

## 4. Repository Layer

- [x] 4.1 Create UserRepository class
- [x] 4.2 Implement create() method with auto-generated id
- [x] 4.3 Implement getById() method with null handling
- [x] 4.4 Implement getAll() method with descending order
- [x] 4.5 Implement update() method with auto-updated_at timestamp
- [x] 4.6 Implement delete() method
- [x] 4.7 Add error handling and logging

## 5. Image Service

- [x] 5.1 Create ImageService class
- [x] 5.2 Implement saveAvatar() method with file copy logic
- [x] 5.3 Implement avatars directory creation
- [x] 5.4 Implement unique filename generation (userId_timestamp or timestamp)
- [x] 5.5 Implement deleteAvatar() method with graceful handling
- [x] 5.6 Implement updateAvatar() method (save new, keep old)
- [ ] 5.7 Test image save and retrieve operations

## 6. UI Layer - User List

- [x] 6.1 Create UsersPage StatefulWidget
- [x] 6.2 Implement initState() with data loading
- [x] 6.3 Implement FutureBuilder for async data display
- [x] 6.4 Create ListView.builder for user list display
- [x] 6.5 Design user list item UI (avatar, name, nickname)
- [x] 6.6 Add loading indicator while data loads
- [x] 6.7 Add error handling and display

## 7. UI Layer - Add/Edit User

- [x] 7.1 Create AddEditUserDialog or page
- [x] 7.2 Implement form fields for name and nickname
- [x] 7.3 Implement avatar selection with ImagePicker
- [x] 7.4 Implement save button with validation
- [x] 7.5 Handle create vs update mode
- [x] 7.6 Integrate with UserRepository for persistence

## 8. UI Layer - Delete User

- [x] 8.1 Add delete button to user list items
- [x] 8.2 Implement confirmation dialog
- [x] 8.3 Call UserRepository.delete() on confirmation
- [x] 8.4 Refresh list after deletion

## 9. Avatar Display

- [x] 9.1 Implement Image.file() for local avatar display
- [x] 9.2 Fallback to default_avatar asset when avatar is null/empty
- [x] 9.3 Add error handling for missing avatar files
- [x] 9.4 Add circular avatar styling

## 10. Integration and Testing

- [ ] 10.1 Test complete CRUD flow (create, read, update, delete)
- [ ] 10.2 Test avatar upload and display
- [ ] 10.3 Test avatar replacement
- [ ] 10.4 Test user deletion with avatar
- [ ] 10.5 Test database persistence across app restarts
- [ ] 10.6 Verify all requirements from specs are met

## 11. Code Quality

- [x] 11.1 Run flutter analyze and fix warnings
- [x] 11.2 Format code with flutter format
- [x] 11.3 Add comments for complex logic
- [x] 11.4 Verify naming conventions are followed
