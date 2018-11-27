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



                const csv_to_array = (data, delimiter = ',', omitFirstRow = false) =>
                    data
                    .slice(omitFirstRow ? data.indexOf('\n') + 1 : 0)
                    .split('\n')
                    .map(v => v.split(delimiter));

                console.log(csv_to_array(reader.result)); 


                var values = reader.result.split(',');
                console.log(values);


            };

            // start reading the file. When it is done, calls the onload event defined above.
            reader.readAsBinaryString(fileInput.files[0]);

        };

    fileInput.addEventListener('change', readFile);

    // $.csv.toArrays(readFile);
    /*  function processData(allText) {
    var record_num = 14;  // or however many elements there are in each row
    var allTextLines = allText.split(/\r\n|\n/);
    var entries = allTextLines[0].split(',');
    var lines = [];

    var headings = entries.splice(0,record_num);
    while (entries.length>0) {
        var tarr = [];
        for (var j=0; j<record_num; j++) {
            tarr.push(headings[j]+":"+entries.shift());
        }
        lines.push(tarr);
    }
    // alert(lines);
}*/


});
