module ExtParseLib((.*>),(>*.),stringToken,module ParseLib) where

import ParseLib

infixr 5 .*>

(.*>) :: Parse a b -> Parse a c -> Parse a c
p1 .*> p2 = (p1 >*> p2) `build` snd

infixr 5 >*.

(>*.) :: Parse a b -> Parse a c -> Parse a b
p1 >*. p2 = (p1 >*> p2) `build` fst

stringToken :: String -> Parse Char String
stringToken s1 s2 = [ (a,b) | (a,b) <- lex s2, a==s1] 
