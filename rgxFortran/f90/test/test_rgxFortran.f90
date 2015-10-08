PROGRAM rgxFortran_Test
USE rgxFortran
IMPLICIT NONE
TYPE(RGX)::re
LOGICAL::tf

	CALL re.Compile("[[:alpha:]]+")
	WRITE(*,*) re.match("hello")
	WRITE(*,*) re.group.get_size()
	WRITE(*,*) re.group.get_match(0)
	CALL re.delete


END PROGRAM
