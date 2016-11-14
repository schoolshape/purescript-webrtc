module WebRTC.RTC (
  RTCPeerConnection(..)
, RTCSessionDescriptionInit
, RTCSessionDescription(..)
, Ice(..)
, IceEvent(..)
, MediaStreamEvent(..)
, RTCIceCandidateInit(..)
, RTCDataChannel(..)
, newRTCPeerConnection
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
, onmessageChannel
, fromRTCSessionDescription
) where

import Prelude
import Control.Monad.Aff (Aff, makeAff)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception (Error)
import Data.Maybe (Maybe(..))
import Data.Nullable (toMaybe, toNullable, Nullable)
import WebRTC.MediaStream (MediaStream)

foreign import data RTCPeerConnection :: *

type Ice = { iceServers :: Array { url :: String } }

foreign import newRTCPeerConnection
  :: forall e. Ice -> Eff e RTCPeerConnection

foreign import addStream
  :: forall e. MediaStream -> RTCPeerConnection -> Eff e Unit

foreign import data IceEvent :: *

type RTCIceCandidateInit = { sdpMLineIndex :: Maybe Int
                           , sdpMid :: Maybe String
                           , candidate :: String
                           }

type RTCIceCandidateInitJS = { sdpMLineIndex :: Nullable Int
                             , sdpMid :: Nullable String
                             , candidate :: String
                             }

iceCandidateToJS :: RTCIceCandidateInit -> RTCIceCandidateInitJS
iceCandidateToJS candidate = { sdpMLineIndex : toNullable candidate.sdpMLineIndex
                             , sdpMid : toNullable candidate.sdpMid
                             , candidate : candidate.candidate
                             }

iceCandidateFromJS :: RTCIceCandidateInitJS -> RTCIceCandidateInit
iceCandidateFromJS candidate = { sdpMLineIndex : toMaybe candidate.sdpMLineIndex
                               , sdpMid : toMaybe candidate.sdpMid
                               , candidate : candidate.candidate
                               }

foreign import _iceEventCandidate
  :: forall a. Maybe a ->
               (a -> Maybe a) ->
               IceEvent ->
               Maybe RTCIceCandidateInitJS

iceEventCandidate :: IceEvent -> Maybe RTCIceCandidateInit
iceEventCandidate = map iceCandidateFromJS <<< _iceEventCandidate Nothing Just

foreign import _addIceCandidate
  :: forall e. Nullable RTCIceCandidateInitJS
     -> RTCPeerConnection
     -> (Error -> Eff e Unit)
     -> (Unit -> Eff e Unit)
     -> Eff e Unit

addIceCandidate :: forall e. Maybe RTCIceCandidateInit
                   -> RTCPeerConnection
                   -> Aff e Unit
addIceCandidate candidate connection = makeAff (_addIceCandidate (toNullable <<< map iceCandidateToJS $ candidate) connection)

foreign import onicecandidate
  :: forall e. (IceEvent -> Eff e Unit) ->
               RTCPeerConnection ->
               Eff e Unit

type MediaStreamEvent = { stream :: MediaStream }

foreign import onaddstream
  :: forall e. (MediaStreamEvent -> Eff e Unit) ->
               RTCPeerConnection ->
               Eff e Unit


type RTCSessionDescriptionInit = { sdp :: String, "type" :: String }

-- Those should not be needed: -----------------
foreign import fromRTCSessionDescription :: RTCSessionDescription -> RTCSessionDescriptionInit
foreign import data RTCSessionDescription :: *
foreign import newRTCSessionDescription
  :: RTCSessionDescriptionInit -> RTCSessionDescription
----------------------------------

foreign import _createOffer
  :: forall e. (RTCSessionDescriptionInit -> Eff e Unit) ->
               (Error -> Eff e Unit) ->
               RTCPeerConnection ->
               Eff e Unit

createOffer :: forall e. RTCPeerConnection -> Aff e RTCSessionDescriptionInit
createOffer pc = makeAff (\e s -> _createOffer s e pc)

foreign import _createAnswer
  :: forall e. (RTCSessionDescriptionInit -> Eff e Unit) ->
               (Error -> Eff e Unit) ->
               RTCPeerConnection ->
               Eff e Unit

createAnswer :: forall e. RTCPeerConnection -> Aff e RTCSessionDescriptionInit
createAnswer pc = makeAff (\e s -> _createAnswer s e pc)

foreign import _setLocalDescription
  :: forall e. Eff e Unit ->
               (Error -> Eff e Unit) ->
               RTCSessionDescriptionInit ->
               RTCPeerConnection ->
               Eff e Unit

setLocalDescription :: forall e. RTCSessionDescriptionInit -> RTCPeerConnection -> Aff e Unit
setLocalDescription desc pc = makeAff (\e s -> _setLocalDescription (s unit) e desc pc)

foreign import _setRemoteDescription
  :: forall e. Eff e Unit ->
               (Error -> Eff e Unit) ->
               RTCSessionDescriptionInit ->
               RTCPeerConnection ->
               Eff e Unit

setRemoteDescription :: forall e. RTCSessionDescriptionInit -> RTCPeerConnection -> Aff e Unit
setRemoteDescription desc pc = makeAff (\e s -> _setRemoteDescription (s unit) e desc pc)

foreign import data RTCDataChannel :: *

foreign import createDataChannel
  :: forall e. String ->
               RTCPeerConnection ->
               Eff e RTCDataChannel

foreign import send
  :: forall e. String ->
               RTCDataChannel ->
               Eff e Unit

foreign import onmessageChannel
  :: forall e. (String -> Eff e Unit) ->
               RTCDataChannel ->
               Eff e Unit

foreign import close :: forall e. RTCPeerConnection -> Eff e Unit
