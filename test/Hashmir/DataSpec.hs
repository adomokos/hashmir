module Hashmir.DataSpec where

import SpecHelper

spec :: Spec
spec = do
    describe "Hashmir Data" $ do
        it "creates a Client record" $ do
            let content = "Some simple text"

            True `shouldBe` True

main :: IO ()
main = hspec spec
