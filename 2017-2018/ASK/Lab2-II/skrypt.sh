echo 'BLOCK 4'

for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17
	do
		./matmult -n $(($i*64)) -v 3
		./matmult -n $(($i*64)) -v 3
		./matmult -n $(($i*64)) -v 3
	done 
