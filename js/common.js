/**
 * Created by Daniil on 11.12.2016.
 */
function delete_div_row(obj) {
    var row = $(obj).parent().parent();
    var panel = $(row).parent();
    $(row).remove();
    var i = 0;
    $(panel).find('.input-group').each(function(){
        i++;
        $(this).attr('rel',i);
        $(this).find('.input-group-addon').text(i);

    });
    $(panel).find('.input-group:last-child .btn-clone').removeAttr('disabled');
}

function clone_div_row(row) {
    var class_id = $(row).attr("rel");
    var class_id_new = +class_id + 1;
    var new_el = $(row).clone().insertAfter($(row));
    $(new_el).attr("rel", class_id_new);
    $(new_el).find('.input-group-addon').text(class_id_new);
    // даем возможность удалиться созданному
    $(new_el).find('.btn-delete').removeAttr('disabled');
    // автозаполение адреса
    $(new_el).remove('.typeahead');
    // чистим окна ввода
    $(new_el).find('input, select, textarea').not('.time_ready_from, .to_time, .to_time_end').val('');
    var start_time = $(new_el).find('.time-picker.start').get();
    var end_time = $(new_el).find('.time-picker.end').get();
    set_time_period(start_time,end_time);
    autoc_spb_streets();
    google_autocomlete();
    test_time_routes_add();
    //$(new_el).find("input").attr('id', '');
}
function update_time_ready_from(obj){
    var time_ready = $(obj).val();
    $('.time_ready_from').val(time_ready);
    test_time_routes_add();
}
function update_time_ready_end(obj){
    var time_ready = $(obj).val();
    $('.time_ready_end').val(time_ready);
    test_time_routes_add();
}

function set_time_period (start, end) {
    $(start).datetimepicker(timeoptions);
    $(end).datetimepicker(timeoptions);
    $(start).on("dp.change", function (e) {
        $(end).data("DateTimePicker").minDate(e.date);
    });
    $(end).on("dp.change", function (e) {
        $(start).data("DateTimePicker").maxDate(e.date);
    });
    $(start).on("dp.show", function (e) {
        $(end).data("DateTimePicker").minDate(e.date);
    });
    $(end).on("dp.show", function (e) {
        $(start).data("DateTimePicker").maxDate(e.date);
    });
}



var timer_check_user;
function check_user(obj){
    clearTimeout(timer_check_user);
    var elem_type = $(obj).attr('name');
    timer_check_user=setTimeout(function send_req_check_user(){
        var obj = $('input[name='+elem_type+']');
        var user_id = $('#user_id').val();
        var elem_val = $(obj).val();
        $.post("/admin/checkUser-1/", {user_id:user_id,elem_type:elem_type,value:elem_val},  function(data) {
            if (data == 1){
                $(obj).attr('style','border: 1px solid maroon');
                if ($('.alert-div-'+elem_type).length == 0) {
                    var alert_div = $('<div class="alert alert-danger alert-div alert-div-' + elem_type + '">Введите другое значение...</div>');
                    $(obj).parent().append(alert_div);
                }
                $('input[type=submit]').attr("disabled","disabled")
            }else{
                $(obj).attr('style','border: 1px solid darkgreen');
                $('.alert-div-'+elem_type+'').fadeOut().remove();
                if ($('.alert-div').length == 0) {
                    $('input[type=submit]').removeAttr("disabled");
                }
            }

        });
    },500,elem_type);
}


function send_new_courier(){
    var $bootbox_body = $('.bootbox-body');
    var order_id = $bootbox_body.find('input[name=order_id]').val();
    var order_route_id = $bootbox_body.find('input[name=order_route_id]').val();
    // var new_courier = $('.bootbox-body').find('select[name=new_courier]').val();
    var new_courier = $bootbox_body.find('input[name=new_courier]').val();
    var new_car_courier = $bootbox_body.find('select[name=new_car_courier]').val();
    var courier_comment = $bootbox_body.find('textarea[name=courier_comment]').val();
    var order_info_message = $bootbox_body.find('input[name=order_info_message]').val();

    $.post("/orders/chg_courier-1/", {order_id:order_id,order_route_id:order_route_id,new_courier:new_courier,new_car_courier:new_car_courier,courier_comment:courier_comment,order_info_message:order_info_message},  function(data) {
          bootbox.alert(data,location.reload());
        // bootbox.alert(data);
    });

}


function send_new_status(){
    var $bootbox_body = $('.bootbox-body');

    var order_route_id = $bootbox_body.find('input[name=order_route_id]').val();
    var new_status = $bootbox_body.find('select[name=new_status]').val();
    var stat_comment = $bootbox_body.find('textarea[name=comment_status]').val();
    var order_info_message = $bootbox_body.find('input[name=order_info_message]').val();

    $.post("/orders/chg_status-1/", {order_route_id:order_route_id,new_status:new_status,stat_comment:stat_comment,order_info_message:order_info_message},  function(data) {
        bootbox.alert(data,location.reload());
        // bootbox.alert(data);
    });

}

function autoc_spb_streets(){
    // Применяем для подбора улиц
    $(".spb-streets").each(function() {
        var $this = $(this);
        $this.typeahead({
            source: function (query, process) {
                // var textVal=$("#field1").val();
                $.ajax({
                    url: '/service/kladr.php',
                    type: 'POST',
                    data: 'type=street&street=' + query + '&city=',
                    dataType: 'JSON',
                    async: true,
                    timeout: 5000,
                    success: function (data) {
                        process(data);
                    }
                });
            },
            updater: function (item) {
                $($this).parent().parent().find('.house').attr('AOGUID', item.id).val('');
                $($this).parent().parent().find('.AOGUID').val(item.id);
                $($this).parent().parent().find('.region').val(item.region);
                $($this).attr('region', item.region);
                getHouseNumbers();
                return item;
            },
            minLength: 4,
//		scrollHeight: 200,
            items: 'all'
        });
    });
    getHouseNumbers();
    /*
    var saved_data = localStorage.getItem('spb_street_data');
    if (typeof saved_data == 'undefined' || saved_data == null || saved_data == '' ) {
        $.getJSON('/orders/get_data-spbStreets', function(spb_street_data){
            localStorage.setItem('spb_street_data', JSON.stringify(spb_street_data));
            $(".spb-streets").typeahead({ source: spb_street_data, hint: true });
        },'json');
    }else{
        var localData = JSON.parse(localStorage.getItem('spb_street_data'));
        $(".spb-streets").typeahead({ source: localData, hint: true });
    }
    */
}

function getHouseNumbers() {
    // Применяем для подбора домов
    $(".house").each(function() {
        var $this = $(this);
        var AOGUID=$($this).attr('AOGUID');
        $this.select2({
            language: "ru",
            ajax: {
                url: "/service/kladr.php",
                type: 'POST',
                data: function (params) {
                    var house = (typeof params.term == 'undefined')?$this.val():params.term;
                    return {
                        house: house, // search term
                        type: 'house',
                        AOGUID: AOGUID
                    };
                },
                dataType: 'JSON',
                async: true,
                timeout: 5000,
                cache: true,
                processResults: function (data) {
                    return {
                        results: $.map(data.items, function (item) {
                            return {
                                text: item.name,
                                id: item.name
                            }
                        })
                    };
                }
            }
        });
        /*
        $.ajax({
            url: '/service/kladr.php',
            type: 'POST',
            data: 'type=house&house=&AOGUID=' + AOGUID,
            dataType: 'JSON',
            async: true,
            timeout: 5000,
            success: function (data) {
                $this.html('');
                $.each(data, function (idx, obj) {
                    $this.append('<option value="' + obj.name + '">' + obj.name + '</option>');
                });
                $this.trigger("liszt:updated");
                $this.select2().css('width','100%');
            }
        });
        */
        /*
         $this.typeahead({
         source: function (query, process) {
         $.ajax({
         url: '/service/kladr.php',
         type: 'POST',
         data: 'type=house&house=' + query + '&AOGUID=' + AOGUID,
         dataType: 'JSON',
         async: true,
         timeout: 5000,
         success: function (data) {
         source_data = data;
         process(data);
         }
         });
         },
         minLength: 0,
         items: 'all'
         }).blur(function () {
         console.log(source_data);
         if(source_data.includes($(this).val())) {
         console.log('Error : element not in list!');
         }
         });
         */
    });
}

function updUserStores(obj){
    var user_id = $(obj).val();
    $.post("/orders/get_data-userStores/", {user_id:user_id},  function(data) {
        data = JSON.parse(data);
        $('SELECT.pay_type').val(data.pay_type);
        $('#user_fix_price').val(data.fixprice);
        $('.js-store_address').html(data.opts).change();
    });
}



function filter_table(){
    $('TABLE.new-logist-data-table TBODY tr').hide();
    var i = 0;
    $('input.statuses').each(function() {
        if ( $(this).is(':visible') && $(this).prop('checked') ) {
            var chk_val = $(this).val();
            $('TABLE.new-logist-data-table TBODY tr.status_'+chk_val).show();
            // Если статус выбран, но таких строк нет, то показывать все.
            // if ($('.new-logist-data-table tr.status_'+chk_val).length){
                i++;
            // }
        }
    });
    if (i == 0){
        $('.new-logist-data-table TBODY tr').show();
    }
}

function re_calc(obj){
    var route_row = $(obj).parent().parent();
    var cost_tovar = $(route_row).find('.cost_tovar').val();
    var cost_route = $(route_row).find('.cost_route').val();
    var pay_type = $(route_row).find('.pay_type').val();
    var inkass = 0;

    var PayTypeIsDisabled = $(route_row).find('.pay_type').is(':disabled');
    //Если инкассация больше 0 то автоматически ставиться оплата доставки "По Договору"
    if (cost_tovar > 0 && !PayTypeIsDisabled) {
        $(route_row).find('.pay_type').val('3');
    }
    //Если инкасация или если по новому то "Наличные у получателя" ровны 0 то "Способ оплаты доставки" автоматически изменяется на "Курьеру в магазине" - только если в анкете клиента стоит свободный выбор, если нет, то всегда автоматом то что указанно в анкете
    if (cost_tovar == 0 && !PayTypeIsDisabled) {
        $(route_row).find('.pay_type').val('1');
    }
    if (pay_type == 2){
        inkass = Number(cost_tovar)+Number(cost_route);
    }else{
        inkass = Number(cost_tovar);
    }
    $(route_row).find('.cost_all').val(inkass);
}



//
function time_routes_set(obj){
    var time_target = $(obj).val();
    var route_block = $(obj).parent().parent().get();
    $(route_block).find('.to_time').val(time_target);
    $(route_block).find('.to_time_end').val(time_target);
}

function target_time_show(){
    if ($('.target').prop('checked')){
        $('.target_select').show();
        $('.period_select').hide();
    }else{
        $('.target_select').hide();
        $('.period_select').show();
    }
    test_time_routes_add();
}

function round5(x){
    return Math.ceil(x/5)*5;
}
function round00(x){
    return Math.ceil(x*100)/100;
}
// адская проверка времени
function test_time_routes_add() {
    var from_block = $('DIV.from-block').get(0);
    $('.to_time').removeAttr('disabled');
    var this_ready_from = $(from_block).find('.time_ready_from').val();
    var this_ready_end = $(from_block).find('.time_ready_end').val();
    $('div.routes-block').each(function (index) {
        var next_route = $('div.routes-block').eq(index+1);
        var this_to_time = $(this).find('.to_time').val();
        var this_to_time_end = $(this).find('.to_time_end').val();
        var this_to_time_target = $(this).find('.to_time_target').val();
        var next_to_time = $(next_route).find('.to_time').val();
        // var next_to_time_end = $(next_route).find('.to_time_end').val();
        // Текущее время
        var m = moment(new Date());
        var time_now_string = m.hour() + ':' + round5(m.minute());

        // Если текущее время меньше времени готовности
        if (TimeToFloat(this_ready_from) < TimeToFloat(time_now_string) && moment($('input[name=date]').val(), 'DD.MM.YYYY').isSame(Date.now(), 'day')) {
            $(from_block).find('.time_ready_from').val(time_now_string);
            bootbox.alert('Время готовности не может быть меньше текущего времени.');
        }
        // Если время готовности ПО меньше времени готовности С
        else if (this_ready_end != '-' && TimeToFloat(this_ready_end) < TimeToFloat(this_ready_from)) {
            $(from_block).find('.time_ready_end').val(this_ready_from);
            test_time_routes_add();
        }
        // Если время готовности меньше времени С
        else if (this_ready_end != '-' &&
            (TimeToFloat(this_ready_end) > TimeToFloat(this_to_time) ||
                TimeToFloat(this_ready_end) > TimeToFloat(this_to_time_target))) {
            $(this).find('.to_time').val(this_ready_end);
            $(this).find('.to_time_target').val(this_ready_end);
            test_time_routes_add();
        }
        // Если время готовности меньше времени С
        else if (this_ready_end == '-' &&
            (TimeToFloat(this_ready_from) > TimeToFloat(this_to_time) ||
                TimeToFloat(this_ready_from) > TimeToFloat(this_to_time_target))) {
            $(this).find('.to_time').val(this_ready_from);
            $(this).find('.to_time_target').val(this_ready_from);
            test_time_routes_add();
        }
        // Если время С меньше времени ПО
        else if (TimeToFloat(this_to_time) > TimeToFloat(this_to_time_end)) {
            $(this).find('.to_time_end').val(this_to_time);
            test_time_routes_add();
        }

        if (typeof next_to_time != 'undefined') {
            // а. времня начало доставки следующего адреса, меньше или равно времени окончания доставки предыдущего.
            if (TimeToFloat(next_to_time) > TimeToFloat(this_to_time_end)){
                $(next_route).find('.to_time').val(this_to_time_end);
                // блокируем возможность выбор другого времени
                // disable_next($(next_route).find('.to_time'), this_to_time_end);
            }
            // б. Если от начала доставки первого адреса до конца доставки первого адреса более 60 минут , то программа внутри у себя подставляет что там промежуток в 60 минут, например (с 14,00 до 18,00 , программа в уме держит что там с 14,00 до 15,00)

            // в. время начала следующего заказа , больше или равно времени начало предыдущего адреса но если больше то не более чем на 30 минут.
            if ((TimeToFloat(next_to_time) < TimeToFloat(this_to_time))
                || round00((TimeToFloat(next_to_time) - TimeToFloat(this_to_time)) > 0.5)){
                $(next_route).find('.to_time').val(this_to_time);
            }
            // console.log('this_to_time:' + this_to_time);
            // console.log('this_to_time_end:' + this_to_time_end);
            // console.log('next_to_time:' + next_to_time);
            // console.log('next_to_time_end:' + next_to_time_end);
        }
    });
}

function test_time_routes(obj){
    var route_row = $(obj).parent().parent();
    test_time_routes_each(route_row);
}
function test_time_all_routes(){
    // var order_edited = $('#order_edited').val();
    var time_edited = $('#time_edited').val();
    var order_id = $('#order_id').val();
    var from_block = $('DIV.from-block').get(0);

    // Запускаем проверку только, если это новый заказ или если в нем было что-то изменено (кроме примечания)
    // Или изменено только время
    // if ((order_edited == 1 || order_id == 0) && time_edited == 1) {
    if (time_edited == 1 || order_id == 0) {

        var $routes_block = $('div.routes-block');

        var invalid = false;
        $routes_block.find("select:required, input:required", this).each(function () {
            if ($(this).val().trim() == "") {
                invalid = true;
                $(this).focus();
            }
        });
        if (invalid) {
            bootbox.alert('Заполните, пожалуйста, все обязательные поля формы заказа.');
            return false;
        }

        $routes_block.each(function () {
            var this_ready = $(from_block).find('.time_ready_from').val();
            var this_to_time = $(this).find('.to_time').val();
            var this_to_time_end = $(this).find('.to_time_end').val();

            // Время начала доставки не может быть позже времени окончания доставки
            if (this_to_time > this_to_time_end) {
                $(this).find('.to_time').val(this_to_time_end);
                this_to_time = this_to_time_end;
                bootbox.alert('Время начала доставки не может быть позже времени окончания доставки.');
                return false;
            }
            // Время готовности не может быть больше времени доставки
            if (this_ready > this_to_time) {
                $(from_block).find('.time_ready_from').val(this_to_time);
                bootbox.alert('Время готовности не может быть больше времени начала доставки.');
                return false;
            }
        });
        $routes_block.each(function () {
            test_time_routes_each(this);
        });
    }else{
        document.getElementById("order_edit").submit();
    }
}

function test_time_routes_each(route_row){
    var from_block = $('DIV.from-block').get(0);
    var time_ready_from = $(from_block).find('.time_ready_from').val();
    var time_ready_end = $(from_block).find('.time_ready_end').val();
    var to_time = $(route_row).find('.to_time').val();
    var to_time_end = $(route_row).find('.to_time_end').val();
/*
     iLog('to_time_ready: '+TimeToFloat(to_time_ready));
     // iLog('to_time: '+TimeToFloat(to_time));
     iLog('to_time_end: '+TimeToFloat(to_time_end));
     iLog('time_now: '+TimeToFloat(timestampToTime()));
*/
    var tt_ready_from = TimeToFloat(time_ready_from);
    var tt_ready_end = TimeToFloat(time_ready_end);
    var tt = TimeToFloat(to_time);
    var tt_end = TimeToFloat(to_time_end);
    var t_now = TimeToFloat(timestampToTime());

    var today = $('.today-date').val();
    var tomarrow = moment(today, 'DD.MM.YYYY').add(1, 'days').format('L');
    var $date = $('input[name=date]');
    var set_date = $date.val();

    // времена для проверки
    var period_tomarrow_from = $('#period_tomarrow_from').val();
    var period_tomarrow_to = $('#period_tomarrow_to').val();
    var period_today_from = $('#period_today_from').val();
    var period_today_to = $('#period_today_to').val();
    var ready_1_from = $('#ready_1_from').val();
    var ready_1_to = $('#ready_1_to').val();
    var ready_1_period = $('#ready_1_period').val();
    var ready_2_period = $('#ready_2_period').val();
    var ready_3_period = $('#ready_3_period').val();
    var ready_today_period = $('#ready_today_period').val();
    var period_period = $('#period_period').val();


    // Если время доставки меньше текущего, то заказ на следующий день (проверяю по второму времени)
    var tt_end_2 = round00(tt_end - t_now) < 0 ? tt_end + 24 : tt_end;
    var tt_2 = round00(tt_end - t_now) < 0 ? tt + 24 : tt;

    var no_error = true;
    var errors = '<ul>';
    // Если время доставки меньше готовности, то заказ на следующий день
    tt_end = round00(tt_end - tt_ready_from) < 0 ? tt_end + 24 : tt_end;

    // (0) Время между "забрать по" и "доставить с" не может быть больше 120 минут (2х часов), если стоит бесконечность по умолчанию то эта проверка не нужна
    if (round00(tt - tt_ready_end) > ready_3_period && time_ready_end != '-') {
        errors += '<li>Время начала доставки не может быть больше '+ready_3_period+':00 от времени "забрать по".</li><br/>';
        no_error = false;
    }

    // (1) Заказы вечером на завтра запрещены на утро (проверка по крайнему времени доставки)
    if ( set_date == tomarrow && t_now > period_tomarrow_to && tt_end < period_tomarrow_from ){
        errors += '<li>Заказ с доставкой в период с 8:00 до '+period_tomarrow_from+':00 можно оставить не позднее '+period_tomarrow_to+':00.</li><br/>';
        no_error = false;
    }
    // (2) Заказы утром на сегодняшнее утро запрещены  (проверка по крайнему времени доставки)
    if ( set_date == today && t_now < period_today_to && tt_end < period_today_from ){
        errors += '<li>Заказ с доставкой в период с 8:00 до '+period_today_from+':00 можно оставить не раньше '+period_today_to+':00.</li><br/>';
        no_error = false;
    }

    // (3) если готовность букета с 8 до 10, то мы разрешаем выставлять рамки заказа в пределах 1 часа от времени готовности,
    // и остальные проверки кроме, 2,5 часов оствляем
    if (tt_ready_from >= ready_1_from && tt_ready_from <= ready_1_to){
        // проверка от готовности до начала доставки - 2 час
        if (round00(tt_end - tt_ready_from) < ready_1_period){
            errors += '<li>Значение "Доставить по" не может быть менее '+ready_1_period+' ч. от значения "Можно забрать с".</li><br/>';
            no_error = false;
        }
    } else {
        // (4) проверка от готовности (2,5 часа) - 18.05.2017 - заменил на 3 часа
        if (round00(tt_end - tt_ready_from) < ready_2_period) {
            errors += '<li>Значение "Доставить по" не может быть менее '+ready_2_period+' ч. от значения "Можно забрать с".</li><br/>';
            no_error = false;
        }
        // (5) Проверка от времени заказа
        if (set_date == today && round00(tt_end_2 - t_now) < ready_today_period ){
            errors += '<li>Значение "Доставить по" не может быть менее '+ready_today_period+' ч. от текущего времени.</li><br/>';
            no_error = false;
        }
    }
    // (6) Проверка от и до не менее 40 мин, если только не к точному времени
    if (round00(tt_end_2 - tt_2) < (period_period / 60) && !$('.target').prop('checked')){
        errors += '<li>Интервал между значениями "Доставить с" и "Доставить по" не может быть менее '+period_period+' мин.</li><br/>';
        no_error = false;
    }



    // Только для новых заказов
    if ($('#order_id').val() == '') {
        // Добавляем день, если заказ на текущей и время готовности меньше текушего
        if (moment($date.val(), 'DD.MM.YYYY').isSame(Date.now(), 'day') && (tt_end - t_now) < 0) {
            $date.val(moment($date.val(), 'DD.MM.YYYY').add(1, 'days').format('L'));
        }
    }
/*
    // проверка обязательный полей
    var fail = false;
    var fail_log = '';
    $( '#form_id' ).find( 'select, textarea, input' ).each(function(){
        if( ! $( this ).prop( 'required' )){

        } else {
            if ( ! $( this ).val() ) {
                fail = true;
                var name = $( this ).attr( 'title' );
                fail_log += "Поле '" + name + "' должно быть заполнено. \n";
            }

        }
    });
*/

    // Группа пользователя
    var group_id = $('BODY').attr('group_id');

    // Если клиент, то пусть исправляет
    if (group_id == 2) {
        // Блокировка при ошибках во времени
        if (!no_error) {
            $('input.btn-submit').prop('disabled', true);
            bootbox.alert(errors + '</ul><br/>Откорректируйте, пожалуйста, временные рамки.', function () {
                $('input.btn-submit').prop('disabled', false);
            });
        } else {
            $('input.btn-submit').prop('disabled', false);
        }
    }else{
        // Запрос при ошибках во времени
        if (!no_error) {
            $('input.btn-submit').prop('disabled', true);
            var dialog = bootbox.confirm({
                message: errors + '</ul><br/>Продолжить с указанными параметрами?',
                buttons: {
                    confirm: {
                        label: 'Сохранить заказ',
                        className: 'btn-success'
                    },
                    cancel: {
                        label: 'Отмена',
                        className: 'btn-danger'
                    }
                },
                callback: function (result) {
                    $('input.btn-submit').prop('disabled', false);
                    dialog.modal('hide');
                    if (result) {
                        document.getElementById("order_edit").submit()
                    }
                    return result;
                }
            });
        } else {
            $('input.btn-submit').prop('disabled', false);
        }
    }
/*
    // Блокировка по обязательным полям
    if ( fail ) {
        $('input.btn-submit').prop('disabled', true);
        bootbox.alert( fail_log, function(){ $('input.btn-submit').prop('disabled', false); } );
        // Если нет других ошибок, то блокируем данной проверкой.
        no_error = (no_error)?false:fail;
    }
*/

    if (no_error) {
        document.getElementById("order_edit").submit()
    }else{
        return no_error;
    }
}

/**
 * @return {number}
 */
function TimeToFloat(time){
    var result = 0;
    if (time != '' && typeof time != 'undefined'){
        var time_ready_arr = time.split(':');
        result = parseInt(time_ready_arr[0])+parseInt(time_ready_arr[1])/60;
    }
    return round00(result);
}

function timestampToTime(){
    var unix_timestamp = $('#time_now').val();
    var date = new Date(unix_timestamp*1000);
    var hours = date.getHours();
    var minutes = "0" + date.getMinutes();
    var seconds = "0" + date.getSeconds();
    var his = hours + ':' + minutes.substr(-2) + ':' + seconds.substr(-2);
    $('span.his_time_now').html(his);
    return hours + ':' + minutes.substr(-2);
}

function add_data_table(obj, type){
    /*
    // Setup - add a text input to each footer cell

    $(obj).find('tfoot th').each( function () {
        var title = $(this).text();
        $(this).html( '<input type="text" placeholder="Search '+title+'" />' );
    } );
*/
    var no_data = 'В таблице отсутствуют данные';
    if (type == 'logist') {
        no_data = 'Нет заказов на выбранную дату';
    }
    if (type == 'client') {
        no_data = 'У Вас нет заказов на выбранную дату';
    }
    // DataTable
    $(obj).DataTable({
        "language": {
            "processing": "Подождите...",
            "search": "Поиск:",
            "lengthMenu": "Показать _MENU_ записей",
            "info": "Записи с _START_ до _END_ из _TOTAL_ записей",
            "infoEmpty": "Записи с 0 до 0 из 0 записей",
            "infoFiltered": "(отфильтровано из _MAX_ записей)",
            "infoPostFix": "",
            "loadingRecords": "Загрузка записей...",
            "zeroRecords": "Записи отсутствуют.",
            "emptyTable": no_data,
            "paginate": {
                "first": "Первая",
                "previous": "Предыдущая",
                "next": "Следующая",
                "last": "Последняя"
            },
            "aria": {
                "sortAscending": ": активировать для сортировки столбца по возрастанию",
                "sortDescending": ": активировать для сортировки столбца по убыванию"
            }
        }
        , "bLengthChange": false
        , "bPaginate": false
        , "bFilter": true
        , "stateSave": true
        , "order": [[ 2, 'asc' ]]
    });
}


function firstToUpperCase( str ) {
    return str.substr(0, 1).toUpperCase() + str.substr(1);
}

function google_autocomlete(){
    if ($('.address').length) {
        $('input.address').each(function () {
            var input = $(this).get(0);
            var options = {
                componentRestrictions: {country: 'ru'}
            };
            new google.maps.places.Autocomplete(input, options);
        });
    }
}

function open_bootbox_dialog(url) {
    window.location.href = url;
}

//Блокировка времени после значения
function disable_next(obj, value){
    var disable_next = false;
    $(obj).find('option').each(function () {
        if (disable_next){
            $(this).attr('disabled','');
        }
        if ($(this).text() == value){
            disable_next = true;
        }
    });
}

function chg_status(order_id){
    $.post("/orders/chg_status-1/", {order_id:order_id},  function(data) {
        bootbox.confirm({
            title: "Изменение статуса доставки в заказе № "+order_id,
            message: data,
            callback: function(result){ if(result){send_new_status()} }
        });
        // bootbox.alert(data,send_new_status(this));
    });
}

function cancel_order(order_id){
    bootbox.confirm({
        title: "Отмена заказа № "+order_id,
        message: "Вы уверены, что хотите отменить заказ № "+order_id+"?",
        callback: function(result){ if(result){
            $.post("/orders/chg_status-1/",
                {order_id:order_id,order_route_id:'',new_status:5,stat_comment:'отмена заказа',order_info_message:' '},
                function(data) {
                    bootbox.alert(data,location.reload());
                });
        } }
    });

}

function popup_excel(url) {
    bootbox.alert({
        title: "Экспорт в эксель",
        message: '<iframe style="border:0;" src="/'+url+'/without_menu-1/" height="200" width="100%"  scrolling="no"></iframe>',
        className: "minWidth",
        buttons: {
            'ok': {
                label: 'Закрыть',
                className: 'btn-default pull-left'
            }
        }
    });
}

function chg_courier(order_id){
    // var order_route_id = $('tr.order_'+order_id).first().attr('rel');
    $.post("/orders/chg_courier-1/", {order_id:order_id},  function(data) {
        bootbox.confirm({
            title: "Изменение курьера в заказе № "+order_id,
            message: data,
            callback: function(result){ if(result){send_new_courier()} }
        });
        //bootbox.alert(data,send_new_status(this));
    });
}

function add_phone_masks() {
    var $phone;
    // макси для ввода телефонов
    $('.phone-number')
        .keydown(function (e) {
            var key = e.which || e.charCode || e.keyCode || 0;
            $phone = $(this);
            // Don't let them remove the starting '('
            if ($phone.val().length === 1 && (key === 8 || key === 46)) {
                $phone.val('8');
                return false;
            }

            // Allow numeric (and tab, backspace, delete) keys only
            return (key == 8 ||
            key == 9 ||
            key == 46 ||
            (key >= 48 && key <= 57) ||
            (key >= 96 && key <= 105));
        })
        .bind('focus click', function () {
            $phone = $(this);

            if ($phone.val().length === 0) {
                $phone.val('8');
            }
            else {
                var val = $phone.val();
                $phone.val('').val(val); // Ensure cursor remains at the end
            }
        })
        .blur(function () {
            $phone = $(this);
            if ($phone.val() === '8') {
                $phone.val('');
            }
        });
}