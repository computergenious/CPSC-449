import Graphics.SOE
import Robots
import Ball
import Game
import System.Win32(sleep)

aBot1 :: Robot
aBot1 = (1,[500,200,1],[-2,0,1],idTransform)

aBot2 :: Robot
aBot2 = (2,[0,200,1],[1,0,1],idTransform)

aBot3 :: Robot
aBot3 = (1,[50,500,1],[0,-2,1],idTransform)

aBot4 :: Robot
aBot4 = (2,[50,0,1],[0,1,1],idTransform)

ball :: Ball
ball = ([150,150,1],[0,0,1])
              
tt =    "if not(scan Narrow Front) and scan Wide LeftSide 4;\n"
     ++ "if not(scan Narrow Front) and scan Wide RightSide 6;\n"
     ++ "if scan Narrow Front 8;\n" 
     ++ "goto 0;\n"
     ++ "turn left 0.2;\n"
     ++ "goto 0;\n"
     ++ "turn right 0.2;\n"
     ++ "goto 0;\n"
     ++ "roll;\n"
     ++ "goto 0"
     
prog :: Program
prog = read tt

game :: Game
game = ([(aBot1,prog),(aBot2,prog)],[(aBot3,prog),(aBot4,prog)],ball)

drawObject :: Color -> Position -> Graphic
drawObject color pos = withColor color (ellipse (px-7,py-7) (px+7,py+7))
	where px = round $ getX pos
	      py = round $ getY pos

drawBot :: Color -> Robot -> Graphic
drawBot color (n,pos,_,_) = 
	do
	  drawObject color pos
	  withColor White (text (px-4,py-9) (show n))
	where px = round $ getX pos
	      py = round $ getY pos
	     
drawBall :: Ball -> Graphic
drawBall (pos,_) = drawObject Green pos
	      
drawGame :: Game -> Graphic
drawGame (t1,t2,b) = 
	do 
	  mapM_ (drawBot Red . fst) t1
	  mapM_ (drawBot Blue . fst) t2
	  drawBall b

continue :: Maybe Event -> Bool
continue (Just (Key { char=c, isDown=down })) = not (c=='\r' && down)
continue _ = True 

loop :: Window -> Game -> IO ()
loop w game = 
  do setGraphic w (drawGame game)
     getWindowTick w
     mevent <- maybeGetWindowEvent w
     if continue mevent then loop w (updateGame game) else return()

main :: IO ()
main = runGraphics $
  do w <- openWindowEx "Test" Nothing (Just (500,500)) drawBufferedGraphic (Just 10)
     loop w game
     closeWindow w
