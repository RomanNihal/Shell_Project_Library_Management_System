# Library Management System - Shell Project

This repository contains the **Library Management System** project implemented using **Shell scripting**, developed as part of my **Operating System course**. The project allows users to manage books in a library, including adding, removing, searching, and viewing available books, all through a command-line interface. This shell project emphasizes efficient file handling, simple user interface, and CRUD operations on book data.

## Features

### 1. **Book Management**:
- **Add New Book**:  
  Users can add new books to the library with details such as title, author, ISBN, and availability.
  
- **Remove Book**:  
  Users can delete books from the catalog based on ISBN or book title.

- **View Available Books**:  
  Displays a list of all books currently available in the library system, including their details.

### 2. **Search Functionality**:
- **Search by Title**:  
  Users can search for books by title.
  
- **Search by Author**:  
  Search for books based on the author's name.

### 3. **Interactive Command-Line Interface**:
- The system provides a text-based interface, where users can choose actions through numeric options.
  
- Clear prompts guide the user through tasks like adding a book, searching for a book, or viewing the book catalog.

### 4. **Persistent Storage**:
- Book details are stored in text files, allowing data to persist across sessions.
  
- File handling ensures that each operation (add, delete, search) modifies the library catalog file accordingly.

### 5. **Simple and Intuitive**:
- Easy-to-follow command-line navigation ensures the system is simple to use, even for users without technical experience.
  
- Prompts are clear, and the workflow is linear, making the system accessible and user-friendly.

## Technologies Used

- **Shell Scripting** (Bash)
- **File Handling**: Read and write operations on text files to store and manage book data
- **Basic Input/Output**: Text-based user interface using `echo`, `read`, and conditional statements.
