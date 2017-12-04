{-#LANGUAGE TemplateHaskell #-}
{-#LANGUAGE QuasiQuotes #-}

module Main where

import Database.YeshQL
import qualified Database.HDBC as H
import Database.HDBC.MySQL

[yesh|
    -- name:countClientSQL :: (Int)
    SELECT count(id) FROM clients;
    ;;;
    -- name:insertClientSQL
    -- :client_name :: String
    -- :subdomain :: String
    INSERT INTO clients (name, subdomain) VALUES (:client_name, :subdomain);
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

insertClient :: String -> String -> IO ()
insertClient name subdomain = do
    conn <- getConn
    clientId <- insertClientSQL name subdomain conn
    H.commit conn
    H.disconnect conn
    putStrLn $ "New client's id is " ++ show clientId

countClient :: IO ()
countClient = do
    conn <- getConn
    Just (clientCount) <- countClientSQL conn
    putStrLn $ "There are " ++ show clientCount ++ " records."

main :: IO ()
main = do
  insertClient "TestClient" "testclient"
  countClient
