$(document).on('turbolinks:load', function() {
    $('.answers').on('click', '.edit-answer-link', function(event) {
        event.preventDefault();
        $(this).hide();
        var answerId = $(this).data('answerId');
        $('form#edit-answer-' + answerId).removeClass('d-none');
    });
    $('.answers').on('click', '.choose-answer', function(event) {
        event.preventDefault();
        $('.answer').removeClass('best');
        $answer = $(this).parent();
        $answer.addClass('best');
        $('.answers').prepend($answer);
    });
    $('.question').on('click', '.edit-question-link', function(event) {
        event.preventDefault();
        $(this).hide();
        $('.question form').removeClass('d-none');
    });
});

(function (window, document) {
    document.addEventListener('DOMContentLoaded', function () {
        window.gistAsync();
    })
})(window, document);
