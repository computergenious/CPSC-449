module Game where

import Robots
import Ball

type Team = [(Robot,Program)]

type Game = (Team,Team,Ball)

collision :: Position -> Position -> Bool
collision pos1 pos2 = sqrt ((getX pos1 - getX pos2)^2+(getY pos1 - getY pos2)^2) <= 20

signum' :: Float -> Float
signum' x | x>=0      = 1
          | otherwise = -1

resolveCollision :: Velocity -> Velocity -> (Velocity,Velocity)
resolveCollision vel1 vel2 = (vel1',vel2')
	where vx1   = getX vel1
	      vy1   = getY vel1
	      vx2   = getX vel2
	      vy2   = getY vel2
	      nx    = (abs vx1 + abs vx2)/2
	      ny    = (abs vy1 + abs vy2)/2
              vel1' = [(signum' vx2)*nx,(signum' vy2)*ny,1]
	      vel2' = [(signum' vx1)*nx,(signum' vy1)*ny,1]

robotCollision :: Robot -> Robot -> (Robot,Robot)
robotCollision r1@(n1,pos1,vel1,trans1) r2@(n2,pos2,vel2,trans2) 
	| collision pos1 pos2 = ((n1,pos1,vel1',trans1),(n2,pos2,vel2',trans2))
	| otherwise           = (r1,r2)
	where (vel1',vel2') = resolveCollision vel1 vel2
        
robotTeamCollision :: Robot -> Team -> (Robot,Team)
robotTeamCollision robot team = foldl f (robot,[]) team
	where f (r1,l) (r2,prog) = let (r1',r2') = robotCollision r1 r2 in (r1',(r2',prog):l)
	
teamTeamCollision :: Team -> Team -> (Team,Team)
teamTeamCollision t1 t2 = foldl f ([],t2) t1
	where f (l1,l2) (r,prog) = let (r',l2') = robotTeamCollision r l2 in ((r',prog):l1,l2')
	
innerTeamCollision :: Team -> Team
innerTeamCollision team = foldl f [] team
	where f l (r,prog) = let (r',l') = robotTeamCollision r l in (r',prog):l'
	
allTeamCollision :: Team -> Team -> (Team,Team)
allTeamCollision t1 t2 = teamTeamCollision (innerTeamCollision t1) (innerTeamCollision t2)

robotBallCollision :: Robot -> Ball -> (Robot,Ball)
robotBallCollision r@(n,pos1,vel1,trans) b@(pos2,vel2) 
	| collision pos1 pos2 = ((n,pos1,vel1',trans),(pos2,vel2'))
	| otherwise           = (r,b)
	where (vel1',vel2') = resolveCollision vel1 vel2
	
teamBallCollision :: Team -> Ball -> (Team,Ball)
teamBallCollision team ball = foldl f ([],ball) team
	where f (l,b) (r,prog) = let (r',b') = robotBallCollision r b in ((r',prog):l,b')
	
gameCollision :: Game -> Game
gameCollision (team1,team2,ball) = (team1'',team2'',ball'')
	where (team1',team2')  = allTeamCollision team1 team2
	      (team1'',ball')  = teamBallCollision team1' ball
	      (team2'',ball'') = teamBallCollision team2' ball'

------------------------------------------------------------------------

updateGame :: Game -> Game
updateGame (t1,t2,ball) = gameCollision (map f t1,map f t2,updateBall ball)
	where f (r,prog) = executeProgramStep (updateBot r) prog (fst ball)

------------------------------------------------------------------------
