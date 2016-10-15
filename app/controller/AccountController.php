<?php

namespace app\controller {


    use app\service\Cloudinary;
    use app\service\R;
    use RudraX\Utils\Webapp;

    class AccountController extends AbstractController
    {

        /**
         * @RequestMapping(url="albums",method="GET",type="template", auth=true)
         * @RequestParams(true)
         */
        public function albums($model, $album_id = null, $penname = null, $user_id = null)
        {
            $profileCotroller = new ProfileController();
            $profileCotroller->setUser($this->user);
            return $profileCotroller->userAlbums($model, $album_id, $penname, $this->user->uid);
        }

        /**
         * @RequestMapping(url="album/{album_id}",method="GET",type="template", auth=true)
         * @RequestParams(true)
         */
        public function album_view($model, $album_id = null, $penname = null, $user_id = null)
        {
            $profileCotroller = new ProfileController();
            $profileCotroller->setUser($this->user);
            return $profileCotroller->userAlbums($model, $album_id, $penname, $this->user->uid);
        }

        /**
         * @RequestMapping(url="create_album",type="template", auth=true)
         * @RequestParams(true)
         */
        public function create_album($model, $title = "", $description = "", $private = false)
        {
            if (!empty($title) && !empty($description) && $this->user->isValid()) {
                $album = R::dispense("album");
                $album->title = $title;
                $album->description = $description;
                $album->private = $private;
                $album->user_id = $this->user->uid;
                $album->updated = microtime(true);
                $album_id = R::store($album);
                header("Location: /album/" . $album_id);
                exit();
                return $this->albums($model, $album_id);
            }

            $model->assign("title", $title);
            $model->assign("description", $description);
            $model->assign("private", $private);
            return "create_album";

        }
    }
}
