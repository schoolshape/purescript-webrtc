module WebRTC.RTC
( RTCPeerConnection(..)
, hasRTC
, RTCSessionDescription(..)
, RTCIceServer(..)
, RTCConfiguration(..)
, IceEvent(..)
, RTCTrackEvent(..)
, RTCIceCandidate(..)
, RTCDataChannel(..)
, RTCSignalingState(..)
, newRTCPeerConnection
, defaultRTCConfiguration
, closeRTCPeerConnection
, addStream
, onicecandidate
, ontrack
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
, signalingState
) where

import Prelude

import Control.Monad.Aff (Aff)
import Control.Monad.Aff.Compat (EffFnAff, fromEffFnAff)
import Control.Monad.Eff (Eff)
import Data.Maybe (Maybe(..))
import WebRTC.MediaStream (MediaStream, MediaStreamTrack)

foreign import hasRTC :: Boolean

foreign import data RTCPeerConnection :: Type

data RTCIceServer
  = STUNServer { urls :: Array String }
  | TURNServer { urls :: Array String
               , username :: String
               , credential :: String
               }

data RTCSignalingState
  = Stable
  | HaveLocalOffer
  | HaveRemoteOffer
  | HaveLocalProvisionalAnswer
  | HaveRemoteProvisionalAnswer
  | UnknownValue String

derive instance eqRTCSignalingState :: Eq RTCSignalingState


type RTCConfiguration =
  { bundlePolicy :: Maybe String
  -- certificates :: (not yet implemented)
  , iceServers :: Array RTCIceServer
  , iceCandidatePoolSize :: Int
  , iceTransportPolicy :: String
  , peerIdentity :: Maybe String
  -- , rtcpMuxPolicy (at risk due to lack of implementor interest)
  }


defaultRTCConfiguration :: RTCConfiguration
defaultRTCConfiguration =
  { bundlePolicy: Nothing
  , iceServers: []
  , iceCandidatePoolSize: 0
  , iceTransportPolicy: "all"
  , peerIdentity: Nothing
  }


foreign import newRTCPeerConnection
  :: ∀ e. RTCConfiguration -> Eff e RTCPeerConnection


foreign import closeRTCPeerConnection
  :: ∀ e. RTCPeerConnection -> Eff e Unit


foreign import onclose
  :: ∀ e. Eff e Unit -> RTCPeerConnection -> Eff e Unit


foreign import addStream
  :: ∀ e. MediaStream -> RTCPeerConnection -> Eff e Unit


-- Getting the signalling state
foreign import _signalingState :: ∀ e. RTCPeerConnection -> Eff e String


stringToRTCSignalingState :: String -> RTCSignalingState
stringToRTCSignalingState =
  case _ of
    "stable"               -> Stable
    "have-local-offer"     -> HaveLocalOffer
    "have-remote-offer"    -> HaveRemoteOffer
    "have-local-pranswer"  -> HaveLocalProvisionalAnswer
    "have-remote-pranswer" -> HaveRemoteProvisionalAnswer
    other                  -> UnknownValue other

signalingState :: ∀ e. RTCPeerConnection -> Eff e RTCSignalingState
signalingState pc = stringToRTCSignalingState <$> _signalingState pc


foreign import data IceEvent :: Type


type RTCIceCandidate = { sdpMLineIndex :: Int
                       , sdpMid :: String
                       , candidate :: String
                       }


foreign import _iceEventCandidate
  :: ∀ a. Maybe a ->
               (a -> Maybe a) ->
               IceEvent ->
               Maybe RTCIceCandidate


iceEventCandidate :: IceEvent -> Maybe RTCIceCandidate
iceEventCandidate = _iceEventCandidate Nothing Just


foreign import addIceCandidate
  :: ∀ e. RTCIceCandidate ->
               RTCPeerConnection ->
               Eff e Unit


foreign import onicecandidate
  :: ∀ e. (IceEvent -> Eff e Unit) ->
               RTCPeerConnection ->
               Eff e Unit


type RTCTrackEvent = { streams :: Array MediaStream, track :: MediaStreamTrack }


foreign import ontrack
  :: ∀ e. (RTCTrackEvent -> Eff e Unit) ->
               RTCPeerConnection ->
               Eff e Unit


foreign import data RTCSessionDescription :: Type


foreign import newRTCSessionDescription
  :: { sdp :: String, "type" :: String } -> RTCSessionDescription


foreign import _createOffer
  :: ∀ e. RTCPeerConnection -> EffFnAff e RTCSessionDescription


createOffer :: ∀ e. RTCPeerConnection -> Aff e RTCSessionDescription
createOffer = fromEffFnAff <<< _createOffer


foreign import _createAnswer
  :: ∀ e. RTCPeerConnection -> EffFnAff e RTCSessionDescription


createAnswer :: ∀ e. RTCPeerConnection -> Aff e RTCSessionDescription
createAnswer = fromEffFnAff <<< _createAnswer


foreign import _setLocalDescription
  :: ∀ e. RTCSessionDescription -> RTCPeerConnection -> EffFnAff e Unit


setLocalDescription :: ∀ e. RTCSessionDescription -> RTCPeerConnection -> Aff e Unit
setLocalDescription desc pc = fromEffFnAff $ _setLocalDescription desc pc


foreign import _setRemoteDescription
  :: ∀ e. RTCSessionDescription -> RTCPeerConnection -> EffFnAff e Unit


setRemoteDescription :: ∀ e. RTCSessionDescription -> RTCPeerConnection -> Aff e Unit
setRemoteDescription desc pc = fromEffFnAff $ _setRemoteDescription desc pc


foreign import data RTCDataChannel :: Type

foreign import createDataChannel
  :: ∀ e. String -> RTCPeerConnection -> Eff e RTCDataChannel

foreign import send
  :: ∀ e. String -> RTCDataChannel -> Eff e Unit

foreign import onmessage
  :: ∀ e. (String -> Eff e Unit) -> RTCDataChannel -> Eff e Unit

foreign import ondatachannel
  :: ∀ e. (RTCDataChannel -> Eff e Unit) ->
               RTCPeerConnection ->
               Eff e Unit

foreign import onopen
  :: ∀ e. (Eff e Unit) -> RTCDataChannel -> Eff e Unit

