-- ## week 02


-- 1) ggd
ggd :: Int -> Int -> Int
ggd a 0 = a
ggd a b = ggd b (a `mod` b)

-- 2) coprime
coprime :: Int -> Int -> Bool
coprime x y = ggd x y == 1

-- 3)
sq :: Int -> Int
sq n = floor (sqrt ( fromIntegral n ) )

isPriemgetal :: Int -> Bool
isPriemgetal p = and [ p `mod` i /= 0 | i <- [2..sq p] ]

allePriemgetallen :: [Int]
allePriemgetallen = [ i | i <- [2..], isPriemgetal i]

geefPriemgetallen :: Int -> [Int]
geefPriemgetallen n = take n allePriemgetallen

-- 4)
berekenPi :: Integer -> Double
berekenPi i = 4 * sum [ ((-1)**(fromIntegral n))/(2*(fromIntegral n) +1) | n <- [0..i]]

-- 5)
pack :: Eq a => [a] -> [[a]]
pack [] = []
pack (x:xs) = (x:ys) : pack zs
                      where (ys,zs) = span (== x) xs

-- 6)
flatten :: [[a]] -> [a]
flatten l = foldr (++) [] l

-- 7)
slice :: [a] -> Int -> Int -> [a]
slice l s e = drop s (take e l) 

tails k = [ drop i k | i <- [0..length k]]
