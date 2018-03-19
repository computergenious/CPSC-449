import System.IO
import System.Environment
import Data.List

import BranchBound
import Parser

main = do
    args <- getArgs
    let readFile = head args
    handle<- openFile readFile ReadMode
    contents <- hGetContents handle
    printer(solver(parsing(lines contents)))

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
