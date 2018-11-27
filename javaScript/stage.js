$(document).ready(function () {

    /*scrool animatie , scrol vertragen*/
    $('a[href*="#"]:not([href="#"]):not([href="#show"]):not([href="#hide"])').click(function () {
        if (location.pathname.replace(/^\//, '') == this.pathname.replace(/^\//, '') && location.hostname == this.hostname) {
            var target = $(this.hash);
            target = target.length ? target : $('[name=' + this.hash.slice(1) + ']');
            if (target.length) {
                $('html,body').animate({
                    scrollTop: target.offset().top
                }, 1000);
                return false;
                /*lkmlkl*/
            }
        }
    });
    /*scrool animatie , scrol vertragen*/

   
    
var fileInput = document.getElementById("csv"),

    readFile = function () {
        var reader = new FileReader();
        reader.onload = function () {
            document.getElementById('out').innerHTML = reader.result;
        };

        // start reading the file. When it is done, calls the onload event defined above.
        var alltetline = [];
        
        reader.readAsBinaryString(fileInput.files[0]);
    };
    

//fileInput.addEventListener('change', readFile);











});
function myPrintjob() {
        window.print();
}