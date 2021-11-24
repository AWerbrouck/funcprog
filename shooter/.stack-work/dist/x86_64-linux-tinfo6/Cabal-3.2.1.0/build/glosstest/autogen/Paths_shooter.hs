{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_shooter (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,0,1] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/swamp/Documents/unief/funcprog/shooter/.stack-work/install/x86_64-linux-tinfo6/3b62b258a18f1235b30981ab96e76664b669dcb7ded7705e10fbd2d026f21e6f/8.10.7/bin"
libdir     = "/home/swamp/Documents/unief/funcprog/shooter/.stack-work/install/x86_64-linux-tinfo6/3b62b258a18f1235b30981ab96e76664b669dcb7ded7705e10fbd2d026f21e6f/8.10.7/lib/x86_64-linux-ghc-8.10.7/shooter-0.0.1-IaacNID0dMp2KOQOqZYCSm-glosstest"
dynlibdir  = "/home/swamp/Documents/unief/funcprog/shooter/.stack-work/install/x86_64-linux-tinfo6/3b62b258a18f1235b30981ab96e76664b669dcb7ded7705e10fbd2d026f21e6f/8.10.7/lib/x86_64-linux-ghc-8.10.7"
datadir    = "/home/swamp/Documents/unief/funcprog/shooter/.stack-work/install/x86_64-linux-tinfo6/3b62b258a18f1235b30981ab96e76664b669dcb7ded7705e10fbd2d026f21e6f/8.10.7/share/x86_64-linux-ghc-8.10.7/shooter-0.0.1"
libexecdir = "/home/swamp/Documents/unief/funcprog/shooter/.stack-work/install/x86_64-linux-tinfo6/3b62b258a18f1235b30981ab96e76664b669dcb7ded7705e10fbd2d026f21e6f/8.10.7/libexec/x86_64-linux-ghc-8.10.7/shooter-0.0.1"
sysconfdir = "/home/swamp/Documents/unief/funcprog/shooter/.stack-work/install/x86_64-linux-tinfo6/3b62b258a18f1235b30981ab96e76664b669dcb7ded7705e10fbd2d026f21e6f/8.10.7/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "shooter_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "shooter_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "shooter_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "shooter_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "shooter_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "shooter_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
