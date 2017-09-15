// var minDate = new Date(new Date().setHours('08', '30', '00'));
// var maxDate = new Date(new Date().setHours('23', '00', '00'));
var timeoptions = {
    stepping: 5,
    enabledHours: [8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22],
    format: 'LT',
    useCurrent: false,
    locale: 'ru'
};


jQuery(function ($) {

    // Please wait...
    var $loading = $('#loadingDiv').hide();
    $(document)
        .ajaxStart(function () {
            $loading.show();
        })
        .ajaxStop(function () {
            $loading.hide();
        });

    $('.data-table').dataTable({"language": {
        "processing": "Подождите...",
        "search": "Поиск:",
        "lengthMenu": "Показать _MENU_ записей",
        "info": "Записи с _START_ до _END_ из _TOTAL_ записей",
        "infoEmpty": "Записи с 0 до 0 из 0 записей",
        "infoFiltered": "(отфильтровано из _MAX_ записей)",
        "infoPostFix": "",
        "loadingRecords": "Загрузка записей...",
        "zeroRecords": "Записи отсутствуют.",
        "emptyTable": "В таблице отсутствуют данные",
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
    }});

    add_data_table($('.new-logist-data-table'),'logist');

    $('.thumbnail').click(function () {
        var src = $(this).attr("src");
        var img = '<img src="' + src + '" style="width: 100%;" />';
        bootbox.alert(img);
    });

    if ($('.camera_wrap').length && $('body').width() > 768)
        $('.camera_wrap').camera({
            height: '200px'
        });


    $('#back-top').hide().find('a').click(function () {
        $('body,html').animate({
            scrollTop: 0
        }, 800);
        return false;
    });


    $(window).scroll(function(){
        if ($('.navbar').length > 0) {
            if (isVisisble($('.navbar'))) {
                $("#back-top").show();
            } else {
                $("#back-top").hide();
            }
        }
    });

    //ui_add();
    // автозаполнение улиц
    autoc_spb_streets();

    // Установка дата/время пикеров
    $('.time-picker').each(function () {
        $(this).datetimepicker(timeoptions).on("dp.change", function (e) {
            test_time_routes(this)
        });

    });

    $('select.select2').select2();

    $('.date-picker').datetimepicker({format: 'L', locale: 'ru'});

    var start_time = $('.time-picker.start').get();
    var end_time = $('.time-picker.end').get();
    set_time_period(start_time,end_time);

    if ($('#time_now').length){
        incTimeNow();
    }

    $('.js-street_upper').keyup(function () {
        $(this).val(firstToUpperCase($(this).val()));
    });

    $('.js-store_address').change(function() {
        if ($(this).val() == 0){
            $(this).parent().addClass('col-sm-4').removeClass('col-sm-10');
            $(this).parent().parent().find('.hand_write').show();
        }else{
            $(this).parent().addClass('col-sm-10').removeClass('col-sm-4');
            $(this).parent().parent().find('.hand_write').hide();
        }
    });

});
function incTimeNow() {
    $('#time_now').val(parseInt($('#time_now').val())+1);
    timestampToTime();
    setTimeout('incTimeNow()',1000);
}
function isVisisble(elem){
    //return $(elem).offset().top - $(window).scrollTop() < $(elem).height() ;
    return $(elem).offset().top - $(window).scrollTop() < -1 * $(elem).height() ;
}