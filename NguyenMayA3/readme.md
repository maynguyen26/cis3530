CIS*3530 Assignment 3 - Procedural Extensions to SQL in Postgres, Independent Learning
Author: May Nguyen
Student ID: 1051760
Due Date: Sunday, November 26th, 2023

* Question 1 - C program that implements a given SQL subquery

    Files: NguyenMayA3Q1.c makefile s.csv sp.csv 
    Description: 
    * - Given the structure defintions of Supplier and SupplierPart, this program
    *   populates arrays with values given by a csv file and then implements the 
    *   following subquery: 
    * 
            SELECT SNAME
            FROM S
            WHERE NOT EXISTS (SELECT *
            FROM SP
            WHERE S.SNO=SP.SNO
            AND SP.PNO = ‘P2’);

    Compilation: 
    - Compile using 'make'
    - Makes two executable file ./a3q1

    Execution: 
    - Execute using './a3q1 <Sfilename>.csv <SPfilename>.csv, 
    *                          where Xfilename is the name of a csv file (that uses ','
    *                          as a delimiter) provided in the same directory as the 
    *                          executable file containing tuples of a relation defined 
    *                          with the same attributes as Supplier and SupplierPart, 
    *                          respectively

    Assumptions:
    - I used ./a3q1 s.csv sp.csv to test my output
    - Used function strcmp_ignorecase to compare to "p2" instead of "P2" since all my data was in lowercase
    - Prints all data to uppercase

* Question 2 - Independent Learning Question

    Files: NguyenMayA3Q32a.sql, NguyenMayA3Q32b.sql, NguyenMayA3Q32c.sql, NguyenMayA3Q32d.sql, 
           NguyenMayA3Q32e.sql, determine_uniname.sql
    Notes: 
    - All parts were completed using the create_icru.sql provided
    - For Part D, expected output is unclear for university name, so two options are provided as described
      in assumptions portion of code - one of which uses a determine_uniname function found in determine_uniname.sql

    * Part A - NguyenMayA3Q2a.sql
      Declaration: numberAgents(uniNAME VARCHAR(30)) RETURNS TABLE(numberAgents bigint)
      Description: PL/pgsql function that returns the total number of agents hired by a university,
                   given the university name.
      Resources:   https://www.postgresql.org/docs/16/plpgsql-control-structures.html
                   Tutorial of Blocks, Functions in plpgsql
                   https://www.postgresql.org/docs/16/functions-string.html
      Assumptions: University name given is not case sensitive
                   Does not return an error when university name is not found

    * Part B - NguyenMayA3Q2b.sql
      Declaration: find_max_commission(AgentID INTEGER) RETURNS decimal
      Description: PL/pgsql function that takes an agent id as input and returns the commission
                   earned by the agent. If the agent id is not found in the schema, then the function 
                   displays a message that it is an invalid id, along with the complete list of agents 
                   in the schema sorted on agent id.
      Resources:   https://www.postgresql.org/docs/16/plpgsql-control-structures.html
                   Tutorial of Blocks, Cursors, Functions in plpgsql
                   https://www.postgresql.org/docs/8.3/plpgsql-errors-and-messages.html
      Assumptions: Agents are printed in order of ascending AID 
                   Commission earned is only given as an example output, default column title is 
                   "find_max_commission"

    * Part C - NguyenMayA3Q2c.sql
      Declaration: generateEmail(AgentID INTEGER) RETURNS VARCHAR(190)
      Description: PL/pgsql function that generates an email for each agent (in addition to the gmail
                   one) given their aid, using their first name, last name, country and url of the university
      Resources:   https://www.postgresql.org/docs/16/plpgsql-control-structures.html
                   Tutorial of Blocks, Cursors, Functions in plpgsql
                   https://www.postgresql.org/docs/8.3/plpgsql-errors-and-messages.html
                   https://www.postgresql.org/docs/16/functions-string.html
      Assumptions: Same exception handling as Part B when the Agent id is not found
                   Assumes every agent has a fname, lname, cid and uid 
                   Assumes that every url starts with 'https://www.' and ends with '/'

    * Part D - NguyenMayA3Q2d.sql
      Declaration: FUNCTION - urlChangeAlert() RETURNS trigger TRIGGER - after_update_url
      Description: Trigger for table University so that anytime the url is changed, an alert message is
                   displayed on the screen (for example, ’University of Guelph is changing its url’).
      Resources:   https://www.postgresql.org/docs/16/plpgsql-control-structures.html
                   Tutorial of Blocks, Functions, Triggers
                   https://www.postgresql.org/docs/8.3/sql-createtrigger.html
                   https://www.postgresql.org/docs/8.3/trigger-definition.html
                   https://www.postgresql.org/docs/8.3/plpgsql-errors-and-messages.html
      Assumptions: The alert message displayed on the screen is displayed using RAISE NOTICE
                   Must run determine_uniname.sql to get expected university name output (in given example)
                   and comment out line 19/uncomment line 20
                   First letter of every word in university name is capitalized, rest is lowercase
    
    * Part E - NguyenMayA3Q2e.sql
      Declaration: FUNCTION - toUpperCase() RETURNS trigger TRIGGER - ensure_case
      Description: Trigger called ensure_case for table Agents that change the letters in first and last
                   names of agents to uppercase before the data is actually inserted or updated in the table
      Resources:   https://www.postgresql.org/docs/16/plpgsql-control-structures.html
                   Tutorial of Blocks, Functions, Triggers
                   https://www.postgresql.org/docs/8.3/sql-createtrigger.html
                   https://www.postgresql.org/docs/8.3/trigger-definition.html
                   https://www.postgresql.org/docs/16/functions-string.html
      Assumptions: No assumptions 
   
* Question 3 - Bonus Question

    File: NguyenMayA3Q3.sql, determine_uniname.sql
    Notes: 
    - Completed using the create_icru.sql provided
    - Expected output is unclear for university name, so two options are provided as described
      in assumptions portion of code - one of which uses a determine_uniname function found in 
      determine_uniname.sql

    Declaration: recruit_report() RETURNS TABLE(University VARCHAR(30), numRecruited INTEGER)
    Description: PL/pgsql procedure that lists all countries and total number of students 
                 that each university has recruited from different countries.
    Resources:   https://www.postgresql.org/docs/16/plpgsql-control-structures.html
                 Tutorial of Blocks, Cursors, Functions
                 https://www.postgresql.org/docs/8.3/plpgsql-errors-and-messages.html
                 https://www.postgresql.org/docs/16/functions-string.html
    Assumptions: Must run determine_uniname.sql to get expected university name output (in given example)
                 and comment out line 33/uncomment line 34
                 First letter of every word in country name is capitalized, rest is lowercase
                 Table recruit_stats is replaced if it exists before the function is executed (dropped)







