<?php

namespace app\model {

    use app\service\R;
    use app\services\AppService;

    /**
     * Description of User, it basically extends AbstractUser and implemetns atleast two methods
     *
     * @Model(sessionUser)
     */
    class User extends AbstractUser
    {

        public function auth($username, $passowrd)
        {

            if (is_null($username) || is_null($passowrd)) {
                return FALSE;
            }
            $passowrdMD5 = md5($passowrd);
            $user = R::findOne("user", "penname = ?", array(
                $username
            ));

            if (!is_null($user)) {
                if ($passowrdMD5 != $user->password) {
                    return FALSE;
                }
            } else {
                $user = R::dispense("user");
                $user->penname = $username;
                $user->password = $passowrdMD5;
                $user->id = R::store($user);
            }
            return $this->setUser($user->id, $user->penname);
        }


    }
}
