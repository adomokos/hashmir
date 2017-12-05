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

withConn :: (Connection -> IO b) -> IO b
withConn f = do
    conn <- getConn
    result <- f conn
    H.commit conn
    H.disconnect conn
    return result

insertClient :: String -> String -> IO ()
insertClient name subdomain = do
    clientId <-
        withConn (\conn -> do
            insertClientSQL name subdomain conn
        )
    putStrLn $ "New client's id is " ++ show clientId

countClient :: IO ()
countClient = do
    conn <- getConn
    Just (clientCount) <- countClientSQL conn
    H.commit conn -- added line
    H.disconnect conn -- added line
    putStrLn $ "There are " ++ show clientCount ++ " records."

main :: IO ()
main = do
  insertClient "TestClient" "testclient"
  countClient
