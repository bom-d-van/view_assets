//= require_vendor jquery

$(document).ready(function(){ 
    $('ul.sf-menu').superfish({ 
        delay: 800,
        speed: 'fast',
        animation: { height: 'show' },
        dropShadows: true
    }); 
});