var port = process.env.PORT || 80,
    http = require('http'),
    fs = require('fs'),
	os = require('os')

// ======================================================================
// Here are some global config entries that change the behavior of the app
// ======================================================================
var buildNumber = 1;
var minSleep = 500;
var requestCount = 0;
var inProduction = false;
var invokeRequestCount = 0;
var failInvokeRequestPercentage = 0;

// ======================================================================
// does some init checks and sets variables!
// ======================================================================
var init = function(newBuildNumber) {
	// CHECK IF WE ARE RUNNING "In Production"
	inProduction = process.env.DEPLOYMENT_GROUP_NAME && process.env.DEPLOYMENT_GROUP_NAME.startsWith("Production");
	
	if(inProduction) {
		minSleep = 300; // we just simulate that production is a bit faster than staging, e.g: better hardware!
	}

	// here are some "problems" we simulate for different builds. Builds are identified via Env Variable BUILD_NUMBER;
	// Build # | Problem
	// 1 | no problem
	// 2 | 50% of requests return HTTP 500 Status Code
	// 3 | back to normal
	// 4 | no problem in staging but problem in prod -> higher sleep time and 10% of requests fail
	// X | any other build number will run like 1 & 3
	if(newBuildNumber != null) {
		buildNumber = parseInt(newBuildNumber);
	}
	else if(process.env.BUILD_NUMBER && process.env.BUILD_NUMBER != null) {
		buildNumber = parseInt(process.env.BUILD_NUMBER);
    }

	switch(buildNumber) {
		case 2:
			failInvokeRequestPercentage = 2;
			break;
		case 4: 
			if(inProduction) {
				minSleep = minSleep * 2;
				failInvokeRequestPercentage = 10;
			}
			break;
		default:
			// everything normal here
			failInvokeRequestPercentage = 0;		
			break;
	}

	console.log("Init: " + buildNumber + "/" + failInvokeRequestPercentage);
} 


// ======================================================================
// This is for logging
// ======================================================================
var logstream = fs.createWriteStream('./serviceoutput.log');
var SEVERITY_DEBUG = "Debug";
var SEVERITY_INFO = "Info";
var SEVERITY_WARNING = "Warning";
var SEVERITY_ERROR = "Error";

var log = function(severity, entry) {
	// console.log(entry);
	if (severity === SEVERITY_DEBUG) {
		// dont log debug
	} else {
		var logEntry = new Date().toISOString() + ' - ' + severity + " - " + entry + '\n';
		// fs.appendFileSync('./serviceoutput.log', new Date().toISOString() + ' - ' + severity + " - " + entry + '\n');
		logstream.write(logEntry);
	}
};

// ======================================================================
// Very inefficient way to "sleep"
// ======================================================================
function sleep(time) {
	if(time < minSleep) time = minSleep;
    var stop = new Date().getTime();
    while(new Date().getTime() < stop + time) {
        ;
    }
}

// ======================================================================
// This is our main HttpServer Handler
// /api/quoteoftheday -> returns a smart quote
// /api/echo?text=echotext -> simply echos the text back
// /api/version -> either sets or retrieves current build and version information
// /api/causeerror -> causes an ERROR -> will result in 
// ======================================================================
var server = http.createServer(function (req, res) {
    if (req.method === 'POST') {
        var body = '';

        req.on('data', function(chunk) {
            body += chunk;
        });

        req.on('end', function() {
            if (req.url === '/') {
                log(SEVERITY_DEBUG, 'Received message: ' + body);
            } else if (req.url = '/scheduled') {
                log(SEVERITY_DEBUG, 'Received task ' + req.headers['x-aws-sqsd-taskname'] + ' scheduled at ' + req.headers['x-aws-sqsd-scheduled-at']);
            }

            res.writeHead(200, 'OK', {'Content-Type': 'text/plain'});
            res.end();
        });
    } else if (req.url.startsWith("/api")) {
		var url = require('url').parse(req.url, true);
		var closeResponse = true;

        // sleep a bit :-)
		var sleeptime = parseInt(url.query["sleep"]);
		if(sleeptime === 0) sleeptime = minSleep;
		log(SEVERITY_DEBUG, "Sleeptime: " + sleeptime);
		sleep(sleeptime);

		// figure out which API call they want to execute
        var status = "Unkown API Call";
		if(url.pathname === "/api/sleeptime") {
			// Usage: /api/sleeptime?min=1234 
			var sleepValue = parseInt(url.query["min"]);
			if(sleepValue >= 0 && sleepValue <= 10000) minSleep = sleepValue;
			status = "Minimum Sleep Time set to " + minSleep;
		}
		if(url.pathname === "/api/echo") {
			// Usage: /api/echo?text=your text to be echoed!
			status = url.query["text"];
		}
		if(url.pathname === "/api/quoteoftheday") {
			// count the invokes for failed requests
			var returnStatusCode = 200;
			if(failInvokeRequestPercentage > 0) {
				invokeRequestCount++;
				var failRequest = (invokeRequestCount % failInvokeRequestPercentage);
				if(failRequest == 0) {
					returnStatusCode = 500;
					invokeRequestCount = 0;
				}
			}

			// get a random quote!
			status = "I was too lazy to implement a random quote generator. You gotta live with this one: Be Humble in Life!"
			
			var body = Buffer.concat(bodyChunks);
			log(SEVERITY_DEBUG, 'BODY: ' + body);
			status = "Request to '" + url.query["url"] + "' returned with HTTP Status: " + getResponse.statusCode + " and response body length: " + body.length;
			res.writeHead(returnStatusCode, returnStatusCode == 200 ? 'OK' : 'ERROR', {'Content-Type': 'text/plain'});	
			res.write(status);
			res.end();
		}
		if(url.pathname === "/api/version") {
			if (url.query["newBuildNumber"] && url.query["newBuildNumber"] != null) {
				var newBuildNumber = url.query["newBuildNumber"];
				log(SEVERITY_WARNING, "Somebody is changing! buildNumber from " + buildNumber + " to " + newBuildNumber);

				init(newBuildNumber);
			}

			// usage: /api/version
			// simply returns the build number as defined in BUILD_NUMBER env-variable which is specified
			status = "Running build number: " + buildNumber;
		}
		if(url.pathname === "/api/causeerror") {
			log(SEVERITY_ERROR, "somebody called /api/causeerror");
			status = "We just caused an error log entry"
		}

		// only close response handler if we are done with work!
		if(closeResponse) {
		   res.writeHead(200, 'OK', {'Content-Type': 'text/plain'});	
		   res.write(status);
		   res.end();
		}
	}
	else
	{
		res.writeHead(200, 'OK', {'Content-Type': 'text/html'});

		// replace buildnumber and background color
		var finalHtml = html.replace("BACKGROUND-COLOR", getBackgroundColor()).replace("BUILD_NUMBER", buildNumber);
        res.write(finalHtml);
        res.end();
	}
	
	requestCount++;
	if(requestCount >= 100) {
		log(SEVERITY_INFO, "Just served another 100 requests!");
		requestCount = 0;
	}
});

// first we initialize!
init(null);

// Listen on port 80, IP defaults to 127.0.0.1
server.listen(port);

// Put a friendly message on the terminal
console.log('Server running at http://127.0.0.1:' + port + '/');
log(SEVERITY_INFO, "Service is up and running - feed me with data!");