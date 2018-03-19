module BranchBound
(
Constraint(Constraint),
getTNConstraint,
getTNPenalty,
getMConstraint,
getMPenalty,
Solution(Solution),
getAssignment,
getPenalty,
solver
)
where

import Debug.Trace

-- Constraint data type holds 2d Bool lists for too-near, forbidden, and 2d Int lists for too-near pen, machine pen
-- constraintTN: row=taski column=taskj
-- constraintM: row=machine column=task
-- penaltyTN: row=taski column=taskj
-- penaltyM: row=machine column=task

data Constraint = Constraint [[Bool]] [[Bool]] [[Int]] [[Int]] deriving (Show)
getTNConstraint (Constraint constraintTN _ _ _) = constraintTN
getMConstraint (Constraint _ constraintM _ _) = constraintM
getTNPenalty (Constraint _ _ penaltyTN _) = penaltyTN
getMPenalty (Constraint _ _ _ penaltyM) = penaltyM

-- Solution data type holds list of solution (Int), integer of penalty value for solution
-- solution: row=machine column=task 
-- penalty: number value
data Solution = Solution [Int] Int deriving (Show)
getAssignment (Solution solution _) = solution
getPenalty (Solution _ penalty) = penalty

solver :: (Constraint, [(Int, Int)], String) -> (Solution, String)


solver (constraint, partials, []) | trace ("Constraints: " ++ show constraint) False = undefined


-- setup root and begin branch and bound 
solver (constraint, partials, []) = checkSolution (solve constraint (Solution [] 99999999) assignments remaining)
  where (assignments, remaining, error) = root constraint partials [] []

-- get arguments from parser and pass to writer if there is an error message; no branch and bound 
solver (constraint, partials, error) = (Solution [] 0, error++"\n")

-- check solution; if none possible after branch and bound pass message to writer otherwise pass solution
checkSolution :: Solution -> (Solution, String)
checkSolution solution 
  | null (getAssignment solution) = (Solution [] 0, "No valid solution possible!\n\n")
  | otherwise = (solution, [])

solve :: Constraint -> Solution -> [Int] -> [Int] -> Solution

 
solve constraint best assignments remaining | trace ("Best: " ++ show best ++ "; " ++ show assignments) False = undefined


-- checks if tasks remain and return solution if not create branch or start branching 
solve constraint best assignments remaining
  | null remaining && solveBool constraint assignments best = Solution assignments penalties
  | (remaining /= []) && solveBool constraint assignments best = branch constraint best assignments (map (extract remaining) [0..(length remaining - 1)]) --map (extract remaining) [0..(length remaining - 1)] applies extract to each element in list [0..(length remaining - 1)] with remaining to get a tuple of (task,nextRemaining) and passes this to branch
  | otherwise = best
  where penalties = sum (map (penalty constraint assignments) [0..7])

-- used in solve guards for better readability (might use where); checks against hard constraints and penalty value for next branch
solveBool :: Constraint -> [Int] -> Solution -> Bool
solveBool constraint assignments best = valid && (penalties  < getPenalty best)
  where penalties = sum (map (penalty constraint assignments) [0..7])
        valid = allTrue (map (validAssignments constraint assignments) [0..7])

-- extracts element at index from the list 
extract :: [Int] -> Int -> (Int,[Int])
extract list element = (list !! element, remove list element)

-- removes element at index from the list 
remove :: [Int] -> Int -> [Int]
remove (x:xs) 0 = xs
remove [x] index = [x]
remove (x:xs) index = x : remove xs (index - 1)

branch :: Constraint -> Solution -> [Int] -> [(Int, [Int])] -> Solution

branch constraint best assignments [(task, nextRemaining)] | trace ("Best: " ++ show best ++ " Assignments: " ++ show assignments ++ " Task: " ++ show task ++ " Next Remain: " ++ show nextRemaining) False = undefined


-- create branch for task and applies task to first empty machine 
branch constraint best assignments [(task, nextRemaining)] = solve constraint best (assign assignments task) nextRemaining

{-
branch constraint best assignments ((task, nextRemaining):remaining) | trace ("Best: " ++ show best ++ " Assignments: " ++ show assignments ++ " Task: " ++ show task ++ " Next Remain: " ++ show nextRemaining ++ " Remain: " ++ show remaining) False = undefined
-}

-- creates branches from parent (breadth); recursive step from java assignment 
branch constraint best assignments ((task, nextRemaining):remaining) = branch constraint (solve constraint best (assign assignments task) nextRemaining) assignments remaining

-- assign a task to the first empty machine 
assign :: [Int] -> Int-> [Int]
assign assignments task = replace task (emptyMachineLoop assignments 0) assignments

-- find first empty machine; dummy value
emptyMachineLoop :: [Int] -> Int-> Int
emptyMachineLoop ((-1):xs) index = index
emptyMachineLoop [x] index = -1
emptyMachineLoop (x:xs) index = emptyMachineLoop xs (index + 1)

root :: Constraint -> [(Int, Int)] -> [Int] -> [Int] -> ([Int],[Int],String)
-- set dummy values in list 
root constraint partials [] [] = root constraint partials (dummy 8 (-1)) [0..7]


root constraint ((machine, task):pairs) assignments remaining | trace ("Partials: " ++ show machine ++ "," ++ show task ++ show pairs ++ " Remaining: " ++ show remaining ++ " Assignments: " ++ show assignments) False = undefined


-- if no forced partials
root constraint [] assignments remaining = (assignments, remaining, [])

-- assign forced partials and update lists of assignments and remaining 
root constraint ((machine, task):pairs) assignments remaining
  | assignments !! machine == (-1) && valid = root constraint pairs (replace task machine assignments) (delete task remaining)
  | otherwise = ([], [0..7], "No valid solution possible!\n\n")
  where valid = allTrue (map (validAssignments constraint (replace task machine assignments)) [0..7])


-- create list of dummy values 
dummy :: Int -> Int -> [Int]
dummy 0 init = []
dummy size init = init : dummy (size - 1) init

-- deletes an element equal to item in a list 
delete :: Int -> [Int] -> [Int]
delete item (x:xs)
  | x == item = xs
  | null xs = [x]
  | otherwise = x : delete item xs

-- check against hard constraints 
validAssignments :: Constraint -> [Int] -> Int-> Bool
validAssignments constraint assignments machine = validMachine constraint assignments machine && validTooNear constraint assignments machine

-- determines whether a whole list is true 
allTrue :: [Bool] -> Bool
allTrue [x] = x
allTrue (True:xs) = allTrue xs
allTrue (False:xs) = False

-- check against the forbidden machine constraint 
validMachine :: Constraint -> [Int] -> Int-> Bool
validMachine constraint assignments index 
  | index == 7 = isValidMachine constraint 7 (assignments !! 7)
  | index /= 7 = isValidMachine constraint index (assignments !! index) && validMachine constraint assignments (succ index) 

isValidMachine :: Constraint -> Int-> Int-> Bool
isValidMachine constraint machine (-1) = True
isValidMachine constraint machine task = not $ (getMConstraint constraint !! machine) !! task

-- check against the too-near task constraint 
validTooNear :: Constraint -> [Int] -> Int-> Bool
validTooNear constraint assignments index
  | index == 7 = isValidTooNear constraint (assignments !! 7) (head assignments)
  | index /= 7 = isValidTooNear constraint (assignments !! index) (assignments !! succ index) && validTooNear constraint assignments (succ index)

isValidTooNear :: Constraint -> Int-> Int-> Bool
isValidTooNear constraint (-1) task' = True
isValidTooNear constraint task (-1)  = True
isValidTooNear constraint task task' = not $ (getTNConstraint constraint !! task) !! task'

-- add too near and machine penalty for a given machine
penalty :: Constraint -> [Int] -> Int-> Int
penalty constraint assignments machine = (+) (tooNearPenalty constraint assignments machine) (machinePenalty constraint assignments machine)

-- get the machine penalty 
machinePenalty :: Constraint -> [Int] -> Int-> Int
machinePenalty constraint assignments machine 
  | (assignments !! machine) >= 0 = (getMPenalty constraint !! machine) !! (assignments !! machine)
  | otherwise = 0

-- get the too near penalty 
tooNearPenalty :: Constraint -> [Int] -> Int -> Int
tooNearPenalty constraint assignments machine  
  | machine == 7 = modTooNear constraint (assignments !! 7) (head assignments)
  | machine < 7 = modTooNear constraint (assignments !! machine) (assignments !! succ machine)
  | otherwise = 0

-- mod for 7 to 0 too near penalty 
modTooNear :: Constraint -> Int -> Int -> Int
modTooNear constraint (-1) task' = 0
modTooNear constraint task (-1)  = 0
modTooNear constraint task task' = (getTNPenalty constraint !! task) !! task'

-- (what to replace thing in list with) -> (thing in list to replace) -> [list] -> [return list]
replace :: Int -> Int -> [Int] -> [Int]
replace element 0 (x:xs) = element:xs
replace element index (x:xs) = x : replace element (index - 1) xs
