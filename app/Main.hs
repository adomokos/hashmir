module Main where

import Hashmir.Data

main :: IO ()
main = do
    clientId <- insertClient "TestClient" "testclient"
    putStrLn $ "New client's id is " ++ show clientId
    Just clientCount <- countClient
    putStrLn $ "There are " ++ show clientCount ++ " records."
