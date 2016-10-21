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
fill_red(red_pieces)
println()
fill_black(black_pieces)
init_board(GB,red_pieces,black_pieces)
#length is the total number of moves.


function run_from_Start(length,red,black)
   i = 1

   while(i<=length)
     #get the 2nd argument from the target coordinate
     #moves the pieces inversed
     #only moves the red pieces.
     source_cords = get_sourceCords(filename,i)
     target_cords = get_targetCords(filename,i)
     println("source",source_cords)
     println("target",target_cords)
     println("i ",i%2)
      if i%2==1
        piece = red_pieces.activeS[(source_cords)]
        move_piece(GB,red_pieces,black_pieces,piece,target_cords)
      else
        piece = black_pieces.activeS[(source_cords)]
        move_piece(GB,black_pieces,red_pieces,piece,target_cords)
        println("piece is",piece)
      end

     display_board(GB,red_pieces,black_pieces)
     i = i+1
     #println("i ",i)
     #the time
   end

end
run_from_Start(7,red_pieces,black_pieces)
