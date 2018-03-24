module WebRTC.MediaRecorder where

import Prelude

import Control.Monad.Aff (Aff)
import Control.Monad.Aff.Compat (EffFnAff, fromEffFnAff)
import Control.Monad.Eff (Eff, kind Effect)
import DOM.File.Types (Blob)
import Data.MediaType (MediaType)
import WebRTC.MediaStream (MediaStream)


foreign import data MediaRecorder :: Type
foreign import data MEDIA_RECORDER :: Effect


data MediaRecorderOptions
    = MediaRecorderOptions
        { mimeType :: MediaType
        , audioBitsPerSecond :: Number
        , videoBitsPerSecond :: Number
        }
    | NoMediaRecorderOptions


type DataHandler e = Blob -> Eff e Unit
type MREff e = (mediaRecorder :: MEDIA_RECORDER | e)


foreign import hasMediaRecorder :: Boolean
foreign import mediaRecorder
    :: ∀ e. MediaStream ->
                 MediaRecorderOptions ->
                 DataHandler e ->
                 Eff (MREff e) MediaRecorder

foreign import start :: ∀ e. MediaRecorder -> Eff (MREff e) Unit
foreign import stop  :: ∀ e. MediaRecorder -> Eff (MREff e) Unit
foreign import onRecordStop_ :: ∀ e. MediaRecorder -> EffFnAff e Unit


onRecordStop :: ∀ e. MediaRecorder -> Aff e Unit
onRecordStop = fromEffFnAff <<< onRecordStop_
