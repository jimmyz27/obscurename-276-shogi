#in order to compile i changed shogi.jl, board array to board1
#and database.jl with some testcases.

replay_type = get_gameType()

if (replay_type =="standard")
include("shogi.jl")
else
  include("minishogi.jl")
end
#depending on the files it will use mini shogi or shogi.
include("database.jl")
#filename = input()
#extract from database first command
#todo start from minishogi.jl
red_pieces = Pieces("red")
black_pieces = Pieces("black")

GB = Board()
fill_red(red_pieces)
println()
fill_black(black_pieces)
init_board(GB,red_pieces,black_pieces)
#length is the total number of moves.
total_moves = get_totalMoves(filename)


#error when getting the length
function replay_game(length,red,black)
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
      if i%2==0
        piece = red_pieces.activeS[(source_cords)]
        move_piece(GB,red_pieces,black_pieces,piece,target_cords)

      else
        piece = black_pieces.activeS[(source_cords)]
        move_piece(GB,black_pieces,red_pieces,piece,target_cords)
        #moves the piece

        println("piece is",piece)
      end
     display_board(GB,red_pieces,black_pieces)
     i = i+1
     #println("i ",i)
     #the time
   end
end
replay_game(total_moves,red_pieces,black_pieces)
