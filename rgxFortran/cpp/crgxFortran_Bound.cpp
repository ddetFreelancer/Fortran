// rgxFortran:Regular Expression Procedures to be Bound to Fortran Derived Type 'rgx' 
/*
TODO:
1) Implement Regex Enum Flags
2) Implement Regex Itterators
3) Add Regex Substitution
4) Add Regex Search
*/

#include <regex>
#include <string>
using namespace std;

string fstr(char* fs);//prototype for simple shortcut char*=>string

class cfrgx{// a class to anchor to with our regex
public:
regex regx;							     //regex object//
cmatch regx_matchgrp;			   //match_group object//
cfrgx(char* frgx){regx=regex(frgx); }//class constructor/
bool cfrgx::_is_match_(char* fs){return regex_match(fs,regx_matchgrp,regx);}//match exp//
cmatch *cfrgx::_get_match_group_(void){return &regx_matchgrp;}//match group//
~cfrgx(){}};//Class Deconstructor//


//Wrappers to Our Class Functions//
extern "C"{//ALWAYS DECLARE ' extern "C" ' when we want to use with fortran
	cfrgx *_new_rgx_(char* s){return new cfrgx(s);}//create instance of wrapper class
	void _delete_rgx_(cfrgx& c){c.~cfrgx();};//delete instance of wrapper class
	bool _match_rgx_(cfrgx& c,char* s){return c._is_match_(s);}//match
	cmatch* _group_rgx_(cfrgx& c){return c._get_match_group_();}//return pointer of match group
	bool _group_ready_rgx_(cmatch& grp){return grp.ready();}//check if group has been initialized
	bool _group_empty_rgx_(cmatch& grp){return grp.empty();}//check if group is empty
	int _group_size_rgx_(cmatch& grp){return grp.size();}//return group size
	char* _group_str_rgx_(cmatch& grp,int i){ //return selected match group
		string str=grp.str(i);
		char* cstr=new char[str.length()+1];
		strcpy(cstr,str.c_str());
		return cstr;
	}	
	int _group_length_rgx_(cmatch& grp,int i){return grp.length(i);}//the string length of selected match group
	int _group_pos_rgx_(cmatch& grp,int i){return grp.position(i);}//the starting position in the string of the match
}






