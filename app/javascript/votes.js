$(document).on('turbolinks:load', function () {
    $('.vote').on('ajax:success', function (e) {
        const vote = e.detail[0];

        $('#' + vote.model + '-' + vote.object_id + ' .rating').html(vote.value)

    }).on('ajax:error', function (e) {
        const errors = e.detail[0];

        $.each(errors, function(_field, array) {
            $.each(array, function(_index, value) {
                alert(value);
            })
        })
    })
});
