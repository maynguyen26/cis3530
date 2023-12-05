--CIS*3530 Database Systems and Concepts: Assignment 3 - Helper function for expected output
--Description: PL/pgsql function that returns the full university name determined by the placement 
--             of u in the univeristy's url given the uid
--Author: May Nguyen
--Student ID: 1051760
--Due Date: Thursday, November 30th, 2023
--Resources: https://www.postgresql.org/docs/16/plpgsql-control-structures.html
--           Tutorial of Blocks, Functions in plpgsql
--           https://www.postgresql.org/docs/16/functions-string.html

CREATE OR REPLACE FUNCTION determine_uniname(uniID NUMERIC) RETURNS VARCHAR(30)
AS 
$$
DECLARE
    uniName VARCHAR(30);
    prefix VARCHAR(15);
    suffix VARCHAR(15);
BEGIN
    IF (SELECT SUBSTRING(TRIM('/' FROM TRIM('https://www.' FROM URL)) FROM 1 FOR 1)
        FROM University 
        WHERE UID = uniID) = 'u' 
    THEN
        prefix = 'University of';
    ELSE
        suffix = 'University';
    END IF;

    IF prefix IS NOT NULL THEN
        uniName = prefix || ' ' ||
             (SELECT INITCAP(NAME)
              FROM University 
              WHERE UID = uniID);
    ELSE
        uniName = (SELECT INITCAP(NAME)
              FROM University 
              WHERE UID = uniID) || ' ' ||
              suffix;
    END IF;
    RETURN uniName;
END;
$$
LANGUAGE 'plpgsql';

-- Limitations/Assumptions: 
-- *    University name can be determined by the placement of the u in the url
