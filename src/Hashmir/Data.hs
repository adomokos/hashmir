{-#LANGUAGE TemplateHaskell #-}
{-#LANGUAGE QuasiQuotes #-}

module Hashmir.Data where

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
    ;;;
    -- name:insertUserSQL
    -- :client_id :: Integer
    -- :login :: String
    -- :email :: String
    -- :password :: String
    INSERT INTO users (client_id, login, email, password)
    VALUES (:client_id, :login, :email, :password);
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

insertClient :: String -> String -> IO Integer
insertClient name subdomain =
    withConn $ insertClientSQL name subdomain

insertUser :: Integer -> String -> String -> String -> IO Integer
insertUser clientId login email password =
    withConn $ insertUserSQL clientId login email password

countClient :: IO (Maybe Int)
countClient = withConn countClientSQL
