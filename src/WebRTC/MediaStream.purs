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


import Prelude
import Unsafe.Coerce (unsafeCoerce)
import Control.Monad.Aff (Aff)
import Control.Monad.Aff.Compat (EffFnAff, fromEffFnAff)
import Control.Monad.Eff (Eff(), kind Effect)
import DOM.File.Types (Blob)


foreign import data MediaStream :: Type
foreign import data MediaStreamTrack :: Type
foreign import data USER_MEDIA :: Effect

foreign import createObjectURL :: ∀ e. Blob -> Eff e String

foreign import hasUserMedia :: Boolean
foreign import _getUserMedia :: ∀ e. MediaStreamConstraints -> EffFnAff e MediaStream
foreign import stopMediaStream :: ∀ e. MediaStream -> Eff (userMedia :: USER_MEDIA | e) Unit
foreign import playAudioStream :: ∀ e. MediaStream -> Eff (userMedia :: USER_MEDIA | e ) Unit


newtype MediaStreamConstraints =
    MediaStreamConstraints { video :: Boolean
                           , audio :: Boolean
                           }


getUserMedia :: ∀ e. MediaStreamConstraints -> Aff (userMedia :: USER_MEDIA | e) MediaStream
getUserMedia = fromEffFnAff <<< _getUserMedia


mediaStreamToBlob :: MediaStream -> Blob
mediaStreamToBlob = unsafeCoerce
