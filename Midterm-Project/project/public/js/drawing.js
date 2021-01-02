var creditScores = [750, 2, 3, 4, 5, 6];
var creditLevel = ["Excellent Citizen", "Good Citizen", "Normal Citizen", "Bad Citizen"];
var detectionAccuracy;

function resizeCanvasAndResults(dimensions, canvas, results) {
  const { width, height } = dimensions instanceof HTMLVideoElement
    ? faceapi.getMediaDimensions(dimensions)
    : dimensions
  canvas.width = width
  canvas.height = height

  // resize detections (and landmarks) in case displayed image is smaller than
  // original size
  return faceapi.resizeResults(results, { width, height })
}

function drawDetections(dimensions, canvas, detections) {
  const resizedDetections = resizeCanvasAndResults(dimensions, canvas, detections);
  //console.log(detections);
  faceapi.drawDetection(canvas, resizedDetections)
  faceapi.drawText(canvas.getContext('2d'), detections[0].box._x, detections[0].box._y, 'person detected');
  detectionAccuracy = detections[0]._score;
  //console.log(detectionAccuracy);
}

function drawExpressions(dimensions, canvas, results, thresh, withBoxes = true) {
  const resizedResults = resizeCanvasAndResults(dimensions, canvas, results)

  if (withBoxes) {
    faceapi.drawDetection(canvas, resizedResults.map(det => det.detection), { withScore: false })
  }

  faceapi.drawFaceExpressions(canvas, resizedResults.map(({ detection, expressions }) => ({ position: detection.box, expressions })))
}

function drawLandmarks(dimensions, canvas, results, withBoxes = true) {
  const resizedResults = resizeCanvasAndResults(dimensions, canvas, results)

  if (withBoxes) {
    faceapi.drawDetection(canvas, resizedResults.map(det => det.detection))
  }

  const faceLandmarks = resizedResults.map(det => det.landmarks)
  const drawLandmarksOptions = {
    lineWidth: 2,
    drawLines: true,
    color: 'green'
  }
  faceapi.drawLandmarks(canvas, faceLandmarks, drawLandmarksOptions)
}