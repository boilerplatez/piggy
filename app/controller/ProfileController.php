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
            } else if ($this->user->isValid()) {
                $penname = $this->user->uname;
                $user_id = $this->user->uid;
            }

            $model->assign("penname", $penname);
            $api = new ApiController();
            $api->setUser($this->user);
            $albums = $api->user_albums($user_id);

            $model->assign("albums", $albums);

            $model->assign("CAN_CREATE_ALBUM", $this->user->uid == $user_id);

            if (!is_null($album_id)) {
                $images = $api->album_images($album_id);
                foreach ($albums as $album) {
                    if ($album["id"] == $album_id) {
                        $model->assign("album", $album);
                        $model->assign("CAN_EDIT_ALBUM", $this->user->uid == $album["user_id"]);
                    }
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
        public function userSearch($model,$penname = null)
        {
            header("Location: /u/".$penname."/albums");
            exit();
        }
    }
}
