-- Copy data from CSV files into PostgreSQL tables
COPY Users FROM 'D:\Pacmann\03 Fundamental SQL Relational Database Design\Exercise\Week 8\dummy data\users.csv' DELIMITER ',' CSV HEADER;
COPY Libraries FROM 'D:\Pacmann\03 Fundamental SQL Relational Database Design\Exercise\Week 8\dummy data\libraries.csv' DELIMITER ',' CSV HEADER;
COPY Books FROM 'D:\Pacmann\03 Fundamental SQL Relational Database Design\Exercise\Week 8\dummy data\books.csv' DELIMITER ',' CSV HEADER;
COPY Book_availability FROM 'D:\Pacmann\03 Fundamental SQL Relational Database Design\Exercise\Week 8\dummy data\book_availability.csv' DELIMITER ',' CSV HEADER;
COPY Borrow FROM 'D:\Pacmann\03 Fundamental SQL Relational Database Design\Exercise\Week 8\dummy data\borrows.csv' DELIMITER ',' CSV HEADER;
COPY Return FROM 'D:\Pacmann\03 Fundamental SQL Relational Database Design\Exercise\Week 8\dummy data\returns.csv' DELIMITER ',' CSV HEADER;