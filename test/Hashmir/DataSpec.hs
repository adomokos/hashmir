module Hashmir.DataSpec where

import Test.Hspec

main :: IO ()
main = hspec spec

spec :: Spec
spec = do
    describe "Hashmir Data" $ do
        it "runs a test" $ do
            True `shouldBe` True
