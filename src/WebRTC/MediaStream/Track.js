
exports.stop = function(track) {
    return function () {
        track.stop();
    }
};
