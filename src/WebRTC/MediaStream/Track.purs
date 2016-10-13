module WebRTC.MediaStream.Track  where

import Prelude (Unit())
import Unsafe.Coerce (unsafeCoerce)
import Control.Monad.Aff (Aff(), makeAff)
import Control.Monad.Eff (Eff())
import Control.Monad.Eff.Exception (Error())

foreign import data MediaStreamTrack :: *

foreign import stop :: forall eff. MediaStreamTrack -> Eff eff Unit
