import System.IO
import System.Environment
import Data.List

import BranchBound
import Parser

-- for testing purposes arguments to be passed to solver are hard coded using the noChoice.txt input file
main = do
    args <- getArgs
    let readFile = head args
    handle<- openFile readFile ReadMode
    contents <- hGetContents handle
    printer(solver(parsing(lines contents)))
{-
    let contents = Constraint [[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False]] [[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False]] [[0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0]] [[1,1,1,1,1,1,1,100],[1,1,1,1,1,1,100,1],[1,1,1,1,1,100,1,1],[1,1,1,1,100,1,1,1],[1,1,1,100,1,1,1,1],[1,1,100,1,1,1,1,1],[1,100,1,1,1,1,1,1],[100,1,1,1,1,1,1,1]]

    let partials = [(7,0),(6,1),(5,2),(4,3),(3,4),(2,5),(1,6),(0,7)]
    let error = ""
    let solverArguments = (contents, partials, error)
    printer(solver solverArguments)
-}

printer :: (Solution,String)->IO()
printer (solution, []) = do
    args<-getArgs
    writeFile (args !! 1) ("Solution " ++ unwords(map (\c -> [taskLetter c]) (getAssignment solution))++"; Quality: " ++ show (getPenalty solution)++"\n")


printer (solution, error) = do
    args<-getArgs
    writeFile (args !! 1) error

taskLetter 0 = 'A'
taskLetter 1 = 'B'
taskLetter 2 = 'C'
taskLetter 3 = 'D'
taskLetter 4 = 'E'
taskLetter 5 = 'F'
taskLetter 6 = 'G'
taskLetter 7 = 'H'
taskLetter c = '\0'
