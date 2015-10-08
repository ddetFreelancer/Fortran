// rgxFortran:Regular Expression Procedures that are meant to be boolean//logical functions in rgxFortran 
/*
TODO:
1) Implement Mathematical Opereators as REs
2) Test for Memory Leaks
*/

#include <regex>
#include <string>


using namespace std;
string fstr(char* fs){return string(fs);}
regex *fexp(char* fs){return new regex(fs);}

//////////////////////////////////////////////////////////////
//		Some Premade Paterns for Unbound Calls
//////////////////////////////////////////////////////////////
	regex integer("(\\+|-)?[[:digit:]]+");
	regex real("((\\+|-)?[[:digit:]]+)(\\.(([[:digit:]]+)?))?");
	regex letter("[[:alpha:]]");
	regex word("[[:alpha:]]+");

//////////////////////////////////////////////////////////////
//				Unbound matching
//////////////////////////////////////////////////////////////
extern "C"
{
	bool _is_match_sta(char* frgx,char* fs) {return regex_match(fstr(fs),regex(frgx));} // object for matching
	bool _is_integer_sta(char* fs)			{return regex_match(fstr(fs),integer);}		//premade expression for integer
	bool _is_real_c_sta(char* fs)			{return regex_match(fstr(fs),real);}		//premade expression for real
	bool _is_letter_sta(char* fs)			{return regex_match(fstr(fs),letter);}		//premade expression for letter
	bool _is_word_sta(char* fs)				{return regex_match(fstr(fs),word);}		//premade expression for word
}