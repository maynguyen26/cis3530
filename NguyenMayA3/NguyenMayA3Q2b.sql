--CIS*3530 Database Systems and Concepts: Assignment 3, Question 2 - Part B
--Description: PL/pgsql function that takes an agent id as input and returns 
--             the commission earned by the agent. If the agent id is not 
--             found in the schema, then the function displays a message that 
--             it is an invalid id, along with the complete list of agents 
--             in the schema sorted on agent id.
--Author: May Nguyen
--Student ID: 1051760
--Due Date: Thursday, November 30th, 2023
--Resources: https://www.postgresql.org/docs/16/plpgsql-control-structures.html
--           Tutorial of Blocks, Cursors, Functions in plpgsql
--           https://www.postgresql.org/docs/8.3/plpgsql-errors-and-messages.html

CREATE OR REPLACE FUNCTION find_max_commission(AgentID NUMERIC) RETURNS TABLE(comrtn decimal)
AS $$
DECLARE 
    comrtrn decimal;
    c1 CURSOR FOR SELECT AID, FNAME, LNAME
              FROM AGENTS ORDER BY AID;
BEGIN
    RETURN QUERY SELECT COMMISSION FROM AGENTS where AGENTS.AID = AgentID;
    
    IF NOT FOUND THEN
        -- Print all valid agent ids with names, order by aid
        RAISE NOTICE 'Invalid agent id. Valid agent ids are:';
        FOR i in c1 LOOP
            RAISE NOTICE '%: % %', i.AID, i.FNAME, i.LNAME;
        END LOOP;
        RAISE EXCEPTION 'Invalid agent id';
    END IF;  
END
$$
LANGUAGE plpgsql;

-- Limitations/Assumptions: 
-- *    Agents are printed in order of ascending AID 
-- *    Commission earned is only given as an example output, default column title is 
--      "find_max_commission"