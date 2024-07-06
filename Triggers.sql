--1. Function to Check Book Quantity and Update Hold Table:
--This function will check the book availability and, if unavailable, update the hold table accordingly.
--Trigger to Execute the Function Before Borrow Insert
--This trigger will execute the function before any new borrow record is inserted.

CREATE OR REPLACE FUNCTION check_and_update_hold() RETURNS TRIGGER AS $$
BEGIN
    -- Check if the book is available (Quantity_owned > 0)
    IF NOT EXISTS (
        SELECT 1 FROM Book_availability
        WHERE Book_id = NEW.Book_id
        AND Library_id = NEW.Library_id
        AND Quantity_owned > 0
    ) THEN
        -- If not available, insert a hold record for the user with the intended borrow date as the hold date
        INSERT INTO Hold (User_id, Book_id, Library_id, Hold_date)
        VALUES (NEW.User_id, NEW.Book_id, NEW.Library_id, NEW.Borrow_date);

        -- Prevent the borrow from proceeding
        RETURN NULL;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_and_update_hold
BEFORE INSERT ON Borrow
FOR EACH ROW
EXECUTE FUNCTION check_and_update_hold();


--2. Function to check user's current active borrows
CREATE OR REPLACE FUNCTION check_user_borrow_limit() RETURNS TRIGGER AS $$
DECLARE
    active_borrows_count INTEGER;
BEGIN
    -- Count active borrows for the user
    SELECT COUNT(*)
    INTO active_borrows_count
    FROM Borrow b
    WHERE b.User_id = NEW.User_id
      AND b.Borrow_id IN (
          SELECT Borrow_id
          FROM Return
          WHERE User_id = NEW.User_id
            AND Return_date IS NULL
      );
     
    -- Check if the user exceeds the borrow limit
    IF active_borrows_count >= 2 THEN
        RAISE EXCEPTION 'User cannot borrow more than 2 books simultaneously';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to enforce user borrow limit on Borrow table
CREATE TRIGGER enforce_user_borrow_limit
BEFORE INSERT OR UPDATE ON Borrow
FOR EACH ROW
EXECUTE FUNCTION check_user_borrow_limit();

--3. Function validate_return_date() and Trigger trg_validate_return_date:
-- Ensure that the function checks and adjusts the return date correctly.

CREATE OR REPLACE FUNCTION validate_return_date() RETURNS TRIGGER AS $$
BEGIN
    -- Ensure Return_date is after Borrow_date
    IF NEW.Return_date < (SELECT Borrow_date FROM Borrow WHERE Borrow_id = NEW.Borrow_id) THEN
        RAISE EXCEPTION 'Return date cannot be before borrow date';
    END IF;

    -- Ensure Return_date does not exceed Due_date, adjust if needed
    NEW.Return_date := LEAST(NEW.Return_date, 
                             COALESCE((SELECT Due_date FROM Borrow WHERE Borrow_id = NEW.Borrow_id), NEW.Return_date));

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validate_return_date
BEFORE INSERT OR UPDATE ON Return
FOR EACH ROW
EXECUTE FUNCTION validate_return_date();
