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

    public function createUser($name, $phone, $desc, $pin_code, $sms_id){
        $passi = md5($pin_code);
        $sql = "INSERT INTO users (name, email, login, pass, date_reg, isban, prior, title, phone, phone_mess, fixprice_inside, inkass_proc, pay_type, sms_id, `desc`) 
                VALUES ('$name','','$phone','$passi',NOW(),'0','0','$name','$phone','','','','','$sms_id','$desc')";
        $test = $this->query($sql);
        if ($test) {
            $user_id = $this->insertID();
            $sql = "INSERT INTO `groups_user` (`group_id`, `user_id`) VALUES ('2', '$user_id')";
            $test = $this->query($sql);
        }
        return $test;
    }

    public function getUserName($phone){
        $sql = "SELECT name FROM users WHERE phone = '$phone'";
        $name = $this->get_assoc_array($sql);
        return (isset($name[0]['name'])) ? $name[0]['name'] : false;
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

        /********************************************************************************/
        if ($action == 'register'){
            $name = $this->Vals->getVal ( 'name', 'POST', 'string' );
            $phone = $this->Vals->getVal ( 'phone', 'POST', 'string' );
            $desc = $this->Vals->getVal ( 'desc', 'POST', 'string' );
            $pin_code = mt_rand(1000, 9999);
            $sms_id = $this->send_sms($phone,$pin_code);
            if (!$sms_id) {
                echo "<div class='alert alert-danger'>Ошибка отправки СМС.</div>";
            } else {
                $result = $this->nModel->createUser($name, $phone, $desc, $pin_code, $sms_id);
                if (!$result) {
                    echo "<div class='alert alert-warning'>Пользователь с таким телефоном уже зарегестрирован.</div>";
                }
                echo "<div class='alert alert-success'>$name, спасибо за регистрацию. Временный пароль для входа отправлен на номер: $phone </div><!-- $pin_code -->";
            }
            exit();
        }		/********************************************************************************/
        if ($action == 'RecoverPass'){
            $phone = $this->Vals->getVal ( 'phone', 'POST', 'string' );
            $name = $this->nModel->getUserName($phone);
            if (!$name) {
                echo "<div class='alert alert-warning'>Пользователь с таким телефоном не зарегестрирован.</div>";
            } else {
                $pin_code = mt_rand(1000, 9999);
                $sms_id = $this->send_sms($phone, $pin_code);
                if (!$sms_id) {
                    echo "<div class='alert alert-danger'>Ошибка отправки СМС.</div>";
                } else {
                    $name = $this->nModel->updUserPass($phone, $pin_code, $sms_id);
                    echo "<div class='alert alert-success'>$name, на ваш номер ($phone) выслан новый временный пароль для входа. </div>";
                }
            }
            exit();
        }

		if ($action == 'view') {
            $news = $this->nModel->getNewsList(3);
            $prices = $this->nModel->getPrices();
            $add_prices = $this->nModel->getAddPrices();
			$this->nView->view_Index ( $news, $prices, $add_prices );
			$this->updated = true;
		}
		
		/********************************************************************************/
		
	}
	function send_sms($phone, $pin_code){
        $smsru = new SMSRU('69da81b5-ee1e-d004-a1aa-ac83d2687954'); // Ваш уникальный программный ключ, который можно получить на главной странице

        $data = new stdClass();
        $data->to = $phone;
        $data->text = "Для доступа к fl-taxi.ru используйте логин $phone и пароль $pin_code"; // Текст сообщения
        $data->from = 'pochta911ru'; // Если у вас уже одобрен буквенный отправитель, его можно указать здесь, в противном случае будет использоваться ваш отправитель по умолчанию
// $data->time = time() + 7*60*60; // Отложить отправку на 7 часов
// $data->translit = 1; // Перевести все русские символы в латиницу (позволяет сэкономить на длине СМС)
// $data->test = 1; // Позволяет выполнить запрос в тестовом режиме без реальной отправки сообщения
// $data->partner_id = '1'; // Можно указать ваш ID партнера, если вы интегрируете код в чужую систему
//        $data->test = 1; // Позволяет выполнить запрос в тестовом режиме без реальной отправки сообщения
        $sms = $smsru->send_one($data); // Отправка сообщения и возврат данных в переменную

        $sms_json = json_encode($sms);
        $this->nModel->saveSMSlog ($phone, $sms->sms_id, $sms->status_code, $sms->status_text, $sms_json);
        if ($sms->status == "OK") { // Запрос выполнен успешно
//            echo "<div class='alert alert-success'>Сообщение на ваш телефон отправлено успешно.</div>";
//            echo "ID сообщения: $sms->sms_id.";
            return $sms->sms_id;
        } else {
//            echo "<div class='alert alert-success'>Сообщение не отправлено. <br/>Код ошибки: $sms->status_code. <br/>Текст ошибки: $sms->status_text.</div>";
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
	
	public function view_Index($news, $prices, $add_prices) {
		$Container = $this->newContainer ( 'index' );
		$this->pXSL [] = RIVC_ROOT . 'layout/' . $this->modName . '/index.view.xsl';

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
	}

}
/*************************************/
