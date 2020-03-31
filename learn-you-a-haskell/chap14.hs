-- 14.1 Writer? 中の人なんていません!

isBigGang :: Int -> (Bool, String)
isBigGang x = (x > 9, "Compared gang size to 9.")

-- isBigGang 3

-- applyLog :: (a, String) -> (a -> (b, String)) -> (b, String)
-- applyLog (x, log) f = let (y, newLog) = f x in (y, log ++ newLog)

-- (3, "Smallish gang.") `applyLog` isBigGang
-- ("Tobin", "Got outlaw name.") `applyLog` (\x -> (length x, "Applied length."))

applyLog :: (Monoid m) => (a, m) -> (a -> (b, m)) -> (b, m)
applyLog (x, log) f = let (y, newLog) = f x in (y, log `mappend` newLog)
