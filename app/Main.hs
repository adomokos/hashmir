module Main where

import qualified Hashmir.Data as D

main :: IO ()
main = do
    clientId <- D.withConn $ D.insertClient "TestClient" "testclient"
    putStrLn $ "New client's id is " ++ show clientId
    Just clientCount <- D.withConn D.countClientSQL
    putStrLn $ "There are " ++ show clientCount ++ " records."
