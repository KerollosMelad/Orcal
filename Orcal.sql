--////////////////////////////////////   PL/SQL anonymous block    ////////////////////////////////////   

SET SERVEROUTP ON
BEGIN
   DBMS_OUTPUT.put_line ('Hello World!');
END;

--////////////////////////////////////   IF ELSEIF    ////////////////////////////////////   
SET SERVEROUTP ON
DECLARE
  n_sales NUMBER := 300000;
  n_commission NUMBER( 10, 2 ) := 0;
BEGIN
  IF n_sales > 200000 THEN
    n_commission := n_sales * 0.1;
  ELSIF n_sales <= 200000 AND n_sales > 100000 THEN 
    n_commission := n_sales * 0.05;
  ELSIF n_sales <= 100000 AND n_sales > 50000 THEN 
    n_commission := n_sales * 0.03;
  ELSE
    n_commission := n_sales * 0.02;
  END IF;
  
  DBMS_OUTPUT.put_line (n_commission);
END;

--////////////////////////////////////   Case    ////////////////////////////////////   

DECLARE
  n_sales      NUMBER;
  n_commission NUMBER;
BEGIN
  n_sales := 150000;
  CASE
  WHEN n_sales    > 200000 THEN
    n_commission := 0.2;
  WHEN n_sales   >= 100000 AND n_sales < 200000 THEN
    n_commission := 0.15;
  WHEN n_sales   >= 50000 AND n_sales < 100000 THEN
    n_commission := 0.1;
  WHEN n_sales    > 30000 THEN
    n_commission := 0.05;
  ELSE
    n_commission := 0;
  END CASE;

  DBMS_OUTPUT.PUT_LINE( 'Commission is ' || n_commission * 100 || '%');
END;


--////////////////////////////////////   Loop    ////////////////////////////////////  

DECLARE
  l_counter NUMBER := 0;
BEGIN
  LOOP
    l_counter := l_counter + 1;
    IF l_counter > 3 THEN
      EXIT;                                                        -- To Break Loop
    END IF;
    dbms_output.put_line( 'Inside loop: ' || l_counter )  ;
  END LOOP;
  -- control resumes here after EXIT
  dbms_output.put_line( 'After loop: ' || l_counter );
END;

--////////////////////////////////////   For Loop    ////////////////////////////////////  


DECLARE
  l_step  Number := 2;
BEGIN
  FOR l_counter IN 1..5 LOOP
    dbms_output.put_line (l_counter*l_step);
  END LOOP;
END;

--////////////////////////////////////   While Loop    ////////////////////////////////////  

DECLARE
  n_counter NUMBER := 1;
BEGIN
  WHILE n_counter <= 5
  LOOP
    DBMS_OUTPUT.PUT_LINE( 'Counter : ' || n_counter );
    n_counter := n_counter + 1;
  END LOOP;
END;

--////////////////////////////////////   Loop With CONTINUE   ////////////////////////////////////  

BEGIN
  FOR n_index IN 1 .. 10
  LOOP
    IF MOD( n_index, 2 ) = 0 THEN
      CONTINUE;
    END IF;
    DBMS_OUTPUT.PUT_LINE( n_index );
  END LOOP;
END;

--////////////////////////////////////   SELECT INTO   ////////////////////////////////////  

DECLARE
  l_Reactant_name NVARCHAR2(2000);
BEGIN
  SELECT R."Name" INTO l_Reactant_name
  FROM  "Reactants" R
  WHERE R."Id" = 5;
  dbms_output.put_line( l_Reactant_name );
END;


--////////////////////////////////////   EXCEPTION   ////////////////////////////////////  
    
DECLARE
    l_Reactant_name NVARCHAR2(2000);
BEGIN
    SELECT R."Name" INTO l_Reactant_name
    FROM "Reactants" R
    WHERE R."Id" = 0;
    
    dbms_output.put_line('Reactant name is ' || l_Reactant_name);

    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            dbms_output.put_line('Reactant does not exist');
END;

--////////////////////////////////////   PROCEDURE   ////////////////////////////////////  

CREATE OR REPLACE PROCEDURE GetReactant(
    in_Reactant_id IN NUMBER 
)
IS
  l_Reactant_name NVARCHAR2(2000);
BEGIN
   SELECT R."Name" INTO l_Reactant_name
    FROM "Reactants" R
    WHERE R."Id" = in_Reactant_id;


  dbms_output.put_line(  '<' || l_Reactant_name ||'>' );

EXCEPTION
   WHEN OTHERS THEN
      dbms_output.put_line( SQLERRM );
END;

EXECUTE GetReactant(5);

--////////////////////////////////////   VIEW   ////////////////////////////////////  

CREATE OR REPLACE VIEW Reactants_Details(
        id,
        name
    ) AS 
SELECT
        R."Id",
        R."Name"
    FROM "Reactants" R
         WITH READ ONLY;

select *
From Reactants_Details;



--////////////////////////////////////   VIEW   WITH CHECK OPTION ////////////////////////////////////  

CREATE OR REPLACE VIEW Reactants_Details_With_Condition(
        id,
        name
    )
AS   
  SELECT  R."Id",R."Name" 
  FROM  "Reactants" R
  WHERE R."Name" Like '%51%'
  WITH CHECK OPTION;


select *
From Reactants_Details_With_Condition
where id = 12;
-----------------------------------------------------------------------------------------------
INSERT
    INTO
        Reactants_Details_With_Condition(
            id,
            name
        )
    VALUES(
         1033,
        'CYCLOHEXANE5280'
    );
    
 --SQL Error: ORA-01402: view WITH CHECK OPTION where-clause violation
 
 -----------------------------------------------------------------------------------------------
 UPDATE
    Reactants_Details_With_Condition
SET
    name = 'CYCLOHEXANE5280'
WHERE
    id = 12;
    
--ORA-01402: view WITH CHECK OPTION where-clause violation

 UPDATE
    Reactants_Details_With_Condition
SET
    name = 'CYCLOHEXANE5180'
WHERE
    id = 12;
    
--1 rows updated.