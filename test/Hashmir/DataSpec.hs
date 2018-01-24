module Hashmir.DataSpec where

import Test.Hspec
import System.Process
import qualified Hashmir.Data as D

main :: IO ()
main = hspec spec

resetDB :: IO ()
resetDB = callCommand "make build-db"

spec :: Spec
spec = before resetDB $ do
    describe "Hashmir Data" $ do
        it "creates a Client record" $ do
            clientId <- D.insertClient "TestClient" "testclient"
            clientId `shouldBe` 1
