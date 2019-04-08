const express = require('express')
const path = require('path')
const Request = require('request')
const bodyParser = require('body-parser')
const app = express()

app.use(express.json())
app.use(express.urlencoded({ extended: true }))

const viewsDir = path.join(__dirname, 'views')
app.use(express.static(viewsDir))
app.use(express.static(path.join(__dirname, './public')))
app.use(express.static(path.join(__dirname, '../images')))
app.use(express.static(path.join(__dirname, '../media')))
app.use(express.static(path.join(__dirname, '../../weights')))
app.use(express.static(path.join(__dirname, '../../dist')))

app.use(bodyParser.json())
// /*---------------
// //DATABASE CONFIG
// ----------------*/
const cloudant_USER = '4201d5b5-ff6e-4e5a-a738-7a2c7d9876f9-bluemix'
const cloudant_DB = 'mashups'
const cloudant_KEY = 'illipseversencentiatedus'
const cloudant_PASSWORD = '5c0f604ce5c3cf740ff84e7ebb46b5bee1c4017e'
const cloudant_URL = "https://" + cloudant_USER + ".cloudant.com/" + cloudant_DB

var personRev;
var personId;
var scoreChange;


app.use(function(req, res, next) { 
  res.header("Access-Control-Allow-Origin", "*"); 
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept"); 
  next();
});


app.get('/', (req, res) => res.redirect('/webcam_face_detection'))
app.get('/webcam_face_detection', (req, res) => res.sendFile(path.join(viewsDir, 'webcamFaceDetection_emotion.html')))
app.get('/webcam_face_detection_2', (req, res) => res.sendFile(path.join(viewsDir, 'webcamFaceDetection_reward.html')))

app.post('/fetch_external_image', async (req, res) => {
  const { imageUrl } = req.body
  if (!imageUrl) {
    return res.status(400).send('imageUrl param required')
  }
  try {
    const externalResponse = await request(imageUrl)
    res.set('content-type', externalResponse.headers['content-type'])
    return res.status(202).send(Buffer.from(externalResponse.body))
  } catch (err) {
    return res.status(404).send(err.toString())
  }
})

app.post("/save", (req,res) => {
  console.log("A POST!!!!");
  //Get the data from the body
  var data = req.body;
  //console.log(data);

  // res.json({msg: "Yes!"});

  //Send the data to the db
  Request.post({
    url: cloudant_URL,
    auth: {
      user: cloudant_KEY,
      pass: cloudant_PASSWORD
    },
    json: true,
    body: data
  },
  (error, response, body) => {
    if (response.statusCode == 201){
      console.log("Saved!");
      res.json(body);
    }
    else{
      console.log("Uh oh...");
      console.log("Error: " + res.statusCode);
      res.send("Something went wrong...");
    }
  });
});

// //JSON Serving route - Serve ALL Data
app.get("/api/all", (req,res) => {
  console.log('Making a db request for all entries');
  //Use the Request lib to GET the data in the CouchDB on Cloudant
  Request.get({
    url: cloudant_URL+"/_all_docs?include_docs=true",
    auth: {
      user: cloudant_KEY,
      pass: cloudant_PASSWORD
    },
    json: true
  },
  (error, response, body) => {
    var theRows = body.rows;
    //Send all of the data
    res.json(theRows);
  });
});

app.post("/changeScore", (req,res) => {
  console.log("Getting score");
  //Get the data from the body
  var data = req.body;
  personId = data.personID;
  personRev = data.personREV;
  imgSame = data.imgString;
  numSame = data.personNumber,
  scoreChange = data.score;

  //console.log(data);

  var auth = {
      user: cloudant_KEY,
      pass: cloudant_PASSWORD
    };

  var putOptions = {
    url: cloudant_URL+"/"+personId,
    auth: {
      user: cloudant_KEY,
      pass: cloudant_PASSWORD
    },
    method: 'PUT',
    json: {
      '_rev': personRev,
      "imgString": imgSame,
      "personNumber": numSame,
      'score': scoreChange//where all of our data goes
    }
  };

  Request.put(putOptions, function(err, body){
    console.log("CHANGE MADE to database document") //should give you a message saying that you have successfully inserted
  });
});

app.listen(3000, () => console.log('Listening on port 3000!'))

function request(url, returnBuffer = true, timeout = 10000) {
  return new Promise(function(resolve, reject) {
    const options = Object.assign(
      {},
      {
        url,
        isBuffer: true,
        timeout,
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36'
        }
      },
      returnBuffer ? { encoding: null } : {}
    )

    Request.get(options, function(err, res) {
      if (err) return reject(err)
      return resolve(res)
    })
  })
}