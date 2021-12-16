var express = require('express');
var router = express.Router();

//setup elastic connection
'use strict'
var url=`http://${process.env.ES_HOST}:${process.env.ES_PORT}/`
console.log(url)
const { Client } = require('@elastic/elasticsearch')
const client = new Client({
  // node: 'http://localhost:9200',
  node: url,

})

var health=null;

/* GET users listing. */
router.get('/', function(req, res, next) {
  run(function(err, result) {
      if (err) {
        console.log("error: "+err)
      }//dosomething}
      res.json(result);
      //res.render('health', { title: 'Client Health', data: result, });
  })
});

const run= function(callback){  
  client.cluster.health(
    {pretty: true},
    function(err,resp,status) { 
      if(err)
        callback(err, null)
      else {
        console.log("\n\n-- Client Health --",resp);
        callback(null, resp)
        //res.render('health', { title: 'Client Health', data: health });
      }
    }); 
}

module.exports = router;
