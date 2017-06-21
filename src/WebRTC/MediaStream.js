// module WebRTC.MediaStream
//
exports.hasUserMedia = (typeof navigator === "object") && (typeof navigator.mediaDevices === "object") && (typeof navigator.mediaDevices.getUserMedia === "function")

exports._getUserMedia = function(success) {
    return function(error) {
        return function(constraints) {
            return function() {
                navigator.mediaDevices.getUserMedia(constraints)
                    .then(function(mediaStream) {
                      success(mediaStream)();
                    })
                    .catch(function(e) {
                      error(e)();
                    });
            };
        };
    };
};


exports.stopMediaStream = function(mediaStream) {
    return function() {
        if (mediaStream.stop)
            mediaStream.stop();
        else {
            mediaStream.getAudioTracks().forEach(function (track) {
                track.stop();
            });
            mediaStream.getVideoTracks().forEach(function (track) {
                track.stop();
            });
        }
    };
};


exports.playAudioStream = function(mediaStream) {
    return function() {
		console.log('Create stream player');
        var player = new Audio();
        player.autoplay = true;
		player.srcObject = mediaStream;
    };
};


exports.createObjectURL = function(blob) {
    return function() {
        return URL.createObjectURL(blob);
    };
};
