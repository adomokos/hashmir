module Main where

import qualified Hashmir.Data as D

main :: IO ()
main = do
    clientId <- D.insertClient "TestClient" "testclient"
    putStrLn $ "New client's id is " ++ show clientId
    Just clientCount <- D.countClient
    putStrLn $ "There are " ++ show clientCount ++ " records."
