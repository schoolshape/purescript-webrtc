module WebRTC.MediaRecorder where

import Prelude

import Effect.Aff (Aff)
import Effect.Aff.Compat (EffectFnAff, fromEffectFnAff)
import Effect (Effect)
import Web.File.Blob (Blob)
import Data.MediaType (MediaType)
import WebRTC.MediaStream (MediaStream)


foreign import data MediaRecorder :: Type


data MediaRecorderOptions
    = MediaRecorderOptions
        { mimeType :: MediaType
        , audioBitsPerSecond :: Number
        , videoBitsPerSecond :: Number
        }
    | NoMediaRecorderOptions


type DataHandler = Blob -> Effect Unit


foreign import hasMediaRecorder :: Boolean
foreign import mediaRecorder :: MediaStream -> MediaRecorderOptions -> DataHandler -> Effect MediaRecorder

foreign import start :: MediaRecorder -> Effect Unit
foreign import stop  :: MediaRecorder -> Effect Unit
foreign import onRecordStop_ :: MediaRecorder -> EffectFnAff Unit


onRecordStop :: MediaRecorder -> Aff Unit
onRecordStop = fromEffectFnAff <<< onRecordStop_
