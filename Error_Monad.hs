-- https://dodona.ugent.be/nl/courses/819/series/10130/activities/1725353725

data Ofwel e a = Rechts a
               | Links e
               deriving (Show, Eq)

-- | Ofwel het exacte resultaat van een gehele deling, ofwel een foutboodschap.
safeDiv :: Int -> Int -> Ofwel String Int
safeDiv x y | y == 0         = Links "can't divide by zero"
            | x `mod` y /= 0 = Links "not exact"
            | otherwise      = Rechts (x `div` y)

instance Functor (Ofwel e) where
    --fmap = undefined
    fmap _ (Links e) = Links e
    fmap f (Rechts e) = Rechts (f e)

instance Applicative (Ofwel e) where
    pure = Rechts
    e <*> a = do x <- e; y <- a; return (x y)

instance Monad (Ofwel e) where
    return = Rechts
    Rechts r >>= k = k r
    Links  e >>= _ = Links e
    

-- | Kunnen we x appels en y peren eerlijk verdelen over z kinderen? Hoeveel vruchten krijgt elk?
sharing :: Int -> Int -> Int -> Ofwel String Int
sharing x y z = do{ safeDiv x z
                  ; safeDiv y z
                  ; safeDiv (x+y) z}

-- | Ofwel het n-de element van de lijst, ofwel een foutboodschap.
(!!?) :: [a] -> Int -> Ofwel String a
l !!? n | n < 0           = Links "negatieve index"
        | n >= (length l) = Links "index te groot"
        | otherwise       = Rechts (l!!n)
