--CIS*3530 Database Systems and Concepts: Assignment 3, Question 2 - Part D
--Description: Trigger for table University so that anytime the url is changed, 
--             an alert message is displayed on the screen (for example, 
--             ’University of Guelph is changing its url’).
--Author: May Nguyen
--Student ID: 1051760
--Due Date: Thursday, November 30th, 2023
--Resources: https://www.postgresql.org/docs/16/plpgsql-control-structures.html
--           Tutorial of Blocks, Functions, Triggers
--           https://www.postgresql.org/docs/8.3/sql-createtrigger.html
--           https://www.postgresql.org/docs/8.3/trigger-definition.html
--           https://www.postgresql.org/docs/8.3/plpgsql-errors-and-messages.html
--

CREATE OR REPLACE FUNCTION urlChangeAlert()
RETURNS trigger AS
$$
BEGIN
    RAISE NOTICE '% is changing its url', INITCAP(NEW.name);
    --RAISE NOTICE '% is changing its url', determine_uniname(NEW.uid);
    RETURN NEW;
END;
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER after_update_url
BEFORE UPDATE OF URL ON UNIVERSITY
FOR EACH ROW
EXECUTE PROCEDURE urlChangeAlert();

-- Limitations/Assumptions: 
-- *    The alert message displayed on the screen is displayed using RAISE NOTICE
-- *    Must run determine_uniname.sql to get expected university name output (in given example)
--      and comment out line 19/uncomment line 20
-- *    First letter of every word in university name is capitalized, rest is lowercase