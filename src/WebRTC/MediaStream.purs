module WebRTC.MediaStream
( MediaStream(..)
, MediaStreamTrack(..)
, MediaStreamConstraints(..)
, USER_MEDIA()
, hasUserMedia
, getUserMedia
, stopMediaStream
, playAudioStream
, mediaStreamToBlob
, createObjectURL
) where


import Prelude (Unit())
import Unsafe.Coerce (unsafeCoerce)
import Control.Monad.Aff (Aff(), makeAff)
import Control.Monad.Eff (Eff())
import Control.Monad.Eff.Exception (Error())
import DOM.File.Types (Blob)


foreign import data MediaStream :: *
foreign import data MediaStreamTrack :: *
foreign import data USER_MEDIA :: !

foreign import createObjectURL :: forall e. Blob -> Eff e String

foreign import hasUserMedia :: Boolean
foreign import _getUserMedia
  :: forall e. (MediaStream -> Eff e Unit) ->
               (Error -> Eff e Unit) ->
               MediaStreamConstraints ->
               Eff e Unit


foreign import stopMediaStream :: forall e. MediaStream -> Eff (userMedia :: USER_MEDIA | e) Unit
foreign import playAudioStream :: forall e. MediaStream -> Eff (userMedia :: USER_MEDIA | e ) Unit


newtype MediaStreamConstraints =
    MediaStreamConstraints { video :: Boolean
                           , audio :: Boolean
                           }


getUserMedia :: forall e. MediaStreamConstraints -> Aff (userMedia :: USER_MEDIA | e) MediaStream
getUserMedia c = makeAff (\e s -> _getUserMedia s e c)


mediaStreamToBlob :: MediaStream -> Blob
mediaStreamToBlob = unsafeCoerce
