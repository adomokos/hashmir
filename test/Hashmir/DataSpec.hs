module Hashmir.DataSpec where

import SpecHelper

import qualified Hashmir.Data as D

spec :: Spec
spec = do
    describe "Hashmir Data" $ do
        it "creates a Client record" $ do
            clientId <- D.insertClient "TestClient" "testclient"
            clientId `shouldBe` 1

main :: IO ()
main = hspec spec
