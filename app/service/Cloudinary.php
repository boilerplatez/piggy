<?php

namespace app\service {

    class Cloudinary extends \Cloudinary
    {
        public static $RX_CONNECTED = false;

        public static function rx_setup()
        {
            if (!self::$RX_CONNECTED) {

                $config = \Config::get("CLOUDINARY_CONFIG");
                \Cloudinary::config(array(
                    "cloud_name" => $config["cloud_name"],
                    "api_key" => $config["api_key"],
                    "api_secret" => $config["api_secret"]
                ));
                self::$RX_CONNECTED = true;
            }

        }

        public static function use_smarty_tags()
        {
           return Smarty::addPluginsDir("../plugins");
        }

        public static function js_config()
        {
            return cloudinary_js_config();
        }

        public static function image_upload_tag($field, $options = array())
        {
            return cl_image_upload_tag($field, $options);
        }

        public static function image_tag($source, $options)
        {
            return cl_image_tag($source, $options);
        }


    }

    Cloudinary::rx_setup();
}


