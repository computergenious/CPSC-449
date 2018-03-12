module Robots where

import Data.List(transpose)
import ExtParseLib

type Vector = [Float]

getXY :: Vector -> (Float,Float)
getXY v = (head v,head $ tail v)

getX :: Vector -> Float
getX = fst . getXY

getY :: Vector -> Float
getY = snd . getXY

type Transformation = [[Float]]

idTransform :: Transformation
idTransform = [[1,0,0],[0,1,0],[0,0,1]]

rotTransform :: Float -> Transformation
rotTransform phi | -pi<=phi && phi<=pi = [[cp,sp,0],[-sp,cp,0],[0,0,1]]
		 | otherwise	       = error "Illegal angle in rotation."
	where sp = sin phi
	      cp = cos phi

accTransform :: (Float,Float) -> Transformation
accTransform (vx,vy) = [[1,0,0],[0,1,0],[vx,vy,1]]  


combineTransform :: Transformation -> Transformation -> Transformation
combineTransform t1 t2 = [ [ sum $ zipWith (*) r c | c <- transpose t2 ] | r <- t1 ]

applyTransform :: Vector -> Transformation -> Vector
applyTransform vect trans = head $ combineTransform [vect] trans 


		 
type Position = Vector
type Velocity = Vector

updatePos :: Position -> Velocity -> Position
updatePos pos vel = applyTransform pos (accTransform (getXY vel))

updateVel :: Velocity -> Transformation -> Velocity
updateVel vel trans = applyTransform vel trans



type Robot = (Int,Position,Velocity,Transformation)

generateAccTransform :: Float -> Velocity -> Transformation
generateAccTransform speed vel = accTransform (si*(signum vx)*sqrt (s1*(1-vy2/s2)),si*(signum vy)*sqrt (s1*(1-vx2/s2)))
	where vx  = getX vel
	      vy  = getY vel
	      vx2 = vx^2
	      vy2 = vy^2
	      s1  = speed^2
	      s2  = vx2+vy2
	      si  = signum speed

accBot :: Float -> Robot -> Robot
accBot speed (n,pos,vel,_) = (n,pos,vel,generateAccTransform speed vel)


rotateBot :: Float -> Robot -> Robot
rotateBot phi (n,pos,vel,_) = (n,pos,vel,rotTransform phi)

removeTransBot :: Robot -> Robot
removeTransBot (n,pos,vel,_) = (n,pos,vel,idTransform) 
	      
updateBot :: Robot -> Robot
updateBot (n,pos,vel,trans) = (n,updatePos pos vel,updateVel vel trans,trans)

updateBots :: [Robot] -> [Robot]
updateBots = map updateBot

modifyBots :: (Robot -> Robot) -> [Robot] -> [Robot]
modifyBots = map


angle vec0 vec1 = case (signum a0,signum a1) of
                     (1,1)   -> a1-a0
                     (1,0)   -> -a0
                     (1,-1)  -> 2*pi-(a0-a1)
                     (-1,1)  -> a1-a0
                     (-1,0)  -> -a0
                     (-1,-1) -> a1-a0
                     (0,1)   -> a1
                     (0,0)   -> 0.0
                     (0,-1)  -> 2*pi+a0
	where x0   = getX vec0
	      y0   = getY vec0
              len0 = sqrt (x0^2+y0^2)
	      x1   = getX vec1
	      y1   = getY vec1
	      len1 = sqrt (x1^2+y1^2)
	      a0   = atan2 (y0/len0) (x0/len0) 
	      a1   = atan2 (y1/len1) (x1/len1)
	      
inView :: Robot -> Area -> Position -> Float -> Bool
inView (_,pos1,vel,_) area pos2 f = angle0 >= 0.0 && angle0 <= f && angle1 >= 0.0 && angle1 <= f
	where vec0   = [getX pos2 - getX pos1,getY pos2 - getY pos1,1]
	      vec1   = case area of
	                   LeftSide  -> applyTransform vel (rotTransform (-f))
	                   Front     -> applyTransform vel (rotTransform (-f/2))
	                   RightSide -> vel
	      vec2   = case area of
	      	           LeftSide  -> vel
	      	           Front     -> applyTransform vel (rotTransform (f/2))
	                   RightSide -> applyTransform vel (rotTransform f)
	      angle0 = angle vec1 vec0
	      angle1 = angle vec0 vec2

------------------------------------------------------------------------
	  
data Range = Narrow | Wide deriving (Read,Show)

isWide :: Range -> Bool
isWide  Narrow = False
isWide  Wide = True

data Area = LeftSide | Front | RightSide deriving (Read,Show)

data Condition = Scan Range Area
               | And Condition Condition
               | Not Condition 

instance Show Condition where
	show (Scan r a) = "scan " ++ show r ++ " " ++ show a
	show (And c1 c2) = show c1 ++ " and " ++ show c2
	show (Not c) = "not(" ++ show c ++ ")"
	
instance Read Condition where
	readsPrec _  = parseCondition

parseCondition1 :: ReadS Condition
parseCondition1 = 	 ((stringToken "scan" .*> reads >*> reads) `build` (uncurry (Scan)))
			   `alt` ((stringToken "not" .*> stringToken "(" .*> parseCondition >*. stringToken ")") `build` (Not))

parseCondition :: ReadS Condition
parseCondition = parseCondition1	
			  `alt`	((parseCondition1 >*> stringToken "and" .*> parseCondition) `build` (uncurry (And)))

executeCondition :: Condition -> Robot -> Position -> Bool
executeCondition (Scan range area) robot pos | isWide range = inView robot area pos (pi/2) 
											 | otherwise = inView robot area pos (pi/4)
executeCondition (And cond1 cond2) robot pos = (executeCondition cond1 robot pos) && (executeCondition cond2 robot pos)
executeCondition (Not cond) robot pos = not (executeCondition cond robot pos)

------------------------------------------------------------------------

data Statement = Nope
			   | Accelerate Float
               | Break
               | TurnLeft Float
               | TurnRight Float
               | Roll
               | Goto Int
               | If Condition Int
               
nope :: Statement
nope = Nope

accelerate :: Float -> Statement
accelerate = Accelerate

break :: Statement
break = Break

turnLeft :: Float -> Statement
turnLeft = TurnLeft

turnRight :: Float -> Statement
turnRight = TurnRight

roll :: Statement
roll = Roll

goto :: Int -> Statement
goto = Goto

------------------------------------------------------------------------

instance Show Statement where
	show Nope = "nope"
	show (Accelerate f) = "accelerate " ++ show f
	show Break = "break"
	show (TurnLeft f) = "turn left " ++ show f
	show (TurnRight f) = "turn right " ++ show f
	show Roll = "roll"
	show (Goto i) = "goto " ++ show i
	show (If c i) = "if " ++ show c ++ " " ++ show i
	
instance Read Statement where
	readsPrec _ = parseStatement

parseStatement :: ReadS Statement
parseStatement = 	((stringToken "nope") `build` (const Nope))
			  `alt` ((stringToken "accelerate" .*> reads) `build` (Accelerate))
			  `alt` ((stringToken "break") `build` (const Break))
			  `alt` ((stringToken "turn" .*> stringToken "left".*> reads) `build` (TurnLeft))
			  `alt` ((stringToken "turn" .*> stringToken "right" .*> reads) `build` (TurnRight))
			  `alt` ((stringToken "roll") `build` (const Roll))
			  `alt` ((stringToken "goto" .*> reads) `build` (Goto))
			  `alt` ((stringToken "if" .*> reads >*> reads) `build` (uncurry (If)))

executeStatement :: Robot -> Statement -> Position -> (Robot,Maybe Int)
executeStatement robot Nope pos 	          = (robot,Nothing)
executeStatement robot (Accelerate speed) pos = (accBot speed robot,Nothing)
executeStatement robot Break pos              = (accBot (-1.0) robot,Nothing)
executeStatement robot (TurnLeft phi) pos     = (rotateBot (-phi) robot,Nothing)
executeStatement robot (TurnRight phi) pos    = (rotateBot phi robot,Nothing)
executeStatement robot Roll pos               = (removeTransBot robot,Nothing)
executeStatement robot (Goto n) pos           = (robot,Just n)
executeStatement robot (If cond n) pos | (executeCondition cond robot pos) == True = (robot,Just n)
									   | otherwise = (robot,Nothing)


newtype Program = P (Int,[Statement])


instance Show Program where
	show (P (_,[])) = ""
	show (P (_,(x:[]))) = show x 
	show (P (i,(x:xs))) = show x ++ ";\n" ++ show (P (i,xs))

instance Read Program where
	readsPrec n = parseStatementList `build` (\l -> P(0,l))

parseStatementList :: ReadS [Statement]
parseStatementList =
        ((    parseStatement
           >*> stringToken ";"
           .*> parseStatementList
          ) `build` (uncurry (:))
         )
  `alt` (parseStatement `build` (\x->[x]))
  `alt` succeed []


executeProgramStep :: Robot -> Program -> Position -> (Robot,Program)
executeProgramStep robot (P(n,prog)) pos | n<0 || n>=length prog = (robot,P(n,prog))
										 | otherwise             =
	case count of
	   Just m  -> (r,P(m,prog))
	   Nothing -> (r,P(n+1,prog))
	where (r,count) = executeStatement robot (prog!!n) pos

------------------------------------------------------------------------
