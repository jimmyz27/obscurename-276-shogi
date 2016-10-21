#load sudo data into a database
# replay the moves using shogi.jl
# using preexisting data base files.
#use a while to go throught play.jl and display all the filesize
#pass in arguent for file name
#call the shogi file for function moves.
include("shogi.jl")
include("database.jl")


#extract from database first command

function get_name_of_piece()

end

red_pieces = Pieces("red")
black_pieces = Pieces("black")
GB = Board()

#length is the total number of moves.


function run_from_Start(length,red,black)
   i = 1
   fill_red(red)
   fill_black(black)
   init_board(GB,red,black)
   while(i<=length)
     #get the 2nd argument from the target coordinate

     source_cords = get_sourceCords(filename,i)
     target_cords = get_targetCords(filename,i)
     print("source",source_cords)
     print("target",target_cords)

    #   if(i%2==0)
     piece = red_pieces.activeS[(source_cords)]
    #  else
    #    piece = black_pieces.activeS[(target_cords)]
    #  end

     move_piece(GB,red_pieces,black_pieces,piece,target_cords)
     display_board(GB,red_pieces,black_pieces)
     i = i+1
     #the time
   end

end
run_from_Start(2,red_pieces,black_pieces)
