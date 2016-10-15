<?php
/**
 * Smarty plugin
 *
 * @package Smarty
 * @subpackage PluginsFunction
 */

/**
 * Smarty {seo} function plugin
 *
 * Type:     function<br>
 * Name:     seo<br>
 * Date:     Dic 05, 2012
 * Purpose:  seo url friendly.<br>
 * Params:
 * <pre>
 * - string - (required) - Title to friendly URL conversion
 * - divider - (required) - return good words separated by dashes
 * </pre>
 * Examples:
 * <pre>
 * {seo string="Lorem Ipsum"}
 * {seo string="Lorem Ipsum" divider="_"}
 * </pre>
 *
 * @version 1.0
 * @author Concetto Vecchio <info@cvsolutions.it>
 * @param array $params parameters
 * @param Smarty_Internal_Template $template template object
 * @return string
 */

$path2file = "/src/external/components/cloudinary/html";
$cors_location = null;

if (array_key_exists('REQUEST_SCHEME', $_SERVER)) {
    $cors_location = $_SERVER["REQUEST_SCHEME"] . "://" . $_SERVER["SERVER_NAME"] .
        dirname($_SERVER["SCRIPT_NAME"]) . $path2file . "/cloudinary_cors.html";
} else {
    $cors_location = "http://" . $_SERVER["HTTP_HOST"] . $path2file . "/cloudinary_cors.html";
}

function smarty_function_cl_image_upload_tag($params, $template)
{
    global $cors_location;
    return app\service\Cloudinary::image_upload_tag('image_id',
        array(
            // "notification_url" => "http://mysite/my_notification_endpoint",
            "callback" => $cors_location,
            "html" => array("multiple" => TRUE)
        ));
}