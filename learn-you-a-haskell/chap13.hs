-- 13.2 Maybeから始めるモナド

applyMaybe :: Maybe a -> (a -> Maybe b) -> Maybe b
applyMaybe Nothing f = Nothing
applyMaybe (Just x) f = f x

-- Just 3 `applyMaybe` \x -> Just (x+1)
-- Just "smile" `applyMaybe` \x -> Just (x ++ " :)")
-- Nothing `applyMaybe` \x -> Just (x+1)
-- Nothing `applyMaybe` \x -> Just (x ++ " :)")
-- Just 3 `applyMaybe` \x -> if x > 2 then Just x else Nothing
-- Just 1 `applyMaybe` \x -> if x > 2 then Just x else Nothing
