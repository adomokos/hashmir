{-#LANGUAGE TemplateHaskell #-}
{-#LANGUAGE QuasiQuotes #-}

module Main where

import Database.YeshQL
import Database.HDBC.MySQL

[yesh|
    -- name:countClientSQL :: (Int)
    SELECT count(id) FROM clients;
|]

getConn :: IO Connection
getConn = do
    connectMySQL defaultMySQLConnectInfo {
        mysqlHost     = "localhost",
        mysqlDatabase = "hashmir_test",
        mysqlUser     = "hashmir_user",
        mysqlPassword = "shei7AnganeihaeF",
        mysqlUnixSocket = "/tmp/mysql.sock"
    }

countClient :: IO ()
countClient = do
    conn <- getConn
    Just (clientCount) <- countClientSQL conn
    putStrLn $ "There are " ++ show clientCount ++ " records."

main :: IO ()
main = countClient
