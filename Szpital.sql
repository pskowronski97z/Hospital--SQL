CREATE TABLE Patients
(
    FIRST_NAME VARCHAR(15) DEFAULT 'unknown name' NOT NULL,
    SURNAME VARCHAR(20) DEFAULT 'unknown sur' NOT NULL,
    PATIENT_ID NUMBER(10) PRIMARY KEY,
    BIRTH_DATE DATE,
    SEX VARCHAR(1),
    PHONE NUMBER(10,0) UNIQUE,
    DOCTOR_ID NUMBER(10), 
    ROOM_ID NUMBER(10),
    BILL_ID NUMBER(10),
    
    CONSTRAINT SEX_CHECK CHECK(SEX='M' OR SEX='F')
)TABLESPACE "USERS";

COMMENT ON COLUMN Patients.FIRST_NAME IS 'Imię pacjenta';
COMMENT ON COLUMN Patients.SURNAME IS 'Nazwisko pacjenta';
COMMENT ON COLUMN Patients.PATIENT_ID IS 'Unikalny identyfikator pacjenta';
COMMENT ON COLUMN Patients.BIRTH_DATE IS 'Data urodzenia pacjenta';
COMMENT ON COLUMN Patients.SEX IS 'Pleć pacjenta';
COMMENT ON COLUMN Patients.PHONE IS 'Numer telefonu do pacjenta';
COMMENT ON COLUMN Patients.DOCTOR_ID IS 'Identyfikator lekarza który leczy pacjenta';
COMMENT ON COLUMN Patients.ROOM_ID IS 'Identyfikator sali w której leży pacjent';
COMMENT ON COLUMN Patients.BILL_ID IS 'Identyfikator sali w której leży pacjent';

CREATE TABLE Doctors
(
    FIRST_NAME VARCHAR(15) DEFAULT 'unknown name' NOT NULL,
    SURNAME VARCHAR(20) DEFAULT 'unknown surname' NOT NULL,
    DOCTOR_ID NUMBER(10) PRIMARY KEY,
    SPECJALIZATION VARCHAR(25),
    WARD_NAME VARCHAR(25)
)TABLESPACE "USERS";

COMMENT ON COLUMN Doctors.FIRST_NAME IS 'Imię lekarza';
COMMENT ON COLUMN Doctors.SURNAME IS 'Nazwisko lekarza';
COMMENT ON COLUMN Doctors.DOCTOR_ID IS 'Unikalny identyfikator lekarza';
COMMENT ON COLUMN Doctors.SPECJALIZATION IS 'Specjalizacja lekarza';
COMMENT ON COLUMN Doctors.WARD_NAME IS 'Nazwa oddzialu na którym pracuje lekarz';

CREATE TABLE Rooms
(
    ROOM_ID NUMBER(10) PRIMARY KEY,
    BED_COUNT NUMBER(10) NOT NULL,
    WC VARCHAR(1),
    FLOOR NUMBER(10) NOT NULL,
    WARD_NAME VARCHAR(25),

    CONSTRAINT WC_CHECK CHECK(WC='Y' OR WC='N')
)TABLESPACE "USERS";

COMMENT ON COLUMN Rooms.ROOM_ID IS 'Unikalny identyfikator sali';
COMMENT ON COLUMN Rooms.BED_COUNT IS 'Ilość lóżek';
COMMENT ON COLUMN Rooms.WC IS 'Toaleta w pokoju';
COMMENT ON COLUMN Rooms.FLOOR IS 'Numer piętra';
COMMENT ON COLUMN Rooms.WARD_NAME IS 'Nazwa oddzialu na którym jest sala';

CREATE TABLE Bills
(
    BILL_ID NUMBER(10,0) PRIMARY KEY,
    PAT_SURNAME VARCHAR(20) DEFAULT 'unknown sur' NOT NULL,
    DOC_SURNAME VARCHAR(20)  DEFAULT 'unknown sur' NOT NULL,
    TOTAL NUMBER(10) DEFAULT 0,
    DIAG_ID NUMBER(10),
    BILL_DATE DATE
)TABLESPACE "USERS";

COMMENT ON COLUMN Bills.BILL_ID IS 'Unikalny identyfikator rachunku';
COMMENT ON COLUMN Bills.PAT_SURNAME IS 'Nazwisko pacjenta dla którego wystawiany jest rachunek';
COMMENT ON COLUMN Bills.DOC_SURNAME IS 'Nazwisko lekarza który leczyl pacjenta';
COMMENT ON COLUMN Bills.TOTAL IS 'Kwota do zaplaty';
COMMENT ON COLUMN Bills.DIAG_ID IS 'Identyfikator diagnozy postawionej podczas leczenia';
COMMENT ON COLUMN Bills.BILL_DATE IS 'Data wystawienia rachunku';

CREATE TABLE Diagnosis
(
    DIAG_NAME VARCHAR(15) NOT NULL,
    DIAG_ID NUMBER (10) PRIMARY KEY,
    DIAG_DATE DATE,
    PATIENT_ID NUMBER(10),
    DOCTOR_ID NUMBER(10)
)TABLESPACE "USERS";

COMMENT ON COLUMN Diagnosis.DIAG_NAME IS 'Postawiona diagnoza';
COMMENT ON COLUMN Diagnosis.DIAG_ID IS 'Unikalny identyfikator diagnozy';
COMMENT ON COLUMN Diagnosis.DIAG_DATE IS 'Data diagnozy';
COMMENT ON COLUMN Diagnosis.PATIENT_ID IS 'Identyfikator diagnozowanego pacjenta';
COMMENT ON COLUMN Diagnosis.DOCTOR_ID IS 'Identyfikator lekarza diagnozujacego';

ALTER TABLE Patients
    MODIFY DOCTOR_ID REFERENCES Doctors(DOCTOR_ID)
    MODIFY ROOM_ID REFERENCES Rooms(ROOM_ID)
    MODIFY BILL_ID REFERENCES Bills(BILL_ID);

ALTER TABLE Bills
    MODIFY DIAG_ID REFERENCES Diagnosis(DIAG_ID);
    
ALTER TABLE Diagnosis
    MODIFY PATIENT_ID REFERENCES Patients(PATIENT_ID)
    MODIFY DOCTOR_ID REFERENCES Doctors(DOCTOR_ID);
	
	

CREATE VIEW PATIENT_VIEW 
AS
SELECT P.PATIENT_ID AS "ID Pacjenta", 
P.FIRST_NAME AS "Imię pacjenta", 
P.SURNAME AS "Nazwisko pacjenta", 
(SELECT R.WARD_NAME 
	FROM ROOMS R 
	WHERE R.ROOM_ID=P.ROOM_ID) AS "Oddział", 
(SELECT D.SURNAME 
	FROM DOCTORS D 
	WHERE D.DOCTOR_ID=P.DOCTOR_ID) AS "Nazwisko lekarza"
FROM PATIENTS P;


















	