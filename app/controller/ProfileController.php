<?php

namespace app\controller {


    use app\service\Cloudinary;
    use app\service\R;
    use RudraX\Utils\Webapp;

    class ProfileController extends AbstractController
    {

        /**
         * @RequestMapping(url="u/{penname}/albums",method="GET",type="template")
         * @RequestParams(true)
         */
        public function userAlbums($model, $album_id = null, $penname = null, $user_id = null)
        {
            Cloudinary::use_smarty_tags();

            if (!is_null($penname)) {
                $blogger = R::findOne("user", "penname = ?", array($penname));
                if (!is_null($blogger)) {
                    $user_id = $blogger->id;
                } else {
                    return "no_user";
                }
            } elseif (!is_null($user_id)) {
                $blogger = R::load("user", $user_id);
                if (!is_null($blogger)) {
                    $penname = $blogger->penname;
                } else {
                    return "no_user";
                }
            } else if ($this->user->isValid()) {
                $penname = $this->user->uname;
                $user_id = $this->user->uid;
            }
            $model->assign("disqus_config",  $this->disqus($user_id,$penname,$penname."@piggy.com"));

            $model->assign("penname", $penname);
            $api = new ApiController();
            $api->setUser($this->user);
            $albums = $api->user_albums($user_id);

            $model->assign("albums", $albums);

            $model->assign("CAN_CREATE_ALBUM", $this->user->uid == $user_id);
            $model->assign("CAN_EDIT_ALBUM", false);

            if (!is_null($album_id)) {
                $images = $api->album_images($album_id);
                $thisalbum = null;
                foreach ($albums as $album) {
                    if ($album["id"] == $album_id) {
                        $thisalbum = $album;
                    }
                }
                if (is_null($thisalbum)) {
                    $thisalbum = $api->album_detail($album_id);
                }
                if (!is_null($thisalbum)) {
                    $model->assign("album", $thisalbum);
                    $model->assign("CAN_EDIT_ALBUM", $this->user->uid == $thisalbum["user_id"]);
                }
                //echo("===".$this->user->uid."====".$album["user_id"]);
                $model->assign("CAN_LIKE_PIC", $this->user->isValid());
                $model->assign("album_id", $album_id);
                $model->assign("images", $images);
                return "album_view";
            }
            return "albums";
        }


        /**
         * @RequestMapping(url="uid/{user_id}/album/{album_id}",method="GET",type="template")
         * @RequestParams(true)
         */
        public function userAlbumByUid($model, $album_id = null, $penname = null, $user_id = null)
        {
            return $this->userAlbums($model, $album_id, $penname, $user_id);

        }

        /**
         * @RequestMapping(url="u/{penname}/album/{album_id}",method="GET",type="template")
         * @RequestParams(true)
         */
        public function userAlbum($model, $album_id = null, $penname = null, $user_id = null)
        {
            return $this->userAlbums($model, $album_id, $penname, $user_id);

        }

        /**
         * @RequestMapping(url="u/search",type="template")
         * @RequestParams(true)
         */
        public function userSearch($model, $penname = null)
        {
            header("Location: /u/" . $penname . "/albums");
            exit();
        }


        public function dsq_hmacsha1($data, $key)
        {
            $blocksize = 64;
            $hashfunc = 'sha1';
            if (strlen($key) > $blocksize)
                $key = pack('H*', $hashfunc($key));
            $key = str_pad($key, $blocksize, chr(0x00));
            $ipad = str_repeat(chr(0x36), $blocksize);
            $opad = str_repeat(chr(0x5c), $blocksize);
            $hmac = pack(
                'H*', $hashfunc(
                    ($key ^ $opad) . pack(
                        'H*', $hashfunc(
                            ($key ^ $ipad) . $data
                        )
                    )
                )
            );
            return bin2hex($hmac);
        }

        public function disqus($user_id, $penname, $email)
        {
            define('DISQUS_SECRET_KEY', 'ybmbJS0zJmtOkzBNa13rAGMnkOABh2hidUZbEkF03L0UlsXuTfcis5WFBteJoXVX');
            define('DISQUS_PUBLIC_KEY', 'COPuPVskaqDdKIFkg1O8qCpALScaUOniLj2m3cRWdQtSGUuHE4Bwj9A5bX4R6D2V');

            $data = array(
                "id" => $user_id,
                "username" => $penname,
                "email" => $email
            );

            $message = base64_encode(json_encode($data));
            $timestamp = time();

            return array(
                "message" => $message,
                "timestamp" => $timestamp,
                "hmac" => $this->dsq_hmacsha1($message . ' ' . $timestamp, DISQUS_SECRET_KEY),
                "DISQUS_SECRET_KEY" => DISQUS_SECRET_KEY,
                "DISQUS_PUBLIC_KEY" => DISQUS_PUBLIC_KEY
            );
        }
    }
}
