--CIS*3530 Database Systems and Concepts: Assignment 3, Question 2 - Part E
--Description: Trigger called ensure_case for table Agents that change the 
--             letters in first and last names of agents to uppercase before 
--             the data is actually inserted or updated in the table
--Author: May Nguyen
--Student ID: 1051760
--Due Date: Thursday, November 30th, 2023
--Resources: https://www.postgresql.org/docs/16/plpgsql-control-structures.html
--           Tutorial of Blocks, Functions, Triggers
--           https://www.postgresql.org/docs/8.3/sql-createtrigger.html
--           https://www.postgresql.org/docs/8.3/trigger-definition.html
--           https://www.postgresql.org/docs/16/functions-string.html
--

CREATE OR REPLACE FUNCTION toUpperCase()
RETURNS trigger AS
$$
BEGIN
    NEW.FNAME = UPPER(NEW.FNAME);
    NEW.LNAME = UPPER(NEW.LNAME);
    RETURN NEW;
END;
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER ensure_case
BEFORE UPDATE OR INSERT ON AGENTS
FOR EACH ROW
EXECUTE PROCEDURE toUpperCase();

-- Limitations/Assumptions: 
-- *   No assumptions