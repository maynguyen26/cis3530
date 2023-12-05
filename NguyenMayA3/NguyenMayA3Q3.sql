--CIS*3530 Database Systems and Concepts: Assignment 3, Question 3 
--Description: PL/pgsql procedure that lists all countries and total number 
--             of students that each university has recruited from 
--             different countries.
--Author: May Nguyen
--Student ID: 1051760
--Due Date: Thursday, November 30th, 2023
--Resources: https://www.postgresql.org/docs/16/plpgsql-control-structures.html
--           Tutorial of Blocks, Cursors, Functions
--           https://www.postgresql.org/docs/8.3/plpgsql-errors-and-messages.html
--           https://www.postgresql.org/docs/16/functions-string.html
--

CREATE OR REPLACE FUNCTION recruit_report() RETURNS TABLE (University VARCHAR, numRecruited INTEGER)
AS 
$$
DECLARE 
    countryName VARCHAR(30);
    recruit_total INTEGER;
    U1 CURSOR FOR SELECT * FROM UNIVERSITY ORDER BY uid;
    R1 CURSOR FOR SELECT * FROM RECRUITS_FROM ORDER BY uid, numstudents DESC;
BEGIN 
    DROP TABLE IF EXISTS recruit_stats;
    CREATE TABLE IF NOT EXISTS recruit_stats (
        University VARCHAR(30),
        numRecruited INTEGER,

        PRIMARY KEY (University, numRecruited)
    );
    RAISE NOTICE '%', REPEAT('*', 25); 
    FOR u in u1 LOOP
        recruit_total = 0;
        RAISE NOTICE '% recruited:', INITCAP(u.name);
        --RAISE NOTICE '% recruited:', determine_uniname(u.uid);
        FOR r in R1 LOOP
            IF u.uid = r.uid THEN
                SELECT NAME INTO STRICT countryNAME FROM COUNTRY WHERE COUNTRY.cid = r.cid; 
                RAISE NOTICE '% students from %', r.numstudents, INITCAP(countryName);
                recruit_total = recruit_total + r.numstudents;
            END IF;
        END LOOP;
        RAISE NOTICE 'Total number of students = %', recruit_total;
        INSERT INTO recruit_stats VALUES(u.name, recruit_total);
    END LOOP;
    RETURN QUERY SELECT * FROM recruit_stats;
END;
$$
LANGUAGE 'plpgsql';

-- Limitations/Assumptions: 
-- *    Must run determine_uniname.sql to get expected university name output (in given example)
--      comment out line 33/uncomment line 34
-- *    First letter of every word in country name is capitalized, rest is lowercase
-- *    Table recruit_stats is replaced if it exists before the function is executed (dropped)

