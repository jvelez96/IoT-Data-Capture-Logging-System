//users.js
// Service to manage user authentication and register process
var config = require("../config/config")();

// Handle login in aplication
exports.login = function(req, res){
    console.log(req.body);
    if(req.body.username && req.body.password){
      User.findOne({username: req.body.username, password: req.body.password}, function (err, user) {
          if (err) //Erro da base de dados
              res.json(err);
          else if(user){ //User e password encontrados, login bem sucedido
              res.json({
                  status: "success",
                  data: user
              });
          } else{ //Não foi encontrado registo pretendido -> Login incorrecto
              res.json({
                  status: "failed",
                  message: "Username Password pair is incorrect!"
              });
          }
      });
    } else{ //Não foi enviado um dos campos necessários
      res.json({
          status: "failed",
          message: "Please provide a username and password!"
      });
    }
};
