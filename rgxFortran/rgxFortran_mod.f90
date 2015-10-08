MODULE rgxFortran
USE rgxc_Interfaces
IMPLICIT NONE
PRIVATE
PUBLIC::rgx,is_match,is_integer,is_real,is_letter,is_word

TYPE rgxGroup
	TYPE(C_PTR)::groupObj
	LOGICAL::isReady
CONTAINS
	PROCEDURE::is_ready
	PROCEDURE::is_empty
	PROCEDURE::get_size
	PROCEDURE::get_match
	PROCEDURE::get_match_len
	PROCEDURE::get_match_pos
END TYPE


TYPE Rgx
	TYPE(C_PTR)::expObj
	TYPE(rgxGroup)::group
	LOGICAL::isMatchEmpty
	INTEGER::Size
CONTAINS
	PROCEDURE,PRIVATE::make_exp_obj
	PROCEDURE,PRIVATE::match_exp_obj
	PROCEDURE,PRIVATE::delete_exp_obj

	GENERIC::Compile=>make_exp_obj
	GENERIC::Match=>match_exp_obj
	GENERIC::Delete=>delete_exp_obj
END TYPE


CONTAINS

!++++++++++++++++++++++++++++++++++++++++++++++++++
!				 Bound Procedures
!++++++++++++++++++++++++++++++++++++++++++++++++++

SUBROUTINE make_exp_obj(self,re_str)
IMPLICIT NONE
CLASS(Rgx)::self
CHARACTER(*)::re_str
	self.expObj=c_new_rgx_(re_str)
	self.group.groupObj=c_group_rgx_(self.expObj)
END SUBROUTINE


SUBROUTINE delete_exp_obj(self)
IMPLICIT NONE
CLASS(Rgx)::self
	call c_delete_rgx_(self.expObj)
END SUBROUTINE


FUNCTION match_exp_obj(self,str) RESULT(TF)
IMPLICIT NONE
CLASS(Rgx)::self
CHARACTER(*)::str
LOGICAL::TF
	TF=c_match_rgx_(self.expObj,str)
	self.isMatchEmpty=self.group.is_empty()
	IF(self.isMatchEmpty/=.TRUE.)THEN
		self.size=self.group.get_size()
	END IF
END FUNCTION


SUBROUTINE is_ready(self)
IMPLICIT NONE
CLASS(rgxGroup)::self
LOGICAL::TF
	self.isReady=c_group_ready_rgx_(self.groupObj)
END SUBROUTINE


FUNCTION is_Empty(self) RESULT(TF)
IMPLICIT NONE
CLASS(rgxGroup)::self
LOGICAL::TF
	TF=c_group_empty_rgx_(self.groupObj)
END FUNCTION

FUNCTION get_size(self) RESULT(sze)
CLASS(rgxGroup)::self
INTEGER::sze
	sze=c_group_size_rgx_(self.groupObj)
END FUNCTION

FUNCTION get_match(self,I) RESULT (matchstr)
USE ISO_C_BINDING, ONLY: C_PTR
IMPLICIT NONE
CLASS(rgxGroup)::self
INTEGER::I
CHARACTER(LEN=:),ALLOCATABLE::matchstr
	IF (I>=0 .AND. I<=(self.get_size()-1)) THEN
		matchstr=CF_STRING(c_group_str_rgx_(self.groupObj,I))
	ELSE
		matchstr=''
	END IF
END FUNCTION

FUNCTION get_match_len(self,I) RESULT (mLen)
USE ISO_C_BINDING, ONLY: C_PTR
IMPLICIT NONE
CLASS(rgxGroup)::self
INTEGER::I
INTEGER::mLen
	IF (I>=0 .AND. I<=(self.get_size()-1)) THEN
		mLen=c_group_length_rgx_(self.groupObj,I)
	ELSE
		mLen=-1
	END IF
END FUNCTION

FUNCTION get_match_pos(self,I) RESULT (mPos)
USE ISO_C_BINDING, ONLY: C_PTR
IMPLICIT NONE
CLASS(rgxGroup)::self
INTEGER::I
INTEGER::mPos
	IF (I>=0 .AND. I<=(self.get_size()-1)) THEN
		mPos=c_group_pos_rgx_(self.groupObj,I)
	ELSE
		mPos=-1
	END IF
END FUNCTION


!++++++++++++++++++++++++++++++++++++++++++++++++++
!				Unbound Procedures
!++++++++++++++++++++++++++++++++++++++++++++++++++
	FUNCTION is_match(frgx,str) RESULT(TF)
	IMPLICIT NONE
	CHARACTER(*)::frgx,str
	LOGICAL::TF
		TF=is_match_c_(frgx,str)
	END FUNCTION

	FUNCTION is_integer(str) RESULT(TF)
	IMPLICIT NONE
	CHARACTER(*)::str
	LOGICAL::TF
		TF=is_integer_c_(str)
	END FUNCTION

	FUNCTION is_real(str) RESULT(TF) 
	IMPLICIT NONE
	CHARACTER(*)::str
	LOGICAL::TF
		TF=is_real_c_(str)
	END FUNCTION

	FUNCTION is_letter(str) RESULT(TF)
	IMPLICIT NONE
	CHARACTER(*)::str
	LOGICAL::TF
		TF=is_letter_c_(str)
	END FUNCTION

	FUNCTION is_word(str) RESULT(TF)
	IMPLICIT NONE
	CHARACTER(*)::str
	LOGICAL::TF
		TF=is_word_c_(str)
	END FUNCTION

!++++++++++++++++++++++++++++++++++++++++++++++++++
!				Private Utils
!++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION CF_STRING(c_str) RESULT(f_str)
	USE ISO_C_BINDING, ONLY: C_PTR, C_F_POINTER, C_CHAR
	TYPE(C_PTR), TARGET,INTENT(IN) :: c_str
	CHARACTER(:,KIND=C_CHAR), POINTER :: f_str
	CHARACTER(:,KIND=C_CHAR), POINTER :: arr(:)
	INTERFACE
		FUNCTION strlen(s) BIND(C, NAME='strlen')!C Library Function
			USE, INTRINSIC :: ISO_C_BINDING, ONLY: C_PTR, C_SIZE_T
			IMPLICIT NONE
			TYPE(C_PTR), INTENT(IN), VALUE :: s
			INTEGER(C_SIZE_T) :: strlen
		END FUNCTION strlen
	END INTERFACE
	CALL C_F_POINTER(c_str, arr, [strlen(c_str)])
	CALL scalar_pointer(SIZE(arr), arr, f_str)
END FUNCTION 

SUBROUTINE scalar_pointer(scalar_len, scalar, fptr)
	USE ISO_C_BINDING, ONLY: C_CHAR
	INTEGER, INTENT(IN) :: scalar_len
	CHARACTER(KIND=C_CHAR,LEN=scalar_len), INTENT(IN), TARGET :: scalar(1)
	CHARACTER(:,KIND=C_CHAR), INTENT(OUT), POINTER :: fptr
	fptr => scalar(1)
END SUBROUTINE

END MODULE