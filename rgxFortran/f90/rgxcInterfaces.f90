MODULE rgxc_Interfaces
USE ISO_C_BINDING,ONLY:C_BOOL,C_PTR
!!#define loc(x) transfer(c_loc(x),0_C_INTPTR_T)
IMPLICIT NONE
!++++++++++++++++++++++++++++++++++++++++++++++++++
!				Unbound Procedures
!++++++++++++++++++++++++++++++++++++++++++++++++++
!**************************************************
!		Check if string matches user regexp
!==================================================
INTERFACE 
	FUNCTION is_match_c_(cfrgx,cfs) RESULT(TF)
	!DEC$ ATTRIBUTES STDCALL,ALIAS:'_is_match_sta'::is_match_c_
		USE ISO_C_BINDING,ONLY:C_BOOL
		!DEC$ ATTRIBUTES REFERENCE::cfrgx
		CHARACTER(*)::cfrgx
		!DEC$ ATTRIBUTES REFERENCE::cfs
		CHARACTER(*)::cfs
		INTEGER(C_BOOL)::TF
	END FUNCTION
END INTERFACE
!--------------------------------------------------
!**************************************************
!			Check if string is integer
!==================================================
INTERFACE
	FUNCTION is_integer_c_(cfs)  RESULT(TF) 
	!DEC$ ATTRIBUTES STDCALL,ALIAS:'_is_integer_sta'::is_integer_c_
		USE ISO_C_BINDING,ONLY:C_BOOL
		!DEC$ ATTRIBUTES REFERENCE::cfs
		CHARACTER(*)::cfs
		INTEGER(C_BOOL)::TF
	END FUNCTION
END INTERFACE
!--------------------------------------------------
!**************************************************
!			Check if string is real number
!==================================================
INTERFACE 
	FUNCTION is_real_c_(cfs) RESULT(TF)
	!DEC$ ATTRIBUTES STDCALL,ALIAS:'_is_real_c_sta'::is_real_c_
		USE ISO_C_BINDING,ONLY:C_BOOL
		!DEC$ ATTRIBUTES REFERENCE::cfs
		CHARACTER(*)::cfs
		INTEGER(C_BOOL)::TF
	END FUNCTION
END INTERFACE
!--------------------------------------------------
!**************************************************
!		Check if string is single letter
!==================================================
INTERFACE 
	FUNCTION is_letter_c_(cfs)  RESULT(TF) 
	!DEC$ ATTRIBUTES STDCALL,ALIAS:'_is_letter_sta'::is_letter_c_
		USE ISO_C_BINDING,ONLY:C_BOOL
		!DEC$ ATTRIBUTES REFERENCE::cfs
		CHARACTER(*)::cfs
		INTEGER(C_BOOL)::TF
	END FUNCTION
END INTERFACE
!--------------------------------------------------
!**************************************************
!			Check if string is word
!==================================================
INTERFACE 
	FUNCTION is_word_c_(cfs)  RESULT(TF)
	!DEC$ ATTRIBUTES STDCALL,ALIAS:'_is_word_sta'::is_word_c_
		USE ISO_C_BINDING,ONLY:C_BOOL
		!DEC$ ATTRIBUTES REFERENCE::cfs
		CHARACTER(*)::cfs
		INTEGER(C_BOOL)::TF
	END FUNCTION
END INTERFACE
!--------------------------------------------------


!++++++++++++++++++++++++++++++++++++++++++++++++++
!==================================================
!++++++++++++++++++++++++++++++++++++++++++++++++++

!--------------------------------------------------
!				 Bound Procedures
!++++++++++++++++++++++++++++++++++++++++++++++++++

!**************************************************
!		Create Regular Expression Object
!==================================================
INTERFACE
	FUNCTION c_new_rgx_(cstr) Result(rgx_p)
	!DEC$ ATTRIBUTES STDCALL,ALIAS:'_new_rgx_'::c_new_rgx_
		USE ISO_C_BINDING,ONLY:c_ptr
		IMPLICIT NONE
		!DEC$ ATTRIBUTES REFERENCE::cstr
		CHARACTER(*)::cstr
		TYPE(c_ptr)::rgx_p
	END FUNCTION
END INTERFACE

!**************************************************
!		 Delete Regular Expression Object
!==================================================
INTERFACE
	SUBROUTINE c_delete_rgx_(rgx_p)
	!DEC$ ATTRIBUTES STDCALL,ALIAS:'_delete_rgx_'::c_delete_rgx_
		USE ISO_C_BINDING,ONLY:c_ptr
		IMPLICIT NONE
		TYPE(c_ptr)::rgx_p
	END SUBROUTINE
END INTERFACE

!**************************************************
!			 Match Regular Expression 
!==================================================
INTERFACE
	FUNCTION c_match_rgx_(rgx_p,cstr) Result(TF)
	!DEC$ ATTRIBUTES STDCALL,ALIAS:'_match_rgx_'::c_match_rgx_
		USE ISO_C_BINDING,ONLY:c_ptr,C_BOOL
		IMPLICIT NONE
		TYPE(c_ptr)::rgx_p
		!DEC$ ATTRIBUTES REFERENCE::cstr
		CHARACTER(*)::cstr
		INTEGER(C_BOOL)::TF
	END FUNCTION
END INTERFACE

!**************************************************
!			Create Group Object
!==================================================
INTERFACE
	FUNCTION c_group_rgx_(rgx_p) Result(grp_p)
	!DEC$ ATTRIBUTES STDCALL,ALIAS:'_group_rgx_'::c_group_rgx_
		USE ISO_C_BINDING,ONLY:c_ptr
		IMPLICIT NONE
		TYPE(c_ptr)::rgx_p
		TYPE(c_ptr)::grp_p
	END FUNCTION
END INTERFACE

!**************************************************
!			Check Group Object
!==================================================
INTERFACE
	FUNCTION c_group_ready_rgx_(grp_p) Result(TF)
	!DEC$ ATTRIBUTES STDCALL,ALIAS:'_group_ready_rgx_'::c_group_ready_rgx_
		USE ISO_C_BINDING,ONLY:c_ptr,c_bool
		IMPLICIT NONE
		TYPE(c_ptr)::grp_p
		INTEGER(C_BOOL)::TF
	END FUNCTION
END INTERFACE

!**************************************************
!			Check Empty Group Object
!==================================================
INTERFACE
	FUNCTION c_group_empty_rgx_(grp_p) Result(TF)
	!DEC$ ATTRIBUTES STDCALL,ALIAS:'_group_empty_rgx_'::c_group_empty_rgx_
		USE ISO_C_BINDING,ONLY:c_ptr,c_bool
		IMPLICIT NONE
		TYPE(c_ptr)::grp_p
		INTEGER(C_BOOL)::TF
	END FUNCTION
END INTERFACE

!**************************************************
!				Check Group Size
!==================================================
INTERFACE
	FUNCTION c_group_size_rgx_(grp_p) Result(g_size)
	!DEC$ ATTRIBUTES STDCALL,ALIAS:'_group_size_rgx_'::c_group_size_rgx_
		USE ISO_C_BINDING,ONLY:c_ptr
		IMPLICIT NONE
		TYPE(c_ptr)::grp_p
		INTEGER::g_size
	END FUNCTION
END INTERFACE

!**************************************************
!				Get Group String
!==================================================
INTERFACE
	FUNCTION c_group_str_rgx_(grp_p,pos) Result(cstr) !BIND(C,NAME='_group_str_rgx_')
	!DEC$ ATTRIBUTES STDCALL,ALIAS:'_group_str_rgx_'::c_group_str_rgx_
		USE ISO_C_BINDING,ONLY:c_ptr
		IMPLICIT NONE
		TYPE(c_ptr)::grp_p
		INTEGER::pos
		TYPE(c_ptr)::cstr
	END FUNCTION
END INTERFACE

!**************************************************
!			  Get Group String Length
!==================================================
INTERFACE
	FUNCTION c_group_length_rgx_(grp_p,pos) Result(strLength)
	!DEC$ ATTRIBUTES STDCALL,ALIAS:'_group_length_rgx_'::c_group_length_rgx_
		USE ISO_C_BINDING,ONLY:c_ptr
		IMPLICIT NONE
		TYPE(c_ptr)::grp_p
		INTEGER::pos
		INTEGER::strLength
	END FUNCTION
END INTERFACE

!**************************************************
!			  Get Group Match Pos
!==================================================
INTERFACE
	FUNCTION c_group_pos_rgx_(grp_p,indx) Result(pos)
	!DEC$ ATTRIBUTES STDCALL,ALIAS:'_group_pos_rgx_'::c_group_pos_rgx_
		USE ISO_C_BINDING,ONLY:c_ptr
		IMPLICIT NONE
		TYPE(c_ptr)::grp_p
		INTEGER::indx
		INTEGER::pos
	END FUNCTION
END INTERFACE

END MODULE