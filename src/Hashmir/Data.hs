{-#LANGUAGE TemplateHaskell #-}
{-#LANGUAGE QuasiQuotes #-}

module Hashmir.Data where

import Database.YeshQL
import qualified Database.HDBC as H
import Database.HDBC.MySQL
import qualified System.Environment as E

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
    env <- E.lookupEnv("APP_ENV")
    if env == Just "test"
        then H.rollback conn  -- roll back the txn for "tests"
        else H.commit conn
    H.disconnect conn
    return result

insertClient :: String -> String -> IO Integer
insertClient name subdomain =
    withConn $ insertClientSQL name subdomain

countClient :: IO (Maybe Int)
countClient = withConn countClientSQL
