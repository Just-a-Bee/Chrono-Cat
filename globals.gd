extends Node

# settings vars
var ARR = .3
var DAS = .4

# progress related vars
var rewind_unlocked:bool = false

# state vars
var state:int = STATES.TITLE
enum STATES
{
	TITLE = 0,
	SELECT = 1,
	LEVEL = 2
}


