using DataArrays, DataFrames
using SQLite

#init database. for start.jl only
function init_database(f::AbstractString)
	db=SQLite.DB("$(f).db")

# create metaTable data table
	SQLite.query(db,"create table metaTable (key text primary key, value text)")
	SQLite.query(db,"insert into metaTable values('type',NULL)")
	SQLite.query(db,"insert into metaTable values('legality',NULL)")
	SQLite.query(db,"insert into metaTable values('seed',NULL)")
	println("\nmetaTable set.")

# create movesTable data table
	SQLite.query(db,"create table movesTable (move_number integer primary key,
																							move_type text,
																							sourcex integer,
																							sourcey integer,
																							targetx integer,
																							targety integer,
																							option text,
																							i_am_cheating integer)")
	println("\nmovesTable set.")
end

###################################################################################################
## SET META TABLE

function set_gameType(f::ASCIIString,gt::ASCIIString)
	db = SQLite.DB("$(f).db")
	query = "update metaTable set value = '$(gt)' where key = 'type'"
	#println(query)
	SQLite.query(db,query)
end

function set_legality(f::ASCIIString,l::ASCIIString)
	db = SQLite.DB("$(f).db")
	query = "update metaTable set value = '$(l)' where key = 'legality'"
	#println(query)
	SQLite.query(db,query)
end

function set_seed(f::ASCIIString,s::Int)
	db = SQLite.DB("$(f).db")
	query = "update metaTable set value = '$(s)' where key = 'seed'"
	df = SQLite.query(db,query)
end

#---------------------------------------------------------------------------------------------------
## SET MOVES TABLE
#insert new row
#input: str filename, str movetype,int sx,sy,tx,ty, int promo,cheat,str dropped piece
function set_move(f::ASCIIString,
									mType::AbstractString,
									sx::Int,sy::Int,tx::Int,ty::Int,
									promo::Int,cheat::Int, # insert int 1 if the piece is promoted. same with cheat move
									droppedPiece::AbstractString) # insert "" if the move is not a drop move
	db = SQLite.DB("$(f).db")
	mNum = get_totalMoves(f) + 1
	query_mNum = "insert into movesTable (move_number) values($(mNum))"
	SQLite.query(db,query_mNum) #update number of moves

	query_mType = "update movesTable set move_type = '$(mType)' where move_number = $(mNum)"
	SQLite.query(db,query_mType) #update move_type

	query_sx = "update movesTable set sourcex = $(sx) where move_number = $(mNum)"
	SQLite.query(db,query_sx) #update source x cord

	query_sy = "update movesTable set sourcey = $(sy) where move_number = $(mNum)"
	SQLite.query(db,query_sy) #update source y cord

	query_tx = "update movesTable set targetx = $(tx) where move_number = $(mNum)"
	SQLite.query(db,query_tx) #update target x cord

	query_ty = "update movesTable set targety = $(ty) where move_number = $(mNum)"
	SQLite.query(db,query_ty) #update target y cord

	# update option column
	# option <- "!"  when there's a promotion
	# option <- piece name when moveType is 'drop'
	# a dropped piece is unpromoted
	if promo == 1
		query_opt = "update movesTable set option = '!' where move_number = $(mNum)"
	elseif mType == "drop"
	  query_opt = "update movesTable set option = '$(droppedPiece)' where move_number = $(mNum)"
	else
		query_opt = "update movesTable set option = NULL where move_number = $(mNum)"
	end
	SQLite.query(db,query_opt)

	# update cheat
	if cheat == 1
		query_cheat = "update movesTable set i_am_cheating = 'yes' where move_number = $(mNum)"
	else
		query_cheat = "update movesTable set i_am_cheating = NULL where move_number = $(mNum)"
	end
	SQLite.query(db,query_cheat)
end


###################################################################################################
####EXTRACT VALUES FROM TABLES

#input:filename, table name. return the whole table, type dataframe
function get_table(f::ASCIIString,t::AbstractString) # the return type is DataFrame, treat it like a multi-dim array
	db = SQLite.DB("$(f).db")
	if t == "meta"									# https://dataframesjl.readthedocs.io/en/latest/
		df = SQLite.query(db,"select * from metaTable")
	else
		df = SQLite.query(db,"select * from movesTable")
	end
	return df
end

#---------------------------------------------------------------------------------------------------
## GET VALUES FROM META TABLE
#input: filename. return string game type
function get_gameType(f::ASCIIString)
	db = SQLite.DB("$(f).db")
	query = "SELECT value FROM metaTable where key = 'type'"
	df = SQLite.query(db,query)
	isnull(df[1,1]) == true ? (return "empty") : (return get(df[1,1]))
end


function ischeatGame(f::ASCIIString)
	db = SQLite.DB("$(f).db")
	query = "SELECT value FROM metaTable where key = 'legality'"
	df = SQLite.query(db,query)
	isnull(df[1,1]) == true ? (return "empty") : (l = get(df[1,1]))
	l == "cheating" ? (return true) : (return false)
end

#input: filename. return string legality
function get_legality(f::ASCIIString)
	db = SQLite.DB("$(f).db")
	query = "SELECT value FROM metaTable where key = 'legality'"
	df = SQLite.query(db,query)
	isnull(df[1,1]) == true ? (return "empty") : (return get(df[1,1]))
end
#input: filename. return int seed
function get_seed(f::ASCIIString)
	db = SQLite.DB("$(f).db")
	query = "SELECT value FROM metaTable where key = 'seed'"
	df = SQLite.query(db,query)
	isnull(df[1,1]) == true ? (return 0) : (return parse(get(df[1,1])))
end

#---------------------------------------------------------------------------------------------------
## GET VALUES FROM MOVES TABLE

#input:filename, move number. return details of a row in a DataArray type. moveDetail(4)
function get_row(f::ASCIIString,mNum::Int)
	df = get_table(f,"moves")
	dv = @data([NA,NA,NA,NA,NA,NA,NA,NA])
	for i in 1:8
			dv[i] = df[mNum,i]
	end
	return dv
end
#input: filename. return an int total rows/moves in the movesTable
function get_totalMoves(f::ASCIIString)
	db = SQLite.DB("$(f).db")
	query = "SELECT Count(*) FROM movesTable"
	df = SQLite.query(db, query)
	return get(df[1,1])
end
#input:filename, move number. return a string move type at a specific move_num
function get_moveType(f::ASCIIString,mNum::Int)
	db = SQLite.DB("$(f).db")
	query = "SELECT move_type FROM movesTable where move_number = $(mNum)"
	df = SQLite.query(db, query)
	return get(df[1,1])
end

#input:filename, move number. return a tuple source coord at a specific move_num
function get_sourceCords(f::ASCIIString,mNum::Int)
	db = SQLite.DB("$(f).db")
	query_getSourcex = "SELECT sourcex FROM movesTable where move_number = $(mNum)"
	query_getSourcey = "SELECT sourcey FROM movesTable where move_number = $(mNum)"
	dfx = SQLite.query(db, query_getSourcex)
	dfy = SQLite.query(db, query_getSourcey)

	x = get(dfx[1,1])
	y = get(dfy[1,1])
	cords =(x,y)
	return cords
end

#input:filename, move number. return a tuple target coord at a specific move_num
function get_targetCords(f::ASCIIString,mNum::Int)
	db = SQLite.DB("$(f).db")
	query_getTargetx = "SELECT targetx FROM movesTable where move_number = $(mNum)"
	query_getTargety = "SELECT targety FROM movesTable where move_number = $(mNum)"
	dfx = SQLite.query(db, query_getTargetx)
	dfy = SQLite.query(db, query_getTargety)

	x = get(dfx[1,1])
	y = get(dfy[1,1])
	cords =(x,y)
	return cords
end
#input:filename, move number. return bool if cheating at a specific move_num
function ischeatMove(f::ASCIIString,mNum::Int)
	db = SQLite.DB("$(f).db")
	query = "SELECT i_am_cheating FROM movesTable where move_number = $(mNum)"
	df = SQLite.query(db, query)
	isnull(df[1,1]) == true ? (return false) : (return true)
end

#input:filename, move number. return bool if a piece is promoted at a specific move_num
function ispromoted(f::ASCIIString,mNum::Int)
	db = SQLite.DB("$(f).db")
	query = "SELECT option FROM movesTable where move_number = $(mNum)"
	df = SQLite.query(db, query)
	isnull(df[1,1]) == true || get(df[1,1]) != "!"? (return false) : (return true)
end

#input:filename, move number. return bool if a piece is dropped at a specific move_num
function isdropped(f::ASCIIString,mNum::Int)
	db = SQLite.DB("$(f).db")
	query = "SELECT option FROM movesTable where move_number = $(mNum)"
	df = SQLite.query(db, query)
	isnull(df[1,1]) == true || get(df[1,1]) == "!" ? (return false) : (return true)
end
#input:filename, move number. return string piece name of the dropped piece at a specific move_num
function get_droppedPiece(f::ASCIIString,mNum::Int)
	db = SQLite.DB("$(f).db")
	query = "SELECT option FROM movesTable where move_number = $(mNum)"
	df = SQLite.query(db, query)
	isdropped(f,mNum) == true? ( return get( df[1,1] ) ) : (return "")
end



#---------------------------------------------------------------------------------------
##TESTS
filename = "game1"
init_database(filename)
#test movesTable
# set_move(filename,"move",3,5,3,4,0,0,"")
# set_move(filename,"move",3,1,3,2,0,0,"")
# set_move(filename,"move",3,4,3,3,0,0,"")
# #
# set_move(filename,"move",1,3,1,4,0,0,"")#red
# set_move(filename,"move",8,7,8,6,0,0,"")#black
# set_move(filename,"move",3,3,3,4,0,0,"")#red
# set_move(filename,"move",3,7,3,6,0,0,"")#black
# set_move(filename,"move",8,3,8,4,0,0,"")#red
#
# set_move(filename,"move",1,7,1,6,0,0,"")#black
# set_move(filename,"move",5,1,5,2,0,0,"")#red
#
# set_move(filename,"move",1,6,1,5,0,0,"")#black
# set_move(filename,"move",1,4,1,5,0,0,"")#red
# set_move(filename,"move",8,6,8,5,0,0,"")#black
# set_move(filename,"move",1,5,1,6,0,0,"")#red
# set_move(filename,"move",1,9,1,6,0,0,"")#black
# set_move(filename,"move",1,1,1,6,0,0,"")#red
# set_move(filename,"move",8,8,4,8,0,0,"")#black
# set_move(filename,"move",3,1,3,2,0,0,"")#red
# set_move(filename,"move",8,9,6,8,0,0,"")#black
# set_move(filename,"move",7,3,7,4,0,0,"")#black
# set_move(filename,"move",7,9,7,8,0,0,"")#black
# set_move(filename,"move",8,1,7,3,0,0,"")#black
#

set_move(filename,"move",8,7,8,6,0,0,"")#black
set_move(filename,"move",1,3,1,4,0,0,"")#red

set_move(filename,"move",3,7,3,6,0,0,"")#black
set_move(filename,"move",3,3,3,4,0,0,"")#red


set_move(filename,"move",1,7,1,6,0,0,"")#black
set_move(filename,"move",8,3,8,4,0,0,"")#red


set_move(filename,"move",1,6,1,5,0,0,"")#black
set_move(filename,"move",5,1,5,2,0,0,"")#red

set_move(filename,"move",8,6,8,5,0,0,"")#black
set_move(filename,"move",1,4,1,5,0,0,"")#red

set_move(filename,"move",1,9,1,6,0,0,"")#black
set_move(filename,"move",1,5,1,6,0,0,"")#red

set_move(filename,"move",8,8,4,8,0,0,"")#black
set_move(filename,"move",1,1,1,5,0,0,"")#red

set_move(filename,"move",8,9,6,8,0,0,"")#black
set_move(filename,"move",3,1,3,2,0,0,"")#red

set_move(filename,"move",7,9,7,8,0,0,"")#black

#set_move(filename,"move",8,1,7,3,0,0,"")#black

# #test metaTable
set_gameType(filename,"standard")
set_legality(filename,"legal")

# # #test table extraction
df1 = get_table(filename,"meta")
df2 = get_table(filename,"moves") #df stands for dataframe
println(df1)
println(df2)

# #Test get functions
# total = get_totalMoves(filename)
# println("Total number of moves is $total")
# mt = get_moveType(filename,3)
# println("Move type at move 3 is $mt")
# sCords = get_sourceCords(filename,3)
# println("sCords at move 3 is $sCords")
# tCords = get_targetCords(filename,3)
# println("tCords at move 3 is $tCords")
# ischeating(filename,3) == true ? println("At move 3 I am cheating"): println("At move 3 i am not cheating")

# #
# #test row and value extraction
 # println("\nDetails of move 4 is:")
# #
#arr = get_row(filename,4)

#println(arr)
#println("Type of move 4 array is $(typeof(arr))") # we use DataArray type because it's multi-type
#println("Cheating is $(get(arr[8]))")
#println("Cheating is $(arr[8])")

# # values are nullable => need to use get(df1[1,2])
# println()
# println("Before using get() type is $(typeof(df1[1,2]))") #row1,col2 of df1 is game type
# println("After using get() type is $(typeof(get(df1[1,2])))")
# println("If value is NULL don't use get()")
# println("Game type is $(get(df1[1,2]))")
