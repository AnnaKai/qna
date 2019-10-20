$(document).on('turbolinks:load', function() {
    $('.answers').on('click', '.edit-answer-link', function(e) {
        e.preventDefault();
        $(this).hide();
        var answerId = $(this).data('answerId');
        $('form#edit-answer-' + answerId).removeClass('d-none');
    });
    $('.answers').on('click', '.choose-answer', function(e) {
        e.preventDefault();
        $('.answer').removeClass('best');
        $answer = $(this).parent();
        $answer.addClass('best');
        $('.answers').prepend($answer);
    });
});
