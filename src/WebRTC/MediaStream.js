// module WebRTC.MediaStream

exports._getUserMedia = function(success) {
    return function(error) {
        return function(constraints) {
            return function() {
                var mediaDevicesGetUserMedia = null;
                if (typeof navigator.mediaDevices != "undefined") {
                    mediaDevicesGetUserMedia =
                        function (constraints, success,error) {
                            navigator.mediaDevices.getUserMedia(constraints).then(success).catch(error);
                        };

                }
                else {
                    mediaDevicesGetUserMedia = null;
                }
                var getUserMedia = mediaDevicesGetUserMedia
                        || navigator.getUserMedia
                        || navigator.webkitGetUserMedia
                        || navigator.mozGetUserMedia;

                return getUserMedia.call(
                    navigator,
                    constraints,
                    function(r) { success(r)(); },
                    function(e) { error(e)(); }
                );
            };
        };
    };
};

exports.createObjectURL = function(blob) {
    return function() {
        return URL.createObjectURL(blob);
    };
};

exports.getTracks = function(stream) {
    stream.getTracks();
};
