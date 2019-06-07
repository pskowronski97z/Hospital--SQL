----------------------------- Rejestracja pacjenta -----------------------
-- Do każdego z zadeklarowanych pól należy wprowadzić odpowiednie dane ---
-- a następnie wywołać poniższą procedurę. Identyfikator pacjenta zostanie
-- wygenerowany automatycznie --------------------------------------------
-------------------------------------------------------------------------- 
declare

	fname varchar(15);
	sname varchar(20);
	bdate date;
	gender varchar(1);
	phonenmbr number(10);
	doc_id number(10);
	room_id number(10);
	
begin
	
	fname:='Jan';     		--Imię pacjenta
	sname:='Kowalski';		--Nazwisko pacjenta
	bdate:='76/06/21';		--Data ur. YYYY/MM/DD
	gender:='M';			--Płeć M/F
	phonenmbr:='506938123';	--Nr. telefonu
	doc_id:=6;				--ID lekarza
	room_id:=13;			--ID sali
	
	insert into Patients
	(first_name,
	surname,
	patient_id,
	birth_date,
	sex,
	phone,
	doctor_id,
	room_id)
	
	values
	(fname,
	sname,
	(SELECT COUNT(*)+1 FROM Patients),
	bdate,
	gender,
	phonenmbr,
	doc_id,
	room_id);
	
end;
	
	
----------------------------- Stawianie diagnozy ---------------------------------
-- Należy wypełnić następujące pola a następnie uruchomić poniższą część skryptu.- 
-- Data diagnozy i identyfikator lekarza zostaną uzupełnione automatycznie -------
----------------------------------------------------------------------------------
declare

	dname varchar(15);
	diagID number(10);
	doc_id number(10);
	ptn_id number(10);

begin

	dname:='Chronic migrene';	--Diagnoza
	diagID:=2; 					--ID diagnozy
	ptn_id:=13;					--ID pacjenta
	
	insert into Diagnosis
	(diag_name,
	diag_id,
	diag_date,
	patient_id,
	doctor_id)
	
	values 
	(dname,
	diagID,
	(select sysdate from Dual),
	ptn_id,
	(select doctor_id from Patients where patient_id=ptn_id));
	
end;
	
------------------------ Wystawianie rachunków ---------------------------	
-- Wystawienie pacjentowi rachunku polega na podaniu jego numeru, kwoty --
-- oraz identyfikatora diagnozy. Pozostałe pola zostaną uzupełnione ------
-- automatycznie ---------------------------------------------------------
--------------------------------------------------------------------------	
declare

    billID number(10);
    total_cost number(10);
    diagID number(10);
    
begin

    billID:=8;           -- Numer rachunku
    total_cost:=1300;    -- Kwota
    diagID:=2;           -- ID diagnozy
    
insert into Bills

    (bill_id,
    pat_surname,
    doc_surname,
    total,
    diag_id,
    bill_date)
    
    values 
    (billID,
    (select surname
    from Patients
    where patient_id = (select patient_id 
                        from Diagnosis 
                        where diag_id=diagID)),
    (select surname 
    from Doctors 
    where doctor_id = (select doctor_id 
                      from Diagnosis 
                      where diag_id=diagID)),          
    total_cost,
    diagID,
    (select sysdate from dual));
    
update Patients
	set bill_id=billID
	where patient_id = (select patient_id 
                        from Diagnosis 
                        where diag_id=diagID);
	
end;    
    	

----------------------- Usuwanie pacjenta z bazy ----------------------------
-- Usunięcie pacjenta z bazy odbywa poprzez podanie jego identyfikatora. ----
-- Powiązane z nim diagnozy oraz rachunki są usuwane automatycznie ----------
-----------------------------------------------------------------------------
declare
    ptn_id number(10);

begin
    ptn_id := 13;   --ID usuwanego pacjenta 
 
update bills
	set diag_id = null
	where bill_id = (select bill_id 
					from patients 
					where patient_id = ptn_id);
 
  
delete from diagnosis
    where patient_id = ptn_id;
	  
delete from patients
    where patient_id = ptn_id;
	
delete from bills
    where diag_id is null;
    
end;    

------------------------- Wywołanie widoku pacjentów ---------------------------		

select * from PATIENT_VIEW;	
		