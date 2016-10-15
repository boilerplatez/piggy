<?php

namespace app\services {

    use \RedBeanPHP\R;

    class AppService
    {

        public static $CONNECTED = false;

        public static function DBSetup()
        {
            $config = \Config::getSection("DB1");
            if(!self::$CONNECTED){
                R::setup('mysql:host='.$config['host'].';dbname='.$config['dbname'], $config['username'], $config['password']);
                self::$CONNECTED = true;
            }
        }

        public  static function sso (){
            $config = \Config::getSection("OAUTH_CONFIG");
            ParichyaClient::setup(array(
                "server_url" => $config["SERVER"],
                "broker_id" => $config["BROKER_ID"],
                "broker_secret" => $config["BROKER_SECRET"]
            ));
        }

    }
}


