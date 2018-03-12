module Ball where

import Robots

type Ball = (Position,Velocity)

speed :: Velocity -> Float
speed vel = sqrt ((getX vel)^2+(getY vel)^2)

ballVelocityTransform :: Velocity -> Velocity
ballVelocityTransform vel | speed vel > 0.1 = applyTransform vel (generateAccTransform (-0.01) vel)
                          | otherwise       = [0.0,0.0,1.0]
	     
updateBall :: Ball -> Ball
updateBall (pos,vel) | speed vel >= 0.0 = (updatePos pos vel,ballVelocityTransform vel)
                     | otherwise        = (pos,vel)