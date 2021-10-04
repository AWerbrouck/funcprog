
-- recursie
fix :: (t -> t) -> t
fix f = f (fix f)

-- factorial
-- fac :: (Eq p, Num b) => (b ->b) -> b -> b
fac f 0 = 1
fac f n = n * f (n-1)

fact :: Integer -> Integer
fact n = fix fac n

factorial :: (Integral a) => a -> a
factorial 0 = 1
factorial n = factorial (n-1)

-- pattern matchen
charName :: Char -> String
charName 'a' = "Albert"
charName 'b' = "Bram"
charnam _ = "Undefined"

addVectors :: (Num a) => (a,a) -> (a,a) -> (a,a)
-- addVectors a b = (fst a + fst b, snd a + snd b ) is niet haskell manier
addVectors (a,b) (c,d) = (a+c, b+d)

first :: (a,b,c) -> a
first (x,_,_) = x -- de wildcard is beter om errors te vermijden want de laatste twee moet je niet benoemen

firstList :: [Int] -> String
firstList all@(x:_) = "The first element of the list " 
                      ++ (show all) ++ " is " ++ (show x)

-- list compre
-- remove non uppercase
upper :: [Char] -> [Char]
upper st = [ c | c <- st, c `elem` ['A'..'Z'] ]

-- case matching
headCase :: [a] -> a
headCase xs = case xs of []    -> error "no head"
                         (x:_) -> x

test x | x > 10 = x + 10
       | otherwise = x - 10

test2 x = y+10
         where y = 10

test3 x = (let y = 10
          in y + 10) + 5

applyTwice :: (a -> a) -> a -> a
applyTwice f x = f (f x)

-- Quicksort implementeren
quicksort :: (Ord a) => [a] -> [a]
quicksort [] = []
quicksort (x:xs) =
	let smallerSorted = quicksort (filter (<x) xs)
	    biggerSorted  = quicksort (filter (>=x) xs)
	in
		smallerSorted ++ [x] ++ biggerSorted






