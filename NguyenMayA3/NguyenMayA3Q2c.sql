--CIS*3530 Database Systems and Concepts: Assignment 3, Question 2 - Part C
--Description: PL/pgsql function that generates an email for each agent 
--             (in addition to the gmail one) given their aid, using their 
--             first name, last name, country and url of the university
--Author: May Nguyen
--Student ID: 1051760
--Due Date: Thursday, November 30th, 2023
--Resources: https://www.postgresql.org/docs/16/plpgsql-control-structures.html
--           Tutorial of Blocks, Cursors, Functions in plpgsql
--           https://www.postgresql.org/docs/8.3/plpgsql-errors-and-messages.html
--           https://www.postgresql.org/docs/16/functions-string.html
--           

CREATE OR REPLACE FUNCTION generateEmail(AgentID INTEGER) RETURNS VARCHAR(190)
AS $$
DECLARE 
    newemail VARCHAR(190); -- 30FNAME+30LNAME+30CNAME+100URL
    c1 CURSOR FOR SELECT AID, FNAME, LNAME
              FROM AGENTS ORDER BY AID;
BEGIN
    SELECT LOWER(FNAME || '.' 
              || LNAME || '.' 
              || c.NAME || '@' 
              || TRIM('/' FROM TRIM('https://www.' FROM u.URL)))
    INTO newemail
    FROM AGENTS 
    NATURAL JOIN (SELECT CID, NAME
                  FROM COUNTRY) AS c
    NATURAL JOIN (SELECT UID, URL
                  FROM UNIVERSITY) AS u
    WHERE AGENTS.AID = AgentID; 

    IF NOT FOUND THEN
         -- Print all valid agent ids with names, order by aid
        RAISE NOTICE 'Invalid agent id. Valid agent ids are:';
        FOR i in c1 LOOP
            RAISE NOTICE '%: % %', i.AID, i.FNAME, i.LNAME;
        END LOOP;
        RAISE EXCEPTION 'Invalid agent id';
    END IF;

    RETURN newemail;
END
$$
LANGUAGE plpgsql;

-- Limitations/Assumptions: 
-- *    Same exception handling as Part B when the Agent id is not found
-- *    Assumes every agent has a fname, lname, cid and uid 
-- *    Assumes that every url starts with 'https://www.' and ends with '/'