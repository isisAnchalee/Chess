require_relative 'board'

board = Board.new

board.move_piece([0,4], [4, 4])
board.move_piece([7,7],[5,7])
board.move_piece([7,0],[4,0])
board.move_piece([7,3],[3,7])
board.display_board
p board.check_mate?(:black)

f2, f3
e7, e5
g2, g4
d8, h4

f6,f5
e1,e3
g6,g4
d0,h4




#board.move_piece([0,1], [2, 0])
# board.move_piece([7, 1], [5, 2])
# board.move_piece([5,2],[4,4])
# board.move_piece([4, 4], [2, 5])
# board.move_piece([2,5],[4,6])
#board.move_piece([2, 0],[1, 2])
#board.move_piece([1, 2],[2, 4])
# board.move_piece([5,2],[4,4])

# board.move_piece([1, 2], [2, 2])
# board.move_piece([2, 2], [3, 2])
# board.move_piece([3, 2], [4, 2])
# board.move_piece([4, 2], [5, 2])
# board.move_piece([6,3], [5, 3])
# board.move_piece([6,1],[5,2])
# board.move_piece([5,2],[4,2])
# p board[[6, 2]].possible_valid_moves

