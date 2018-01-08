module Main where

import qualified Hashmir.Data as D
import qualified Database.HDBC as H
import qualified Database.HDBC.MySQL as HM

withRollbackConn :: (HM.Connection
                           -> IO b)
                          -> IO b
withRollbackConn f = do
    conn <- D.getConn
    result <- f conn
    H.rollback conn
    H.disconnect conn
    return result

main :: IO ()
main = do
    withRollbackConn (\conn -> do
        clientId <- D.insertClient "TestClient" "testclient" conn
        putStrLn $ "New client's id is " ++ show clientId
        Just clientCount <- D.countClientSQL conn
        putStrLn $ "There are " ++ show clientCount ++ " records.")
    return ()
