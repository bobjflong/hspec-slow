module Paths_hspec_slow (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/bob/hspec-slow/.stack-work/install/x86_64-osx/lts-5.12/7.10.3/bin"
libdir     = "/Users/bob/hspec-slow/.stack-work/install/x86_64-osx/lts-5.12/7.10.3/lib/x86_64-osx-ghc-7.10.3/hspec-slow-0.1.0.0-4IgkMxl3I7R95RltXPXsx5"
datadir    = "/Users/bob/hspec-slow/.stack-work/install/x86_64-osx/lts-5.12/7.10.3/share/x86_64-osx-ghc-7.10.3/hspec-slow-0.1.0.0"
libexecdir = "/Users/bob/hspec-slow/.stack-work/install/x86_64-osx/lts-5.12/7.10.3/libexec"
sysconfdir = "/Users/bob/hspec-slow/.stack-work/install/x86_64-osx/lts-5.12/7.10.3/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "hspec_slow_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "hspec_slow_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "hspec_slow_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "hspec_slow_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "hspec_slow_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
