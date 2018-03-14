{-

-}

data Constraint = Constraint [[Bool]] [[Bool]] [[Int]] [[Int]] deriving (Show)


--Takes a list of each Files lines
--Returns Constrains([[tooNear]] [[forbidden]] [[tooNearPen]] [[machinePen]], (forced,forced), String(status)
parsing :: [[Char]] -> (Constraint, [(Int,Int)], String)
parsing contents = isEmpty contents flag  tooNear forbidden tooNearPen machinePen forced1 forced2 
    where 
    flag = 0
    forced1 = []
    forced2 = []
    forbidden = [[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False]]
    tooNear = [[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False],[False,False,False,False,False,False,False,False]]
    machinePen = []
    tooNearPen =  [[0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0]]



isEmpty :: [[Char]] -> Int -> [[Bool]] -> [[Bool]] -> [[Int]] -> [[Int]] -> [Int] -> [Int] -> (Constraint, [(Int,Int)], String)
isEmpty contents flag tooNear forbidden tooNearPen machinePen forced1 forced2
    | null contents = (Constraint tooNear  forbidden  tooNearPen  (Prelude.reverse machinePen), Prelude.reverse (Prelude.zip forced1 forced2), status flag)      --Stops and returns everything if contents is empty
    | otherwise = theBeginning contents flag tooNear forbidden tooNearPen machinePen forced1 forced2                        --If contents[] is not empty, send to theBeginning


-- (Prelude.drop 1 contents) - removes the label and continues to function for work

theBeginning :: [[Char]] -> Int -> [[Bool]] -> [[Bool]] -> [[Int]] -> [[Int]] -> [Int] -> [Int] -> (Constraint, [(Int,Int)], String)
theBeginning contents flag tooNear forbidden tooNearPen machinePen forced1 forced2 
    | head contents == "Name:" && flag == 0                      = name (Prelude.drop 1 contents) flag tooNear forbidden tooNearPen machinePen forced1 forced2 
    | head contents == "forced partial assignment:" && flag == 1 = forced (Prelude.drop 1 contents) flag tooNear forbidden tooNearPen machinePen forced1 forced2 
    | head contents == "forbidden machine:" && flag == 2         = forbiddenFunc (Prelude.drop 1 contents) flag tooNear forbidden tooNearPen machinePen forced1 forced2 
    | head contents == "too-near tasks:" && flag == 3            = tooNearFunc (Prelude.drop 1 contents) flag tooNear forbidden tooNearPen machinePen forced1 forced2 
    | head contents == "machine penalties:" && flag == 4         = machinePenFunc (Prelude.drop 1 contents) flag tooNear forbidden tooNearPen machinePen forced1 forced2 
    | head contents == "too-near penalties" && flag == 5        = tooNearPenFunc (Prelude.drop 1 contents) flag tooNear forbidden tooNearPen machinePen forced1 forced2 
    | head contents == "" = isEmpty (Prelude.drop 1 contents) flag tooNear forbidden tooNearPen machinePen forced1 forced2 
    | otherwise = isEmpty [] flag tooNear forbidden tooNearPen machinePen forced1 forced2                                   --If line is not one of labels or "", it is random and ends by return []



--WORKS
--Function for "Name:"
name :: [[Char]] -> Int -> [[Bool]] -> [[Bool]] -> [[Int]] -> [[Int]] -> [Int] -> [Int] -> (Constraint, [(Int,Int)], String)
name contents flag tooNear forbidden tooNearPen machinePen forced1 forced2 
    | head contents /= "" = isEmpty (Prelude.drop 1 contents) (flag + 1) tooNear forbidden tooNearPen machinePen forced1 forced2 
    | otherwise = isEmpty [] flag tooNear forbidden tooNearPen machinePen forced1 forced2                                   --If there is no name, end


--DONE
--Function for "forced partial assignment:"
--Checks for invalid Values
forced :: [[Char]] -> Int -> [[Bool]] -> [[Bool]] -> [[Int]] -> [[Int]] -> [Int] -> [Int] -> (Constraint, [(Int,Int)], String)
forced contents flag tooNear forbidden tooNearPen machinePen forced1 forced2 
    | null contents = isEmpty contents (flag+1) tooNear forbidden tooNearPen machinePen forced1 forced2
    | (head contents /= "") && (mach1 == (-1) || task1 == (-1)) = isEmpty [] flag tooNear forbidden tooNearPen machinePen forced1 forced2
    | head contents /= "" = forced (Prelude.drop 1 contents) flag tooNear forbidden tooNearPen machinePen (mach1:forced1) (task1:forced2)
    | otherwise = isEmpty contents (flag+1) tooNear forbidden tooNearPen machinePen forced1 forced2                                   --Stops onces "" is found
    where mach1 = convertNum (head contents !! 1)
          task1 = convertLetter (head contents !! 3)


--DONE
--Function for "forbidden machine:"
--Checks for invalid Values
forbiddenFunc :: [[Char]] -> Int -> [[Bool]] -> [[Bool]] -> [[Int]] -> [[Int]] -> [Int] -> [Int] -> (Constraint, [(Int,Int)], String)
forbiddenFunc contents flag tooNear forbidden tooNearPen machinePen forced1 forced2 
    | null contents = isEmpty contents (flag+1) tooNear forbidden tooNearPen machinePen forced1 forced2
    | (head contents /= "") && (mach1 == (-1) || task1 == (-1)) = isEmpty [] flag tooNear forbidden tooNearPen machinePen forced1 forced2
    | head contents /= "" = forbiddenFunc (Prelude.drop 1 contents) flag tooNear (replaceVal2D mach1 task1 True forbidden) tooNearPen machinePen forced1 forced2 
    | otherwise = isEmpty contents (flag+1) tooNear forbidden tooNearPen machinePen forced1 forced2                                   --If there is no name, end
    where mach1 = convertNum (head contents !! 1)
          task1 = convertLetter (head contents !! 3)


--DONE
--Function for "too-near tasks:"
--Checks for Invalid Values
tooNearFunc :: [[Char]] -> Int -> [[Bool]] -> [[Bool]] -> [[Int]] -> [[Int]] -> [Int] -> [Int] -> (Constraint, [(Int,Int)], String)
tooNearFunc contents flag tooNear forbidden tooNearPen machinePen forced1 forced2 
    | null contents = isEmpty contents (flag+1) tooNear forbidden tooNearPen machinePen forced1 forced2
    | (head contents /= "") && (task1 == (-1) || task2 == (-1)) = isEmpty [] flag tooNear forbidden tooNearPen machinePen forced1 forced2
    | head contents /= "" = tooNearFunc (Prelude.drop 1 contents) flag (replaceVal2D task1 task2 True tooNear) forbidden tooNearPen machinePen forced1 forced2 
    | otherwise = isEmpty contents (flag+1) tooNear forbidden tooNearPen machinePen forced1 forced2                                   --If there is no name, end
    where task1 = convertLetter (head contents !! 1)
          task2 = convertLetter (head contents !! 3)


--DONE
--Function for "machine penalties:"
--Checks for valid values
--     Does NOT check for rows, only column
machinePenFunc :: [[Char]] -> Int -> [[Bool]] -> [[Bool]] -> [[Int]] -> [[Int]] -> [Int] -> [Int] -> (Constraint, [(Int,Int)], String)
machinePenFunc contents flag tooNear forbidden tooNearPen machinePen forced1 forced2 
    | null contents = isEmpty contents (flag+1) tooNear forbidden tooNearPen machinePen forced1 forced2
    | (head contents /= "") && (colLength /= 8) = isEmpty [] flag tooNear forbidden tooNearPen machinePen forced1 forced2
    | (head contents /= "") && ((all (>0) rowInt) == False) = isEmpty [] flag tooNear forbidden tooNearPen machinePen forced1 forced2
    | head contents /= "" = machinePenFunc (Prelude.drop 1 contents) flag tooNear forbidden tooNearPen   (rowInt:machinePen)   forced1 forced2 
    | otherwise = isEmpty contents (flag+1) tooNear forbidden tooNearPen machinePen forced1 forced2                                   --If there is no name, end
    where rowInt = map (read::String->Int) (words (head contents))
          colLength = length rowInt



--Function for "too-near penalties:"
--Checks for Invalid Values
tooNearPenFunc :: [[Char]] -> Int -> [[Bool]] -> [[Bool]] -> [[Int]] -> [[Int]] -> [Int] -> [Int] -> (Constraint, [(Int,Int)], String)
tooNearPenFunc contents flag tooNear forbidden tooNearPen machinePen forced1 forced2 
    | null contents = isEmpty contents (flag+1) tooNear forbidden tooNearPen machinePen forced1 forced2
    | (head contents /= "") && (task1 == (-1) || task2 == (-1) || penal == (-1)) = isEmpty [] flag tooNear forbidden tooNearPen machinePen forced1 forced2
    | head contents /= "" = tooNearPenFunc (Prelude.drop 1 contents) flag tooNear forbidden  (replaceVal2D task1 task2 penal tooNearPen) machinePen forced1 forced2 
    | otherwise = isEmpty contents (flag+1) tooNear forbidden tooNearPen machinePen forced1 forced2                                   --If there is no name, end
    where task1 = convertLetter (head contents !! 1)
          task2 = convertLetter (head contents !! 3)
          penal = read (take ((length (head contents)) - 6) (drop 5 (head contents))) :: Int


--Replace element in 2D array. Param: (row,col,value,List)
--replaceVal #1 (replaceVal #2 True (List !! #1)) List
replaceVal2D n m newVal x = replaceVal n (replaceVal m newVal (x !! n)) x

--Replaces element in List
--    Param: (index, value, List)
replaceVal n newVal (x:xs)
    | n == 0 = newVal:xs
    | otherwise = x:replaceVal (n-1) newVal xs


--Gets corresponding String based on flag
status :: Int -> String
status flag
    | flag == 0 = "Name Error"
    | flag == 1 = "forced partial assignment Error"
    | flag == 2 = "forbidden machine Error"
    | flag == 3 = "too-near tasks Error"
    | flag == 4 = "machine penalties Error"
    | flag == 5 = "too-near penalties Error"
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
