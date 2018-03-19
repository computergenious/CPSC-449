module Parser (
    parsing
) where
{-
	Machine pen will error "Exception: Prelude.read: no parse" If penalty is not a num
	
    partial assignment error?? more than 8??
    
    FAILED TESTS:
    nochoice2.txt:              output = too-near penalties errors            actual = Solution A B C D E F G H; Quality: 8
    optzero.txt:                output = invalid penalty                      actual = Solution A B C D E F G H; Quality: 0
    toonearpen1.txt:            output = too-near penalties errors            actual = Solution A B C D E H F G; Quality: 16
    toonearpen2.txt:            output = too-near penalties errors            actual = Solution A B C D E G F H; Quality: 18
    wrongnumbermachine.txt:     error "main: Prelude.read: no parse"          actual = invalid penalty
    wrongnumbertoonear.txt:     error "main: Prelude.read: no parse"          actual = invalid penalty
-}

import Debug.Trace
import BranchBound
--data Constraint = Constraint [[Bool]] [[Bool]] [[Int]] [[Int]] deriving (Show)


--Takes a list of each Files lines
--Returns Constrains([[tooNear]] [[forbidden]] [[tooNearPen]] [[machinePen]], (forced,forced), String(status)
parsing :: [String] -> (Constraint, [(Int, Int)], String)
parsing contents | trace "parsing" False = undefined
parsing contents = isEmpty contents flag  tooNear forbidden tooNearPen machinePen forced1 forced2 
    where 
    flag = 0
    forced1 = []
    forced2 = []
    forbidden = [[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False]]
    tooNear = [[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False]]
    machinePen = []
    tooNearPen =  [[0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0]]



isEmpty :: [String] -> Int -> [[Bool]] -> [[Bool]] -> [[Int]] -> [[Int]] -> [Int] -> [Int] -> (Constraint, [(Int,Int)], String)
isEmpty contents flag tooNear forbidden tooNearPen machinePen forced1 forced2 | trace ("isEmpty " ++ show flag) False = undefined
isEmpty contents flag tooNear forbidden tooNearPen machinePen forced1 forced2
    | null contents && flag == 6 = (Constraint tooNear  forbidden  tooNearPen  (Prelude.reverse machinePen), Prelude.reverse (Prelude.zip forced1 forced2), status flag)      --Stops and returns everything if contents is empty
    | null contents = (Constraint tooNear  forbidden  tooNearPen  (Prelude.reverse machinePen), Prelude.reverse (Prelude.zip forced1 forced2), status flag)                      --Stops and returns everything if contents is empty
    | otherwise = theBeginning contents flag tooNear forbidden tooNearPen machinePen forced1 forced2                        --If contents[] is not empty, send to theBeginning

-- (Prelude.drop 1 contents) - removes the label and continues to function for work

theBeginning :: [String] -> Int -> [[Bool]] -> [[Bool]] -> [[Int]] -> [[Int]] -> [Int] -> [Int] -> (Constraint, [(Int,Int)], String)
theBeginning contents flag tooNear forbidden tooNearPen machinePen forced1 forced2 | trace ("theBeginning " ++ show flag) False = undefined
theBeginning contents flag tooNear forbidden tooNearPen machinePen forced1 forced2 
    | head contents == "Name:" && flag == 0                      = name (Prelude.drop 1 contents) flag tooNear forbidden tooNearPen machinePen forced1 forced2 
    | head contents == "forced partial assignment:" && flag == 1 = forced (Prelude.drop 1 contents) flag tooNear forbidden tooNearPen machinePen forced1 forced2 
    | head contents == "forbidden machine:" && flag == 2         = forbiddenFunc (Prelude.drop 1 contents) flag tooNear forbidden tooNearPen machinePen forced1 forced2 
    | head contents == "too-near tasks:" && flag == 3            = tooNearFunc (Prelude.drop 1 contents) flag tooNear forbidden tooNearPen machinePen forced1 forced2 
    | head contents == "machine penalties:" && flag == 4         = machinePenFunc (Prelude.drop 1 contents) flag tooNear forbidden tooNearPen machinePen forced1 forced2 
    | head contents == "too-near penalities" && flag == 5        = tooNearPenFunc (Prelude.drop 1 contents) flag tooNear forbidden tooNearPen machinePen forced1 forced2 
    | null (words (head contents)) = isEmpty (Prelude.drop 1 contents) flag tooNear forbidden tooNearPen machinePen forced1 forced2 
    | otherwise = isEmpty [] 0 tooNear forbidden tooNearPen machinePen forced1 forced2                                   --If line is not one of labels or "", it is random and ends by return []



--WORKS
--Function for "Name:"
name :: [String] -> Int -> [[Bool]] -> [[Bool]] -> [[Int]] -> [[Int]] -> [Int] -> [Int] -> (Constraint, [(Int,Int)], String)
name contents flag tooNear forbidden tooNearPen machinePen forced1 forced2 | trace ("name " ++ show flag) False = undefined
name contents flag tooNear forbidden tooNearPen machinePen forced1 forced2 
    | null contents = isEmpty [] 0 tooNear forbidden tooNearPen machinePen forced1 forced2
    | null (words (head contents)) = isEmpty [] 0 tooNear forbidden tooNearPen machinePen forced1 forced2
    | otherwise = isEmpty (Prelude.drop 1 contents) (flag + 1) tooNear forbidden tooNearPen machinePen forced1 forced2          --


--DONE
--Function for "forced partial assignment:"
forced :: [String] -> Int -> [[Bool]] -> [[Bool]] -> [[Int]] -> [[Int]] -> [Int] -> [Int] -> (Constraint, [(Int,Int)], String)
forced contents flag tooNear forbidden tooNearPen machinePen forced1 forced2 | trace ("forced " ++ show flag) False = undefined
forced contents flag tooNear forbidden tooNearPen machinePen forced1 forced2 
    | null contents                  = isEmpty [] 0 tooNear forbidden tooNearPen machinePen forced1 forced2                                 --If nothing after reading "forced"  -> return parsing error
--    | null (head contents)  && (length forced1 > 8)    = isEmpty [] 1 tooNear forbidden tooNearPen machinePen forced1 forced2           --Only Partial assignment error(more than 8)
    | null (words (head contents))   = isEmpty contents (flag+1) tooNear forbidden tooNearPen machinePen forced1 forced2                    --If the head contents is empty      -> return Normally
    | length (head contents) /= 5    = isEmpty [] 10 tooNear forbidden tooNearPen machinePen forced1 forced2                                --If task/mach are correct length(5) -> return invalid task/mach
    | mach1 == (-1) || task1 == (-1) = isEmpty [] 10 tooNear forbidden tooNearPen machinePen forced1 forced2                                --If either task or mach is invalid  -> return invalid task/mach
    | partial /= [] && pairIsIn (mach1,task1) partial = isEmpty [] 13 tooNear forbidden tooNearPen machinePen forced1 forced2
    | otherwise = forced (Prelude.drop 1 contents) flag tooNear forbidden tooNearPen machinePen (mach1:forced1) (task1:forced2)             --Nothing wrong                      -> calls itself and updates forced
    where mach1 = convertNum (head contents !! 1)
          task1 = convertLetter (head contents !! 3)
          partial = zip forced1 forced2

pairIsIn (a,b) [] = False
pairIsIn (a,b) ((a',b'):xs) 
    | a == a' || b == b' = True
    | null xs = False
    | otherwise = pairIsIn (a,b) xs

--DONE
--Function for "forbidden machine:"
--Same as forced
forbiddenFunc :: [String] -> Int -> [[Bool]] -> [[Bool]] -> [[Int]] -> [[Int]] -> [Int] -> [Int] -> (Constraint, [(Int,Int)], String)
forbiddenFunc contents flag tooNear forbidden tooNearPen machinePen forced1 forced2 | trace ("forbiddenFunc " ++ show flag) False = undefined
forbiddenFunc contents flag tooNear forbidden tooNearPen machinePen forced1 forced2 
    | null contents                  = isEmpty [] 0 tooNear forbidden tooNearPen machinePen forced1 forced2
    | null (words (head contents))   = isEmpty contents (flag+1) tooNear forbidden tooNearPen machinePen forced1 forced2
    | length (head contents) /= 5    = isEmpty [] 10 tooNear forbidden tooNearPen machinePen forced1 forced2
    | mach1 == (-1) || task1 == (-1) = isEmpty [] 10 tooNear forbidden tooNearPen machinePen forced1 forced2
    | otherwise = forbiddenFunc (Prelude.drop 1 contents) flag tooNear (replaceVal2D mach1 task1 True forbidden) tooNearPen machinePen forced1 forced2  --uses function to replace array with True
    where mach1 = convertNum (head contents !! 1)
          task1 = convertLetter (head contents !! 3)


--DONE
--Function for "too-near tasks:"
--Checks for Invalid Values
tooNearFunc :: [String] -> Int -> [[Bool]] -> [[Bool]] -> [[Int]] -> [[Int]] -> [Int] -> [Int] -> (Constraint, [(Int,Int)], String)
tooNearFunc contents flag tooNear forbidden tooNearPen machinePen forced1 forced2 | trace ("tooNearFunc " ++ show flag) False = undefined
tooNearFunc contents flag tooNear forbidden tooNearPen machinePen forced1 forced2 
    | null contents                  = isEmpty [] 0 tooNear forbidden tooNearPen machinePen forced1 forced2
    | null (words (head contents))   = isEmpty contents (flag+1) tooNear forbidden tooNearPen machinePen forced1 forced2
    | length (head contents) /= 5    = isEmpty [] 10 tooNear forbidden tooNearPen machinePen forced1 forced2
    | task1 == (-1) || task2 == (-1) = isEmpty [] 10 tooNear forbidden tooNearPen machinePen forced1 forced2
    | otherwise = tooNearFunc (Prelude.drop 1 contents) flag (replaceVal2D task1 task2 True tooNear) forbidden tooNearPen machinePen forced1 forced2
    where task1 = convertLetter (head contents !! 1)
          task2 = convertLetter (head contents !! 3)


--DONE
--Function for "machine penalties:"
--Checks for valid values
--     Does NOT check for rows, only column
machinePenFunc :: [String] -> Int -> [[Bool]] -> [[Bool]] -> [[Int]] -> [[Int]] -> [Int] -> [Int] -> (Constraint, [(Int,Int)], String)
machinePenFunc contents flag tooNear forbidden tooNearPen machinePen forced1 forced2 | trace ("machinePenFunc " ++ show flag) False = undefined
machinePenFunc contents flag tooNear forbidden tooNearPen machinePen forced1 forced2 
    | null contents                  = isEmpty [] 0 tooNear forbidden tooNearPen machinePen forced1 forced2
    | null (head contents) && (length machinePen) /= 8  = isEmpty [] 4 tooNear forbidden tooNearPen machinePen forced1 forced2                                --Check for Row?
    | null (words (head contents))   = isEmpty contents (flag+1) tooNear forbidden tooNearPen machinePen forced1 forced2                                --Check for Row?
    | colLength /= 8                 = isEmpty [] 4 tooNear forbidden tooNearPen machinePen forced1 forced2
    | (all (>0) rowInt) == False     = isEmpty [] 11 tooNear forbidden tooNearPen machinePen forced1 forced2                                             --If any value is under 0 -> return machinePen error
    | otherwise                      = machinePenFunc (Prelude.drop 1 contents) flag tooNear forbidden tooNearPen  (rowInt:machinePen)  forced1 forced2
    where rowInt = map (read::String->Int) (words (head contents))
          colLength = length rowInt

--Function for "too-near penalties:"
--Checks for Invalid Values
tooNearPenFunc :: [String] -> Int -> [[Bool]] -> [[Bool]] -> [[Int]] -> [[Int]] -> [Int] -> [Int] -> (Constraint, [(Int,Int)], String)
tooNearPenFunc contents flag tooNear forbidden tooNearPen machinePen forced1 forced2 | trace ("tooNearPenFunc " ++ show flag) False = undefined
tooNearPenFunc contents flag tooNear forbidden tooNearPen machinePen forced1 forced2 
    | null contents                  = isEmpty contents flag tooNear forbidden tooNearPen machinePen forced1 forced2                                           --If nothing, return normally
    | null (words (head contents))   = isEmpty contents (flag+1) tooNear forbidden tooNearPen machinePen forced1 forced2
    | length (head contents) < 6     = isEmpty [] 10 tooNear forbidden tooNearPen machinePen forced1 forced2                                                   --If length is less than 6"(A,B,345345)
    | task1 == (-1) || task2 == (-1) = isEmpty [] 12 tooNear forbidden tooNearPen machinePen forced1 forced2
    | penal == (-1)                  = isEmpty [] 11 tooNear forbidden tooNearPen machinePen forced1 forced2
    | otherwise                      = tooNearPenFunc (Prelude.drop 1 contents) flag tooNear forbidden  (replaceVal2D task1 task2 penal tooNearPen) machinePen forced1 forced2
    where task1 = convertLetter (head contents !! 1)
          task2 = convertLetter (head contents !! 3)
          penal = read (take (length (head contents) - 6) (drop 5 (head contents))) :: Int


--Replace element in 2D array. Param: (row,col,value,List)
--replaceVal #1 (replaceVal #2 True (List !! #1)) List
replaceVal2D n m newVal x | trace "replace 2d val" False = undefined
replaceVal2D n m newVal x = replaceVal n (replaceVal m newVal (x !! n)) x

--Replaces element in List
--    Param: (index, value, List)
replaceVal n newVal (x:xs) | trace "replace val" False = undefined
replaceVal n newVal (x:xs)
    | n == 0 = newVal:xs
    | otherwise = x:replaceVal (n-1) newVal xs


--Gets corresponding String based on flag
status :: Int -> String
status flag
    | flag == 0 = "Error while parsing input file\n"
    | flag == 1 = "partial assignment error\n"
    | flag == 2 = "forbidden machine error\n"
    | flag == 3 = "too-near tasks error\n"
    | flag == 4 = "machine penalty error\n"
    | flag == 5 = "too-near penalties error\n"
    | flag == 10 = "invalid machine/task\n"
    | flag == 11 = "invalid penalty\n"
    | flag == 12 = "invalid task\n"
    | flag == 13 = "partial assignment error\n"
    | otherwise = ""



--Convert Letter String to Corresponding Int
convertLetter :: Char -> Int
convertLetter 'A' = 0
convertLetter 'B' = 1
convertLetter 'C' = 2
convertLetter 'D' = 3
convertLetter 'E' = 4
convertLetter 'F' = 5
convertLetter 'G' = 6
convertLetter 'H' = 7
convertLetter x = -1


--Convert Num String to Corresponding Int
convertNum :: Char -> Int
convertNum '1' = 0
convertNum '2' = 1
convertNum '3' = 2
convertNum '4' = 3
convertNum '5' = 4
convertNum '6' = 5
convertNum '7' = 6
convertNum '8' = 7
convertNum x = -1
