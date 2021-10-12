data Bool' = False' | True'
    deriving (Show)

not' :: Bool' -> Bool'
not' False' = True'
not' True' = False'

(&&) :: Bool' -> Bool' -> Bool'
False' && _ = False'
_ && False' = False'
_ && _ = True'

--data Season = Spring | Summer | Fall | Winter
  --  deriving (showi, Eq)

--Next :: Season -> Season
--Next Winter = Spring
--Next

type Radius = Float 
type Width = Float
type Height = Float
type Area = Float
data Shape = Circle Radius | Rect Width Height

area :: Shape -> Area
area (Circle r) = pi * r^2
area (Rect w h) = w * h



