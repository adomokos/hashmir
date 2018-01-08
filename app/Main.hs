module Main where

import qualified Hashmir.Data as D

main :: IO ()
main = do
    D.withConn (\conn -> do
        clientId <- D.insertClient "TestClient" "testclient" conn
        putStrLn $ "New client's id is " ++ show clientId
        Just clientCount <- D.countClientSQL conn
        putStrLn $ "There are " ++ show clientCount ++ " records.")
    return ()
