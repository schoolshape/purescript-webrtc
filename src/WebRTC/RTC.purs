module WebRTC.RTC
( RTCPeerConnection(..)
, hasRTC
, RTCSessionDescription(..)
, Ice(..)
, IceEvent(..)
, MediaStreamEvent(..)
, RTCIceCandidate(..)
, RTCDataChannel(..)
, newRTCPeerConnection
, closeRTCPeerConnection
, addStream
, onicecandidate
, onaddstream
, createOffer
, createAnswer
, setLocalDescription
, setRemoteDescription
, newRTCSessionDescription
, iceEventCandidate
, addIceCandidate
, createDataChannel
, send
, onmessage
, ondatachannel
, onopen
, onclose
) where

import Prelude (Unit(), unit)
import Control.Monad.Aff (Aff(), makeAff)
import Control.Monad.Eff (Eff())
import Control.Monad.Eff.Exception (Error())
import Data.Maybe (Maybe(..))

import WebRTC.MediaStream

foreign import hasRTC :: Boolean

foreign import data RTCPeerConnection :: *


type Ice =
  { iceServers :: Array { url :: String, username :: String, credential :: String } }


foreign import newRTCPeerConnection
  :: forall e. Ice -> Eff e RTCPeerConnection


foreign import closeRTCPeerConnection
  :: forall e. RTCPeerConnection -> Eff e Unit


foreign import onclose
  :: forall e. Eff e Unit -> RTCPeerConnection -> Eff e Unit


foreign import addStream
  :: forall e. MediaStream -> RTCPeerConnection -> Eff e Unit


foreign import data IceEvent :: *


type RTCIceCandidate = { sdpMLineIndex :: Int
                       , sdpMid :: String
                       , candidate :: String
                       }


foreign import _iceEventCandidate
  :: forall a. Maybe a ->
               (a -> Maybe a) ->
               IceEvent ->
               Maybe RTCIceCandidate


iceEventCandidate :: IceEvent -> Maybe RTCIceCandidate
iceEventCandidate = _iceEventCandidate Nothing Just


foreign import addIceCandidate
  :: forall e. RTCIceCandidate ->
               RTCPeerConnection ->
               Eff e Unit


foreign import onicecandidate
  :: forall e. (IceEvent -> Eff e Unit) ->
               RTCPeerConnection ->
               Eff e Unit


type MediaStreamEvent = { stream :: MediaStream }


foreign import onaddstream
  :: forall e. (MediaStreamEvent -> Eff e Unit) ->
               RTCPeerConnection ->
               Eff e Unit


foreign import data RTCSessionDescription :: *


foreign import newRTCSessionDescription
  :: { sdp :: String, "type" :: String } -> RTCSessionDescription


foreign import _createOffer
  :: forall e. (RTCSessionDescription -> Eff e Unit) ->
               (Error -> Eff e Unit) ->
               RTCPeerConnection ->
               Eff e Unit


createOffer :: forall e. RTCPeerConnection -> Aff e RTCSessionDescription
createOffer pc = makeAff (\e s -> _createOffer s e pc)


foreign import _createAnswer
  :: forall e. (RTCSessionDescription -> Eff e Unit) ->
               (Error -> Eff e Unit) ->
               RTCPeerConnection ->
               Eff e Unit


createAnswer :: forall e. RTCPeerConnection -> Aff e RTCSessionDescription
createAnswer pc = makeAff (\e s -> _createAnswer s e pc)


foreign import _setLocalDescription
  :: forall e. Eff e Unit ->
               (Error -> Eff e Unit) ->
               RTCSessionDescription ->
               RTCPeerConnection ->
               Eff e Unit


setLocalDescription :: forall e. RTCSessionDescription -> RTCPeerConnection -> Aff e Unit
setLocalDescription desc pc = makeAff (\e s -> _setLocalDescription (s unit) e desc pc)


foreign import _setRemoteDescription
  :: forall e. Eff e Unit ->
               (Error -> Eff e Unit) ->
               RTCSessionDescription ->
               RTCPeerConnection ->
               Eff e Unit


setRemoteDescription :: forall e. RTCSessionDescription -> RTCPeerConnection -> Aff e Unit
setRemoteDescription desc pc = makeAff (\e s -> _setRemoteDescription (s unit) e desc pc)


foreign import data RTCDataChannel :: *

foreign import createDataChannel
  :: forall e. String -> RTCPeerConnection -> Eff e RTCDataChannel

foreign import send
  :: forall e. String -> RTCDataChannel -> Eff e Unit

foreign import onmessage
  :: forall e. (String -> Eff e Unit) -> RTCDataChannel -> Eff e Unit

foreign import ondatachannel
  :: forall e. (RTCDataChannel -> Eff e Unit) ->
               RTCPeerConnection ->
               Eff e Unit

foreign import onopen
  :: forall e. (Eff e Unit) -> RTCDataChannel -> Eff e Unit

