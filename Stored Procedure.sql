CREATE DEFINER=`root`@`localhost` PROCEDURE `terminate_student_enrollment`(
	CourseCode_in varchar(24), 
    Section_in varchar(50), 
    StudentID_in varchar(24), 
    Withdraw_Date_in date
    )
BEGIN

DECLARE Variable int; 

SET Variable = 
	(
    SELECT ID_Student 
	FROM Student 
    WHERE StudentID = StudentID_in
    );

UPDATE classparticipant
SET EndDate = Withdraw_Date_in
WHERE ID_Class = 
(
	SELECT ID_Class
    FROM Class c
    INNER JOIN Course co 
    ON C.id_Course = co.ID_Course
    WHERE Section = Section_in
    AND co.CourseCode = CourseCode_in
    AND classparticipant.ID_Student = Variable
);
END