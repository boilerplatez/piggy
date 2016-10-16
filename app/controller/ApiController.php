<?php

namespace app\controller {


    use app\service\R;
    use RudraX\Utils\Webapp;

    class ApiController extends AbstractController
    {

        /**
         * @RequestMapping(url="api/search_user",type="json", cache=true)
         * @RequestParams(true)
         */
        public function search_user($query)
        {
            return R::getAll("SELECT id,penname FROM user WHERE penname like ?", array("%".$query."%"));
        }
        /**
         * @RequestMapping(url="api/image_upload",type="json", auth=true)
         * @RequestParams(true)
         */
        public function cloudinary_upload($model, $imageData, $album_id)
        {
            $config = \Config::getSection("CLOUDINARY_CONFIG");
            $image = R::dispense("image");
            $image->public_name = $imageData["public_id"];
            $image->created_at = $imageData["created_at"];
            $image->height = $imageData["height"];
            $image->width = $imageData["width"];
            $image->url = $imageData["url"];
            $image->original_filename = $imageData["original_filename"];
            $image->path = $imageData["path"];
            $image->version = $imageData["version"];
            $image->cloud_name = $config["cloud_name"];
            $image->album_id = $album_id;
            $image->user_id = $this->user->uid;
            $image->inorder = microtime();
            $image->likes = 0;
            R::store($image);

            if (!is_null($album_id)) {
                $album = R::load("album", $album_id);
                if (!is_null($album) && empty($album->public_name)) {
                    $album->cloud_name = $image->cloud_name;
                    $album->public_name = $image->public_name;
                    R::store($album);
                }
            }

            return $image;
        }

        /**
         * @RequestMapping(url="api/album_images/{album_id}",type="json",guestcache=true)
         * @RequestParams(true)
         */
        public function album_images($album_id = 0)
        {
            if ($this->user->isValid()) {
                return R::getAll("SELECT image. *,likes.liked,likes.image_id
                FROM image LEFT JOIN likes ON image.id = likes.image_id  AND likes.user_id = ?
                WHERE album_id = ? ORDER BY created_at ASC", array($this->user->uid, $album_id));
            }
            return R::getAll("SELECT image. *,likes.liked,likes.image_id
                FROM image LEFT JOIN likes ON image.id = likes.image_id
                WHERE album_id = ? ORDER BY created_at ASC", array($album_id));
        }

        /**
         * @RequestMapping(url="api/user_albums/{user_id}",type="json")
         * @RequestParams(true)
         */
        public function user_albums($user_id = null)
        {
            return R::getAll("SELECT * FROM album WHERE user_id = ? ORDER BY updated DESC", array($user_id));
        }

        /**
         * @RequestMapping(url="api/album/{album_id}",type="json")
         * @RequestParams(true)
         */
        public function album_detail($album_id = null)
        {
            $album =  R::getRow("SELECT * FROM album WHERE album_id = ? ORDER BY updated DESC", array($album_id));
            if(empty($album)){
                return null;
            }
            return $album[0];
        }

        /**
         * @RequestMapping(url="api/image_like/{image_id}",type="json", auth=true)
         * @RequestParams(true)
         */
        public function image_like($image_id = null)
        {
            $likes = R::findOne("likes", "image_id=? AND user_id= ?", array($image_id, $this->user->uid));

            if (is_null($likes)) {
                $likes = R::dispense("likes");
                $likes->image_id = $image_id;
                $likes->user_id = $this->user->uid;
                $likes->liked = 0;
            }
            $likes->liked = ($likes->liked == 0 ? 1 : 0);

            R::store($likes);

            $image = R::load("image", $image_id);
            $image->likes = R::count('likes', ' image_id = ? AND liked = 1', array($image_id));
            R::store($image);
            $image->liked = $likes->liked;
            return $image;
        }
    }
}
