// module WebRTC.MediaStream
//
exports.hasUserMedia = (navigator.mediaDevices && navigator.mediaDevices.getUserMedia && true) || false

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
        var url = URL.createObjectURL(mediaStream);
        var player = new Audio(url);
        player.autoplay = true;
    };
};


exports.createObjectURL = function(blob) {
    return function() {
        return URL.createObjectURL(blob);
    };
};
