// module WebRTC.MediaRecorder
//

exports.mediaRecorder = function(mediaStream) {
    return function(options) {
        return function(onDataAvailable) {
            return function() {
                var recorder = new MediaRecorder(mediaStream, options);
                recorder.ondataavailable = function(event) {
                    onDataAvailable(event)();
                };
                return recorder;
            };
        };
    };
};


exports.start = function(recorder) {
    return function() { recorder.start(); };
};


exports.stop = function(recorder) {
    return function() { recorder.stop(); };
};

