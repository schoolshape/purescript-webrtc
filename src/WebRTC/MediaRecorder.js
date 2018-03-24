// module WebRTC.MediaRecorder
//
exports.hasMediaRecorder = (typeof MediaRecorder !== "undefined")

exports.mediaRecorder = function(mediaStream) {
    return function(options) {
        return function(onDataAvailable) {
            return function() {
                console.log(mediaStream);
                var recorder = new MediaRecorder(mediaStream, options);
                recorder.ondataavailable = function(event) {
                    onDataAvailable(event)();
                };

                // Stop the recorder when all tracks stop
                var activeTracks = 0;
                mediaStream.getTracks().forEach(function(track) {
                    activeTracks += 1;
                    track.onended = function(ev) {
                        activeTracks -= 1;
                        if (activeTracks === 0) {
                            exports.stop(recorder)();
                        }
                    };
                });

                return recorder;
            };
        };
    };
};


exports.start = function(recorder) {
    return function() { recorder.start(); };
};


exports.stop = function(recorder) {
    return function() {
        if (recorder.state !== "inactive")
            recorder.stop();
    };
};


exports.onRecordStop_ = function(recorder) {
    return function(onError, onSuccess) { recorder.onstop = onSuccess; };
};
