 DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `terminate student enrollment`(
CourseCode_input varchar(55),
StudentID_input varchar (55),
Section_input varchar (50),
EndDate date
)
BEGIN

DECLARE ID_Student_output int;
DECLARE ID_Class_output int;

UPDATE
classparticipant cp
    INNER JOIN class c
   ON cp.ID_Class = c.ID_Class
   INNER JOIN course co
   ON c.ID_Course = co.ID_Course
   INNER JOIN student s
   ON cp.ID_Student = s.ID_Student
SET
    cp.EndDate = NOW()
WHERE
    co.CourseCode = 'CourseCode_input'
   AND c.Section= 'Section_input'
   AND StudentID = 'StudentID_input';
END $$