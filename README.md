# Project Title

### Library Management System

## Description of what your project does

This SQL script defines the schema for a Library Management System. It creates a new database and sets up all the necessary tables with appropriate fields, constraints, and relationships. Here’s a breakdown of what each part does:

🔁 Setup
Drops any existing database named library_management for a clean start.

Creates a new database library_management.

Selects the database for use.

👤 Members Table
Stores information about library members (users):

Basic personal info: name, email, phone, address.

Membership details: type (Standard, Premium, Student), status (Active, Expired, Suspended), start date, DOB.

✍️ Authors Table
Stores information about book authors:

Includes optional fields for birth/death dates, nationality, and biography.

🏢 Publishers Table
Stores information about publishing companies:

Includes contact info and website.

🏷️ Categories Table
Hierarchical classification system for books:

Can have a parent category (e.g., Fiction → Science Fiction).

Stores name and optional description.

📚 Books Table
Contains book-level metadata (not specific copies):

Title, ISBN, publication info, language, edition, description.

Linked to a Publisher.

Does not track borrowing or inventory.

🔗 BookCategories Table
A many-to-many relationship between Books and Categories:

Allows a book to belong to multiple genres/categories.

✍️ BookAuthors Table
A many-to-many relationship between Books and Authors:

Includes an optional role (e.g., Editor, Translator).

🧾 BookCopies Table
Represents physical copies of a book:

Tracks barcode, acquisition date, price, status (Available, Lost, etc.), condition, and location.

Linked to a book.

📥 Loans Table
Tracks borrowing activity:

Links a BookCopy to a Member.

Records checkout, due, and return dates.

Includes fine amount, number of renewals, and staff involved.

📅 Reservations Table
Tracks member reservations for books:

Stores reservation and expiration dates.

Tracks status (Pending, Fulfilled, etc.) and notification flag.

🧑‍💼 Staff Table
Stores library employee data:

Includes login credentials, position, and admin privileges.

💸 Fines Table
Tracks fines issued due to late returns, damage, etc.:

Linked to Loans and optionally Staff.

Includes payment method, reason, and payment date.

🎟️ Events Table
Manages library-hosted events (workshops, readings, etc.):

Includes title, description, time, location, max attendees.

Linked to organizing staff.

👥 EventAttendees Table
Many-to-many relationship between Events and Members:

Tracks which members signed up for which events.

Tracks attendance and registration time.

✅ Key Features of the Design
Normalized structure: Avoids redundancy and enforces data integrity.

Foreign keys with cascading behavior: Automatically updates/deletes related records where appropriate.

Use of ENUMs: Provides controlled vocabulary for fields like status, roles, etc.

Many-to-many junction tables: For flexible relationships like authorship, categorization, and event participation.

In summary, this script provides a comprehensive, well-structured relational schema for a fully-featured library management system, covering users, books, inventory, borrowing, staff, events, and fines.

## How to run/setup the project (or import SQL)

Steps:
Open MySQL Workbench

Create a new connection if needed and connect to your server

Go to File → Open SQL Script

Load the library_management.sql file

Click the lightning bolt icon (⚡) to execute the script

## Screenshot or link to your ERD
