#in order to compile i changed shogi.jl, board array to board1
#and database.jl with some testcases.
include("database.jl")

replay_type = get_gameType(filename)

if (replay_type =="standard")
  include("move_functions_check.jl")
include("shogi.jl")
else
  include("move_functions_minishogi_check.jl")

  include("minishogi.jl")
end
function validate_red_moves(GB,red_pieces, black_pieces, piece, target_cords)
  println(piece[1])
  if piece[1] == 'p'
  return move_red_p(GB,red_pieces, black_pieces, piece, target_cords)
  elseif piece[1] == 'g'
  return move_red_g(GB,red_pieces, black_pieces, piece, target_cords)
  elseif piece[1] == 'k'
  return move_king(GB,red_pieces, black_pieces, piece, target_cords)
  elseif piece[1] == 'r'
  return move_rook(GB,red_pieces, black_pieces, piece, target_cords)
  elseif piece[1] == 'n'
  return move_red_n(GB,red_pieces, black_pieces, piece, target_cords)
  elseif piece[1] == 'b'
  return move_bishop(GB,red_pieces, black_pieces, piece, target_cords)
  elseif piece[1] == 's'
  return move_red_s(GB,red_pieces, black_pieces, piece, target_cords)
  elseif piece[1] == 'l'
  return move_lancerR(GB,red_pieces, black_pieces, piece, target_cords)
end
end

function validate_black_moves(GB,black_pieces, red_pieces, piece, target_cords)
  println(piece[1])
  if piece[1] == 'p'
  return move_black_p(GB,black_pieces,red_pieces, piece,target_cords)
  elseif piece[1] == 'g'
  return move_black_g(GB,black_pieces, red_pieces, piece, target_cords)
  elseif piece[1] == 'k'
  return move_king(GB,black_pieces, red_pieces, piece, target_cords)
  elseif piece[1] == 'r'
  return move_rook(GB,black_pieces, red_pieces, piece, target_cords)
  elseif piece[1] == 'n'
  return move_black_n(GB,black_pieces, red_pieces, piece, target_cords)
  elseif piece[1] == 'b'
  return move_bishop(GB,black_pieces, red_pieces, piece, target_cords)
elseif piece[1] == 's'
  return move_black_s(GB,black_pieces, red_pieces, piece, target_cords)
  #some issues with the lancer not moving
elseif piece[1] == 'l'
  return move_lancerB(GB,black_pieces, red_pieces, piece, target_cords)
end
end
#depending on the files it will use mini shogi or shogi.

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


function check_win_white(white_piece::Pieces)

  i = 1
  number_captured = length(white_piece.captured)
  while i<=number_captured
    #check if cheat.

    if white_piece.captured[i] == "k"
      println("W")
      return true
    end
    i = i+1
  end
  end
  function check_win_black(black_piece::Pieces)

    i = 1

    number_captured = length(black_piece.captured)
    while (i<=number_captured)

      if black_piece.captured[i] == "k"
        println("B")
        return true
      end
      i = i+1
    end
    end



#length is the total number of moves.
total_moves = get_totalMoves(filename)


#error when getting the length
function replay_game(length,red,black)
   i = 1

   println("?")

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
        # check if cheat.

        piece = red_pieces.activeS[(source_cords)]
        move_Type = get_moveType(filename,i)
        if (move_Type == "resign")
            println("r")
           return


         elseif (validate_red_moves(GB,red_pieces,black_pieces,piece,target_cords) == 5)
                 println("cheat")
                 return


          elseif (check_win_white(red_pieces)==true)
              return
              end

      else

        piece = black_pieces.activeS[(source_cords)]
        move_Type = get_moveType(filename,i)
        if move_Type == "resign"
        println("R")
        return

        elseif (validate_black_moves(GB,black_pieces,red_pieces,piece,target_cords)==5)
        #moves the piece
            println("cheat")
            return

         elseif (check_win_black(black_pieces)==true)
          return


      end
    end
     display_board(GB,red_pieces,black_pieces)
     i = i+1

     if i == total_moves
       println("D")
     end
     println("?")
     #println("i ",i)
     #the time
   end
end
replay_game(total_moves,red_pieces,black_pieces)
