<?php

class titleModel extends module_model {
	public function __construct($modName) {
		parent::__construct ( $modName );
	}
    public function get_assoc_array($sql){
        $this->query ( $sql );
        $items = array ();
        while ( ($row = $this->fetchRowA ()) !== false ) {
            $items[] = $row;
        }
        return $items;
    }
    public function formatPhoneNumber($phone){
        $phone = preg_replace("/[^0-9]/", "", ($phone) );
        return '8'.substr($phone,1,10);
    }
	public function getNewsList($limCount) {
		$page = 1;
		$limStart = ($page - 1) * $limCount;
		$sql = 'SELECT n.*, DATE_FORMAT(`time`, \'%%d.%%m.%%Y\') as time,
			    	(SELECT COUNT(*) FROM news) as news_count
			     FROM news n
				ORDER BY n.`time` DESC';
		if ($limCount > 0) $sql.= ' LIMIT '.$limStart.','.$limCount;
		$this->query($sql);
		$collect = Array();
		while($row = $this->fetchRowA()) {
			$collect[]=$row;
		}
		return $collect;
	}

    public function getPrices() {
        $sql = 'SELECT id, km_from, km_to, km_cost FROM routes_price r';
        return $this->get_assoc_array($sql);
    }

    public function getAddPrices() {
        $sql = 'SELECT id, type, cost_route FROM routes_add_price r';
        return $this->get_assoc_array($sql);
    }

    public function getGoodsPriceList() {
        $sql = 'SELECT p.*, t.goods_name
				FROM goods_cond_prices p 
				LEFT JOIN goods_types t ON p.goods_id = t.id';
        $this->query ( $sql );
        $items = array ();
        $goods = array ();
        while ( ($row = $this->fetchRowA ()) !== false ) {
            $items [] = $row;
        }
        foreach ($items as $item){
            $goods[$item['goods_id']] = $item;
        }
        return array($items,$goods);
    }
    public function getTimeCheckList() {
        $sql = 'SELECT id, type, `from`, `to`, period
				FROM time_check_list ';
        $this->query ( $sql );
        $items = array ();
        while ( ($row = $this->fetchRowA ()) !== false ) {
            $items [$row['type']] = $row;
        }
        return $items;
    }
    public function getPayTypes() {
        $sql = 'SELECT id, pay_type FROM orders_pay_types opt';
        return $this->get_assoc_array($sql);
    }
    public function updateUser($this_user_id, $desc, $pin_code, $sms_id){
        $passi = md5($pin_code);
        $sql = "UPDATE users SET pass = '$passi', sms_id = '$sms_id', `desc` = '$desc' WHERE id = '$this_user_id'";
        $this->query($sql);
        return $this_user_id;
    }
    public function createUser($name, $phone, $desc, $pin_code, $sms_id){
        $user_id = 0;
        $passi = md5($pin_code);
        $sql = "INSERT INTO users (name, email, login, pass, date_reg, isban, prior, title, phone, phone_mess, fixprice_inside, inkass_proc, pay_type, sms_id, `desc`, send_sms) 
                VALUES ('$name','','$phone','$passi',NOW(),'0','0','$name','$phone','','','','','$sms_id','$desc', 1)";
        $test = $this->query($sql);
        if ($test) {
            $user_id = $this->insertID();
            $sql = "INSERT INTO `groups_user` (`group_id`, `user_id`) VALUES ('2', '$user_id')";
            $this->query($sql);
        }
        return $user_id;
    }
    public function CheckCode($phone_user, $code){
        $passi = md5($code);
        $sql = "SELECT id FROM users WHERE login = '$phone_user' AND pass = '$passi' ";
        $this->query ( $sql );
        return $this->getOne();
    }

    public function getUserName($phone){
        $sql = "SELECT name FROM users WHERE phone = '$phone'";
        $name = $this->get_assoc_array($sql);
        return (isset($name[0]['name'])) ? $name[0]['name'] : false;
    }

    public function getUserID($phone){
        $sql = "SELECT id FROM users WHERE phone = '$phone'";
        $this->query ( $sql );
        return $this->getOne();
    }

    public function updUserPass($phone, $pin_code, $sms_id){
        $sql = "SELECT name FROM users WHERE phone = '$phone'";
        $name = $this->get_assoc_array($sql);
        if (isset($name[0]['name'])) {
            $name = $name[0]['name'];
            $passi = md5($pin_code);
            $sql = "UPDATE users SET pass = '$passi', sms_id = '$sms_id' WHERE phone = '$phone'";
            $this->query($sql);
        }
        return $name;
    }
    public function saveSMSlog($phone, $sms_id, $sms_status_code, $sms_status_text, $sms_json){
        $sql = "INSERT INTO log_sms_send (sms_phone, sms_id, status_text, status_code, desc_json, dk, sms_type) VALUES ('$phone', '$sms_id','$sms_status_code','$sms_status_text','$sms_json',NOW(), 'mes')";
        $this->query($sql);
    }
}

class titleProcess extends module_process {
	public function __construct($modName) {
		global $values, $User, $LOG, $System;
		parent::__construct ( $modName );
		$this->Vals = $values;
		$this->System = $System;
		$this->modName = $modName;
		$this->User = $User;
		$this->Log = $LOG;
		$this->action = false;
		/* actionDefault - Действие по умолчанию. Должно браться из БД!!! */		$this->actionDefault = '';
		$this->actionsColl = new actionColl ();
		$this->nModel = new titleModel ( $modName );
		$sysMod = $this->nModel->getSysMod ();
		$this->sysMod = $sysMod;
		$this->mod_id = $sysMod->id;
		$this->nView = new titleView ( $this->modName, $this->sysMod );
		$this->regAction ( 'view', 'Главная страница', ACTION_GROUP );
		$this->regAction ( 'register', 'Регистрация', ACTION_PUBLIC );
		$this->regAction ( 'ConfirmPhone', 'Подтверждение телефона', ACTION_PUBLIC );
		$this->regAction ( 'CheckCode', 'Проверка кода', ACTION_PUBLIC );
		$this->regAction ( 'RecoverPass', 'Восстановление пароля', ACTION_PUBLIC );
		if (DEBUG == 0) {
			$this->registerActions ( 1 );
		}
		if (DEBUG == 1) {
			$this->registerActions ( 0 );
		}
	}
	public function update($_action = false) {
		$this->updated = false;
		if ($_action)
			$this->action = $_action;
		if ($this->action)
			$action = $this->action;
		else
			$action = $this->checkAction ();
		if (! $action) {
			$this->Vals->URLparams ( $this->sysMod->defQueryString );
			$action = $this->actionDefault;
		}
        $user_id = $this->User->getUserID ();

        $this->User->nView->viewLoginParams ( '', '', $user_id, array (), array () );
        $this->updated = true;

        if ($action == 'CheckPhone'){
            $phone = $this->Vals->getVal ( 'phone', 'POST', 'string' );
            $phone_user = $this->nModel->formatPhoneNumber($phone);
            $name_exist = $this->nModel->getUserName($phone_user);
            if ($name_exist) {
                echo "<div class='alert alert-warning'>Пользователь с таким телефоном уже зарегестрирован.<br>Если вы забыли пароль, нажмите ".'<span class="btn-link text-info pointer" onclick="recover_password(\''.$phone_user.'\')">восстановить</span>'.".</div>";
            }
            exit();
        }

        if ($action == 'CheckCode'){
            $code = $this->Vals->getVal ( 'code', 'INDEX', 'string' );
            $phone = $this->Vals->getVal ( 'phone', 'INDEX', 'string' );
            $phone_user = $this->nModel->formatPhoneNumber($phone);
            $user_id = $this->nModel->CheckCode($phone_user, $code);
            if ($user_id > 0) {
                // Авторизуем пользователя
                @session_start();
                $this->Vals->setValTo('username', $phone_user, 'POST');
                $this->Vals->setValTo('userpass', $code, 'POST');
                $this->User->login();
                echo $user_id;
            }else{
                echo 0;
            }
            exit();
        }
        if ($action == 'ConfirmPhone'){
            $phone = $this->Vals->getVal ( 'phone', 'POST', 'string' );
            $name = $this->Vals->getVal ( 'name', 'POST', 'string' );

            $phone_user = $this->nModel->formatPhoneNumber($phone);
            $this_user_id = $this->nModel->getUserID($phone_user);

            $pin_code = mt_rand(1000, 9999);
            $sms_id = $this->send_sms($phone_user, $pin_code, 1);
            if (!$sms_id) {
                echo 2;
            } else {
                if ($this_user_id > 0) {
                    $desc = 'Запрос пароля через заказ с главной';
                    $this->nModel->updateUser($this_user_id, $desc, $pin_code, $sms_id);
                    echo $this_user_id;
                } else {
                    $desc = 'Регистрация через заказ с главной';
                    $user_id = $this->nModel->createUser($name, $phone_user, $desc, $pin_code, $sms_id);
                    echo $user_id;
                }
            }
            exit();
        }
        /********************************************************************************/
        if ($action == 'register'){
            $name = $this->Vals->getVal ( 'name', 'POST', 'string' );
            $phone = $this->Vals->getVal ( 'phone', 'POST', 'string' );
            $desc = $this->Vals->getVal ( 'desc', 'POST', 'string' );
            $phone_user = $this->nModel->formatPhoneNumber($phone);
            $name_exist = $this->nModel->getUserName($phone_user);
            if ($name_exist) {
                echo "<div class='alert alert-warning'>Пользователь с таким телефоном уже зарегестрирован.<br>Если вы забыли пароль, нажмите ".'<span class="btn-link text-info pointer" onclick="recover_password(\''.$phone.'\')">восстановить</span>'.".</div>";
            }else {
                $pin_code = mt_rand(1000, 9999);
                $sms_id = $this->send_sms($phone_user, $pin_code, 0);
                if (!$sms_id) {
                    echo "<div class='alert alert-danger'>Ошибка отправки СМС.</div>";
                } else {
                    $user_id = $this->nModel->createUser($name, $phone_user, $desc, $pin_code, $sms_id);
                    if ($user_id > 0) {
                        echo "<div class='alert alert-success'>$name, спасибо за регистрацию.<br>Временный пароль для входа отправлен на номер: $phone </div><!-- $pin_code -->";
                    }else {
                        echo "<div class='alert alert-warning'>Ошибка регистрации пользователя.<br>Если данная ошибка повторяется, сообщите нам об этом по телефону.</div>";
                    }
                }
            }
            exit();
        }
        /********************************************************************************/
        if ($action == 'RecoverPass'){
            $phone = $this->Vals->getVal ( 'phone', 'POST', 'string' );
            $phone_user = $this->nModel->formatPhoneNumber($phone);
            $name = $this->nModel->getUserName($phone_user);
            if (!$name) {
                echo "<div class='alert alert-warning'>Пользователь с таким телефоном не зарегестрирован.</div>";
            } else {
                $pin_code = mt_rand(1000, 9999);
                $sms_id = $this->send_sms($phone_user, $pin_code, 2);
                if (!$sms_id) {
                    echo "<div class='alert alert-danger'>Ошибка отправки СМС.</div>";
                } else {
                    $name = $this->nModel->updUserPass($phone_user, $pin_code, $sms_id);
                    echo "<div class='alert alert-success'>$name, на ваш номер ($phone) выслан новый временный пароль для входа. <!-- $pin_code --> </div>";
                }
            }
            exit();
        }

		if ($action == 'view') {
            $news = $this->nModel->getNewsList(3);
            $prices = $this->nModel->getPrices();
            $pay_types = $this->nModel->getPayTypes();
            $timer = $this->getTimeForSelect();
            $times = $this->nModel->getTimeCheckList();
            $add_prices = $this->nModel->getAddPrices();
            list($g_price, $goods) = $this->nModel->getGoodsPriceList();
			$this->nView->view_Index ( $news, $prices, $add_prices, $pay_types, $timer, $times, $g_price, $goods );
			$this->updated = true;
		}
		
		/********************************************************************************/
		
	}

    public function getTimeForSelect(){
        $time_arr = array();
        for ($h = 7; $h <= 23; $h++) {
            if ($h < 23){
                for ($i= 0; $i <= 5; $i++){
                    $time_arr[] = substr('0'.$h,-2).':'.substr('0'.($i*10),-2);
                }
            }else{
                $time_arr[] = $h.':00';
            }
        }
        return $time_arr;
    }

    public function send_sms($phone, $pin_code, $isConfirm = 0){
        $smsru = new SMSRU('69da81b5-ee1e-d004-a1aa-ac83d2687954'); // Ваш уникальный программный ключ, который можно получить на главной странице

        $data = new stdClass();
        $data->to = $phone;
        if ($isConfirm == 1) {
            $data->text = "Подтверждение заказа, введите код $pin_code"; // Подтверждение заказа
        } elseif ($isConfirm == 2) {
            $data->text = "Временный пароль от pochta911.ru $pin_code"; // Восстановление доступа
        } else {
            $data->text = "Регистрация на pochta911.ru. Логин $phone, разовый пароль $pin_code"; // Регистрация
        }
        $data->from = 'pochta911ru';
        $sms = $smsru->send_one($data); // Отправка сообщения и возврат данных в переменную

        $sms_json = json_encode($sms);
        $this->nModel->saveSMSlog ($phone, $sms->sms_id, $sms->status_code, @$sms->status_text || 'OK', $sms_json);
        if ($sms->status == "OK") {
            return $sms->sms_id;
        } else {
            return false;
        }
    }
}
/*************************************/
class titleView extends module_View {
	public function __construct($modName, $sysMod) {
		parent::__construct ( $modName, $sysMod );
		$this->pXSL = array ();
	}
	
	public function view_Index($news, $prices, $add_prices, $pay_types, $timer, $times, $g_price, $goods) {
		$Container = $this->newContainer ( 'index' );
		$this->pXSL [] = RIVC_ROOT . 'layout/' . $this->modName . '/index.view.xsl';

        $this->addAttr('today', date('Y-m-d'), $Container);
        $this->addAttr('time_now', time(), $Container);

        $this->arrToXML ( $timer, $Container, 'timer' );
        $this->arrToXML ( $times, $Container, 'times' );

        $ContainerNews = $this->addToNode ( $Container, 'news', '' );
        foreach ( $news as $item ) {
            $this->arrToXML ( $item, $ContainerNews, 'item' );
        }
        $ContainerPrices = $this->addToNode ( $Container, 'prices', '' );
        foreach ( $prices as $item ) {
            $this->arrToXML ( $item, $ContainerPrices, 'item' );
        }
        $ContainerAddPrices = $this->addToNode ( $Container, 'add_prices', '' );
        foreach ( $add_prices as $item ) {
            $this->arrToXML ( $item, $ContainerAddPrices, 'item' );
        }
        $ContainerPayTypes = $this->addToNode ( $Container, 'pay_types', '' );
        foreach ( $pay_types as $item ) {
            $this->arrToXML ( $item, $ContainerPayTypes, 'item' );
        }
        $ContainerGprice = $this->addToNode ( $Container, 'g_price', '' );
        foreach ( $g_price as $item ) {
            $this->arrToXML ( $item, $ContainerGprice, 'item' );
        }
        $ContainerGoods = $this->addToNode ( $Container, 'goods', '' );
        foreach ( $goods as $item ) {
            $this->arrToXML ( $item, $ContainerGoods, 'item' );
        }

	}

}
/*************************************/
