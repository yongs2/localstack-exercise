console.log('function starts')

const AWS = require('aws-sdk')

const docClient = new AWS.DynamoDB.DocumentClient({
  region: process.env.AWS_REGION,
  accessKeyId: process.env.AWS_ACCESS_KEY_ID,
  secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
  endpoint: process.env.AWS_ENDPOINT_URL,
});

exports.handler = function (event, context, callback) {
  console.log('processing event data: ' + JSON.stringify(event.body, null, 2))

  let data = JSON.parse(event.body)
  console.log('data is : ' + data)

  let params = {
    Item: {
      Date: Date.now(),
      Author: data.author ? data.author : "Anonymous",
      Tip: data.tip,
      Category: data.category
    },

    TableName: 'CodingTips'
  };

  console.log('Putting item in database : ' + JSON.stringify(params.Item))
  docClient.put(params, function (err, data) {
    if (err) {
      callback(err, null)
    } else {
      console.log(JSON.stringify(data))
      let response = {
        "statusCode": 200,
        "headers": {
          "Content-Type": "application/json"
        },
        "body": JSON.stringify(data)
      };
      callback(null, response);
    }
  });
}
