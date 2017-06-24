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
import Control.Monad.Aff (Aff, makeAff)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception (Error)
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
  :: forall e. RTCConfiguration -> Eff e RTCPeerConnection


foreign import closeRTCPeerConnection
  :: forall e. RTCPeerConnection -> Eff e Unit


foreign import onclose
  :: forall e. Eff e Unit -> RTCPeerConnection -> Eff e Unit


foreign import addStream
  :: forall e. MediaStream -> RTCPeerConnection -> Eff e Unit


-- Getting the signalling state
foreign import _signalingState :: forall e. RTCPeerConnection -> Eff e String


stringToRTCSignalingState :: String -> RTCSignalingState
stringToRTCSignalingState =
  case _ of
    "stable"               -> Stable
    "have-local-offer"     -> HaveLocalOffer
    "have-remote-offer"    -> HaveRemoteOffer
    "have-local-pranswer"  -> HaveLocalProvisionalAnswer
    "have-remote-pranswer" -> HaveRemoteProvisionalAnswer
    other                  -> UnknownValue other

signalingState :: forall e. RTCPeerConnection -> Eff e RTCSignalingState
signalingState pc = stringToRTCSignalingState <$> _signalingState pc



foreign import data IceEvent :: Type


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


type RTCTrackEvent = { streams :: Array MediaStream, track :: MediaStreamTrack }


foreign import ontrack
  :: forall e. (RTCTrackEvent -> Eff e Unit) ->
               RTCPeerConnection ->
               Eff e Unit


foreign import data RTCSessionDescription :: Type


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


foreign import data RTCDataChannel :: Type

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

