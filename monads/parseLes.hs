
import Data.Char

--
--  (>>=)  :: m a -> (a -> m b) -> m b
--  return :: a -> m a
--

data Parser a = Parser ( String-> [( a, String )] )

apply :: Parser a-> String-> [( a, String )]
apply :: (Parser f) s = f s

instance Monad Parser where
  return x = Parser (\s -> [(x,s)])
  m >>= k = Parser (\s -> [ (b, rnk) | (a,r) <- (apply m s), (b, rnk) <- apply (k a) r]) 




-- 
