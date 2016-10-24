#valiadate standard shogi is done.
#validate, mini shogi,
# win.jl for both aswell.
include("shogi.jl")
include("database.jl")


println("what type of shogi do you wish to validate standard:S, or mini:M")
game_type = input()

include("move_functions.jl")
include("shogi.jl")

#only validating for Standard shogi.
#
red_pieces = Pieces("red")
black_pieces = Pieces("black")
GB = Board()
fill_red(red_pieces)
fill_black(black_pieces)
init_board(GB,red_pieces,black_pieces)
#todo: find out who is red and who is black.
#include all the functions of move_functions.
#then check all the pieces.
# try first with read pawns.
      #todo::
      #for each piece copy the move and copy shermans code for each piece.
      #either check if move is
      #depending
      #king
      #rook
      #pawn... ect.....


      function validate_red_moves(GB,red_pieces, black_pieces, piece, target_cords)
        println(piece[1])
        if piece[1] == 'p'
        move_red_p(GB,red_pieces, black_pieces, piece, target_cords)
        elseif piece[1] == 'g'
        move_red_g(GB,red_pieces, black_pieces, piece, target_cords)
        elseif piece[1] == 'k'
        move_king(GB,red_pieces, black_pieces, piece, target_cords)
        elseif piece[1] == 'r'
        move_rook(GB,red_pieces, black_pieces, piece, target_cords)
        elseif piece[1] == 'n'
        move_red_n(GB,red_pieces, black_pieces, piece, target_cords)
        elseif piece[1] == 'b'
        move_bishop(GB,red_pieces, black_pieces, piece, target_cords)
        elseif piece[1] == 's'
        move_red_s(GB,red_pieces, black_pieces, piece, target_cords)
        elseif piece[1] == 'l'
        move_lancerR(GB,red_pieces, black_pieces, piece, target_cords)
      end
      end

      function validate_black_moves(GB,black_pieces, red_pieces, piece, target_cords)
        println(piece[1])
        if piece[1] == 'p'
        move_black_p(GB,black_pieces,red_pieces, piece,target_cords)
        elseif piece[1] == 'g'
        move_black_g(GB,black_pieces, red_pieces, piece, target_cords)
        elseif piece[1] == 'k'
        move_king(GB,black_pieces, red_pieces, piece, target_cords)
        elseif piece[1] == 'r'
        move_rook(GB,black_pieces, red_pieces, piece, target_cords)
        elseif piece[1] == 'n'
        move_black_n(GB,black_pieces, red_pieces, piece, target_cords)
        elseif piece[1] == 'b'
        move_bishop(GB,black_pieces, red_pieces, piece, target_cords)
      elseif piece[1] == 's'
        move_black_s(GB,black_pieces, red_pieces, piece, target_cords)
        #some issues with the lancer not moving
      elseif piece[1] == 'l'
        move_lancerB(GB,black_pieces, red_pieces, piece, target_cords)
      end
      end
function check_Valid_Replay(length)
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
       println("red piece ",piece)
       validate_red_moves(GB,red_pieces,black_pieces,piece,target_cords)
     else
       piece = black_pieces.activeS[(source_cords)]
       println("black piece ",piece)
       validate_black_moves(GB,black_pieces,red_pieces,piece,target_cords)
       #moves the piece
     end


    display_board(GB,red_pieces,black_pieces)
    i = i+1
    #println("i ",i)
 end
end

check_Valid_Replay(19)
