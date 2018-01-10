module SpecHelper
    ( module Test.Hspec
    , resetDB
    ) where

import Test.Hspec
import System.Process

resetDB :: IO ()
resetDB = callCommand "make build-db"
