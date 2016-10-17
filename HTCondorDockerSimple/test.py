import sys

rep = sys.argv[1]
target = open("out.txt", 'w')
target.write("Hello world!\nWe are on rep: ")
target.write( rep)
target.close()
