module WebRTC.MediaRecorder where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception (Error)
import DOM.File.Types (Blob)
import Data.MediaType (MediaType)
import WebRTC.MediaStream (MediaStream)


foreign import data MediaRecorder :: *
foreign import data MEDIA_RECORDER :: !


data MediaRecorderOptions
    = MediaRecorderOptions
        { mimeType :: MediaType
        , audioBitsPerSecond :: Number
        , videoBitsPerSecond :: Number
        }
    | NoMediaRecorderOptions


type DataHandler e = Blob -> Eff e Unit
type MREff e = (mediaRecorder :: MEDIA_RECORDER | e)


foreign import mediaRecorder
    :: forall e. MediaStream ->
                 MediaRecorderOptions ->
                 DataHandler e ->
                 Eff (MREff e) MediaRecorder

foreign import start :: forall e. MediaRecorder -> Eff (MREff e) Unit
foreign import stop  :: forall e. MediaRecorder -> Eff (MREff e) Unit
foreign import onRecordStop ::
  forall e. MediaRecorder -> (Error -> Eff e Unit) -> (Unit -> Eff e Unit) -> Eff e Unit
