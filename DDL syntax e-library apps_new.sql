CREATE TABLE Users (
    User_id SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Username VARCHAR(100) UNIQUE NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone_number VARCHAR(25)
);

CREATE TABLE Libraries (
    Library_id SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Address VARCHAR(255) NOT NULL
);

CREATE TABLE Books (
    Book_id SERIAL PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Author VARCHAR(100) NOT NULL,
    ISBN VARCHAR(25) UNIQUE NOT NULL
);

CREATE TABLE Book_availability (
    Availability_id SERIAL PRIMARY KEY,
    Book_id INT NOT NULL,
    Library_id INT NOT NULL,
    Quantity_owned INT NOT NULL CHECK (Quantity_owned >= 0),
    FOREIGN KEY (Book_id) REFERENCES Books(Book_id),
    FOREIGN KEY (Library_id) REFERENCES Libraries(Library_id)
);


CREATE TABLE Borrow (
    Borrow_id SERIAL PRIMARY KEY,
    User_id INT NOT NULL,
    Book_id INT NOT NULL,
    Library_id INT NOT NULL,
    Borrow_date DATE NOT NULL,
    Due_date DATE NOT NULL,
    FOREIGN KEY (User_id) REFERENCES Users(User_id),
    FOREIGN KEY (Book_id) REFERENCES Books(Book_id),
    FOREIGN KEY (Library_id) REFERENCES Libraries(Library_id)
);

CREATE TABLE Return (
    Return_id SERIAL PRIMARY KEY,
    Borrow_id INT NOT NULL,
    Return_date DATE NOT NULL,
    FOREIGN KEY (Borrow_id) REFERENCES Borrow(Borrow_id)
);

CREATE TABLE Hold (
    Hold_id SERIAL PRIMARY KEY,
    User_id INT NOT NULL,
    Book_id INT NOT NULL,
    Library_id INT NOT NULL,
    Hold_date DATE NOT NULL,
    FOREIGN KEY (User_id) REFERENCES Users(User_id),
    FOREIGN KEY (Book_id) REFERENCES Books(Book_id),
    FOREIGN KEY (Library_id) REFERENCES Libraries(Library_id)
);
