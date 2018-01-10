module Hashmir.DataSpec where

import SpecHelper
import qualified Hashmir.Data as D

main :: IO ()
main = hspec spec

spec :: Spec
spec = before resetDB $ do
    describe "Hashmir Data" $ do
        it "creates a Client record" $ do
            clientId <- D.insertClient "TestClient" "testclient"
            clientId `shouldBe` 1
        it "creates a Client and a User record" $ do
            clientId <- D.insertClient "TestClient" "testclient"
            userId <- D.insertUser clientId "joe" "joe@example.com" "password1"
            userId `shouldBe` 1
