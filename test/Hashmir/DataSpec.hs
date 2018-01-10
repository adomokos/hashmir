module Hashmir.DataSpec where

import SpecHelper
import qualified Hashmir.Data as D

main :: IO ()
main = hspec spec

spec :: Spec
spec = before resetDB $ do
    describe "Hashmir Data" $ do
        it "creates a Client record" $ do
            clientId <- D.withConn $ D.insertClient "TestClient" "testclient"
            clientId `shouldBe` 1
        it "creates a Client and a User record" $ do
            userId <- D.withConn (\conn -> do
                clientId <- D.insertClient "TestClient" "testclient" conn
                D.insertUser clientId "joe" "joe@example.com" "password1" conn)
            userId `shouldBe` 1
        it "rolls back the transaction when failure occurs" $ do
            (D.withConn (\conn -> do
                clientId <- D.insertClient "TestClient" "testclient" conn
                D.insertUser (clientId+1) "joe" "joe@example.com" "password1" conn))
                `shouldThrow` anyException
            clientCount <- D.withConn $ D.countClientSQL
            clientCount `shouldBe` Just 0
