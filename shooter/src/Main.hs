-- Een aantal imports die wel handig kunnen blijken.
import           Data.List
import           Data.Tuple
import           Graphics.Gloss
import           Graphics.Gloss.Interface.Pure.Game

--------------------------------------------------------------------------------
-- Datatypes en constanten

-- Coördinaten worden opgeslagen als paar gehele getallen. We verzinnen
-- type-aliassen hiervoor om de types van onze functies leesbaar en
-- betekenisvol te maken.
type X = Int
type Y = Int
type Coord = (X, Y)

-- Een level bestaat uit een reeks vallende lijnen. Zo'n lijn stellen
-- we voor door de lijst van kolommen waar een blokje valt.
type Line = [X]

-- Een spel kan zich in 3 mogelijke staten bevinden: de speler is nog
-- bezig, de speler is verloren, of de speler heeft gewonnen. In geval
-- van de twee laatste hoeven we niets te onthouden: we zullen gewoon
-- een vast scherm tonen. Als de speler nog bezig is, bevinden zich in
-- het spel een speler (voorgesteld door diens huidige coördinaat, een
-- aantal vallende obstakels (voorgesteld door diens coördinaten, een
-- aantal afgeschoten kogels (eveneens) en de lijnen die nog moeten
-- vallen.
data Game
  = Playing { player    :: Coord
            , obstacles :: [Coord]
            , bullets   :: [Coord]
            , lines     :: [Line]
            }
  | GameOver
  | Won

-- Twee kleuren die jullie alvast krijgen - pas deze gerust aan.
screenGreen, screenGray :: Color
screenGreen = makeColorI 0x6F 0x77 0x5F 0xFF
screenGray  = makeColorI 0x64 0x6F 0x5D 0XFF

-- Enkele constanten om te gebruiken in de rest van de code. Bij het
-- quoteren kunnen wij deze veranderen om te kijken welke invloed ze
-- hebben.
width   = 10 -- de breedte van het bord
height  = 20 -- de hoogte van het bord
dblock  = 12 -- de zijde van 1 blokje (inclusief marge rondom)
dwidth  = 10 -- de zijde van 1 blokje (exclusief marge, inclusief randje)
dinner  = 7 -- de zijde van 1 blokje (enkel het zwarte stuk middenin)
fscale  = 3 -- algemene schaal van de hele tekening

--- <-----------------------> dblock
---     <---------------> dwidth
---         <-------> dinner
---     +---------------+
---     |               |
---     |   MMMMMMMMM   |
---     |   MMMMMMMMM   |
---     |   MMMMMMMMM   |
---     |               |
---     +---------------+

-- De randen van het bord, om te gebruiken in andere functies.
bottom, top :: Y
left, right :: X
bottom = (-10)
top    = 10
left   = round (-(div width 2))
right  = round (div width 2)
------------------------------------------------------------------------
-- hulpFuncties

------------------------------------------------------------------------
-- Grafische elementen


-- Een gevulde/actieve pixel, gecentreerd rond de oorsprong
filled :: Picture
filled = rectangleSolid (dinner*fscale) (dinner*fscale)

-- Een lege pixel, gecentreerd rond de oorsprong
empty :: Picture
empty = color screenGray (pictures[ (rectangleWire (fscale*dwidth) (fscale*dwidth)), (rectangleSolid (dinner*fscale) (dinner*fscale))])

-- Een bord met enkel lege pixels, gecentreerd rond de oorsprong
emptyBoard :: Picture
emptyBoard = pictures[translate (x*36) (y*36) empty | x <- [(-5.0)..5.0], y <- [(-10.0)..10.0]]

-- Een gevulde/actieve pixel op de locatie aangeduid door de coördinaat.
drawCoord :: Coord -> Picture
drawCoord _ = blank

tran :: X -> Y -> Picture -> Picture
tran x y pic = translate (36*xf) (36*yf) pic
  where xf = fromIntegral x :: Float
        yf = fromIntegral y :: Float


-- Zet een volledig spel om in een afbeelding.
gamePic :: Game -> Picture
gamePic (Playing (x,y) o b _) = pictures [emptyBoard,
                                          (tran x y filled),
                                          (pictures [tran a b filled| (a,b) <- o]),
                                          (pictures [tran a b filled| (a,b) <- b])
					  ]
				
gamePic Won = blank
gamePic GameOver = (text "YOU SUCK")

------------------------------------------------------------------------
-- Spellogica

-- Of een gegeven coördinaat op het spelbord ligt.
onBoard :: Coord -> Bool
onBoard (x,y) = and [ elem x [left..right], elem y [top..bottom] ]

-- Of een gegeven coördinaat op de onderste rij ligt.
atBottom :: Coord -> Bool
atBottom (x,y) = y == bottom

-- Gegeven twee lijsten van coördinaten, geef deze twee lijsten terug
-- zonder de coördinaten die ze gemeenschappelijk hebben.
collide :: [Coord] -> [Coord] -> ([Coord], [Coord])
collide xs ys = (filter (\x -> x `notElem` ys) xs, filter (\x -> x `notElem` xs) ys)

-- Gebruik de `move` functie om de coördinaten in `moving` te verzetten.
-- Bij botsingen met de coördinaten in `static` moeten beide coördinaten
-- verwijderd worden uit de teruggegeven lijsten.
moveAndCollide :: (Coord -> Coord) -> ([Coord], [Coord]) -> ([Coord], [Coord])
moveAndCollide move (moving, static) = undefined

-- Deze methode wordt op vaste intervallen aangeroepen. Laat het spel
-- een stap vooruit gaan: de kogels en obstakels verplaatsen zich
-- allemaal elk 1 tegel. (De `t` mag je voorlopig negeren.)
next :: Float -> Game -> Game
next t (Playing p o b []) = next t (Playing p o b [[]])
next t (Playing p o b l) 
    | null [ (r,t) | (r,t) <- o, t == (-10)] = Playing p on ob (tail l)
    | otherwise                              = GameOver
  where (on,ob) = (collide ([ (x,(y-1)) | (x,y) <- (o ++ [((g-5),top)| g <- (head l)])]) ([ (x,(y+1)) | (x,y) <- b ]))

next t GameOver = GameOver
-- Hulpfuncties om een getal te decrementeren of incrementeren zonder
-- een grens te overschrijden.
decBound, incBound :: (Ord a, Num a) => a -> a -> a
decBound x b = max b (x - 1)
incBound x b = min b (x + 1)

-- Verwerk gebruiksinput.
move :: Event -> Game -> Game
move (EventKey (SpecialKey KeyLeft)  Down _ _) (Playing (x,y) o b l) = Playing ((decBound x left),y) o b l
move (EventKey (SpecialKey KeyRight) Down _ _) (Playing (x,y) o b l) = Playing ((incBound x right),y) o b l
move (EventKey (SpecialKey KeySpace) Down _ _) (Playing (x,y) o b l) = Playing (x,y) o (b++[(x,y)]) l
move _                                                             g = g 

------------------------------------------------------------------------
-- De main-methode en speldefinities

-- Een eenvoudig level om mee te testen.
level1 :: [Line]
level1 = [[0,1,3,4,5,9,10],[],[],[],[2,3,4,5,6,7,9,10] ]

-- Een spel waarbij de speler midden onderaan start.
startGame = Playing (0,-10) [(0,8)] [] level1

-- Start het spel op.
main  = play (InWindow "UGent Brick Game" (500, 800) (10, 10))
             screenGreen -- de achtergrondkleur
             1 -- aantal stappen per seconde
             startGame -- de beginwereld
             gamePic -- de 'render'-functie, om naar scherm te tekenen
             move -- de 'handle'-functie, om gebruiksinvoer te verwerken
             next -- de 'step'-functie, om 1 tijdstap te laten passeren
