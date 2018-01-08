module Hashmir.DataSpec where

import SpecHelper

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

spec :: Spec
spec = do
    describe "Hashmir Data" $ do
        it "creates a Client record" $ do
            withRollbackConn (\conn -> do
                clientId <- D.insertClient "TestClient" "testclient" conn
                clientId `shouldBe` 1)

main :: IO ()
main = hspec spec
