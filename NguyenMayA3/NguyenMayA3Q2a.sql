--CIS*3530 Database Systems and Concepts: Assignment 3, Question 2 - Part A
--Description: PL/pgsql function that returns the total number of agents 
--             hired by a university, given the university name
--Author: May Nguyen
--Student ID: 1051760
--Due Date: Thursday, November 30th, 2023
--Resources: https://www.postgresql.org/docs/16/plpgsql-control-structures.html
--           Tutorial of Blocks, Functions in plpgsql
--           https://www.postgresql.org/docs/16/functions-string.html
--

CREATE OR REPLACE FUNCTION numberAgents(uniNAME VARCHAR(30)) RETURNS TABLE(numberAgents bigint)
AS
$$
BEGIN
    RETURN QUERY (SELECT count(AID) as numberagents
            FROM AGENTS
            WHERE EXISTS (SELECT * FROM UNIVERSITY 
                            WHERE LOWER(UNIVERSITY.NAME) = LOWER(uniNAME)
                            AND UNIVERSITY.UID = AGENTS.UID));
END
$$
LANGUAGE plpgsql;

-- Limitations/Assumptions: 
-- *    University name given is not case sensitive
-- *    Does not return an error when university name is not found

