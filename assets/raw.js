var raw = "";
var makeObj = function(raw) {
    var rawParts = raw.split('\n');
    var words = [];
    for (var i =0; i < rawParts.length; i++) {
        var rawPart = rawParts[i];
        var subParts = rawPart.split('=');

        if (subParts.length === 5){// && ((parseInt(subParts[0]) - 1) === words.length)) {
            var word = {};
            word.word = $.trim(subParts[1]);
            word.part = $.trim(subParts[2]);
            word.def = $.trim(subParts[3]);
            word.example = $.trim(subParts[4]);
            words.push(word);
        } else if (subParts.length > 5){// && ((parseInt(subParts[0]) - 1) === words.length)) {
            var word = {};
            word.word = $.trim(subParts[1]);
            word.part = $.trim(subParts[2]);
            word.def = $.trim(subParts[3]);
            var example = '';
            for (var j = 4; j < subParts.length; j++) {
                example += subParts[j] + ' ';
            }
            word.example = $.trim(example);
            //console.log('oops: ' + JSON.stringify(word, null, 4));
            words.push(word);
        } else {
            console.log('subparts: ' + JSON.stringify(subParts, null, 4));
            console.log('words.length: ' + words.length + ' vs: ' + (parseInt(subParts[0]) - 1));
        }
    }
    return words;
}
var wordSchema = mongoose.Schema({
    word: {
        type: String,
        required: true
    },
    fromLanguage: {
        type: String,
        required: true
    },
    toLanguage: {
        type: String,
        required: true
    },
    def: String,
    example: String,
    rank: Number

var mO = function(raw) {
    var rawParts = raw.split('\n');
    var words = [];
    for (var i =0; i < rawParts.length; i++) {
        var rawPart = rawParts[i];
        var subParts = rawPart.split('=');

        if (subParts.length === 5 && ((parseInt(subParts[0]) - 1) === words.length)) {
            var word = {};
            word.rank = $.trim(subParts[0]);
            word.word = $.trim(subParts[1]);
            word.stem = word.word;
            // stemming
            var endings = ['a','o','as','os','es'];
            if (word.word.length > 2) {
                for (var k = 0; k < endings.length; k++) {
                    var suffix = endings[k];
                    // ends with ending
                    var start = str.indexOf(suffix, str.length - suffix.length);
                    if (start !== -1) {
                        // has stem ending, strip down to stem and use that 
                        word.stem = str.substr(0, start);
                    }
                }
            }

            word.part = $.trim(subParts[2]);
            word.def = $.trim(subParts[3]);
            word.example = $.trim(subParts[4]);
            word.fromLanguage = 'es';
            word.toLanguage = 'en';
            words.push(word);
        } else {
            console.log('subparts: ' + JSON.stringify(subParts, null, 4));
            console.log('words.length: ' + words.length + ' vs: ' + (parseInt(subParts[0]) - 1));
            break;
        }
    }

    for (var k = 0; k < 50; k++) {
        var wordsSection = words.slice(k*100, (k*100) + 100);

        $.ajax({
            type: 'POST',
            url: '/api/dictionary/add',
            dataType: 'json',
            data: {'words':wordsSection}
        });

    }
    
    return;
}


var makeObj = function(raw) {
    var rawParts = raw.split('\n');
    var words = [];
    for (var i =0; i < rawParts.length; i++) {
        var rawPart = rawParts[i];
        var subParts = rawPart.split('=');

        if (subParts.length === 5){// && ((parseInt(subParts[0]) - 1) === words.length)) {
            var word = {};
            word.word = $.trim(subParts[1]);
            word.part = $.trim(subParts[2]);
            word.def = $.trim(subParts[3]);
            word.example = $.trim(subParts[4]);
            words.push(word);
        } else if (subParts.length > 5){// && ((parseInt(subParts[0]) - 1) === words.length)) {
            var word = {};
            word.word = $.trim(subParts[1]);
            word.part = $.trim(subParts[2]);
            word.def = $.trim(subParts[3]);
            var example = '';
            for (var j = 4; j < subParts.length; j++) {
                example += subParts[j] + ' ';
            }
            word.example = $.trim(example);
            //console.log('oops: ' + JSON.stringify(word, null, 4));
            words.push(word);
        } else {
            console.log('subparts: ' + JSON.stringify(subParts, null, 4));
            console.log('words.length: ' + words.length + ' vs: ' + (parseInt(subParts[0]) - 1));
        }
    }
    return words;
}
var filterLines = function(raw) {
    var rawParts = raw.split('\n');
    var filter1 = '';
    
    var rawParts = raw.split('\n');
    for (var i =0; i < rawParts.length; i++) {
        var rawPart = rawParts[i];
        var subParts = rawPart.split('=');

        if (subParts.length === 5){// && ((parseInt(subParts[0]) - 1) === words.length)) {
            filter1 += $.trim(rawPart) + '\n';
        } else if (subParts.length > 5){// && ((parseInt(subParts[0]) - 1) === words.length)) {
            var word = '';
            word += subParts[0]+'=';
            word += subParts[1]+'=';
            word += subParts[2]+'=';
            word += subParts[3]+'=';
            var example = '';
            for (var j = 4; j < subParts.length; j++) {
                example += subParts[j] + ' ';
            }
            word += example;
            //console.log('oops: ' + JSON.stringify(word, null, 4));
            filter1 += $.trim(word) + '\n';
        } else {
            console.log('subparts: ' + JSON.stringify(subParts, null, 4));
            console.log('words.length: ' + words.length + ' vs: ' + (parseInt(subParts[0]) - 1));
        }
    }

    var b = new Blob([filter1],{encoding:"UTF-8",type:"text/plain;charset=UTF-8"});
    var url = URL.createObjectURL(b);
    window.open(url,"_blank","");
}

var filterLines = function(raw) {
    var rawParts = raw.split('\n');
    var filter1 = '';
    for (var i =0; i < rawParts.length; i++) {
        var rawPart = rawParts[i];
        if ($.trim(rawPart).length > 0 && !(/\d+=\d+/g.exec(rawPart))) {
            filter1 += rawPart + '\n';
        }
    }

    var filter1Parts = filter1.split('\n');
    var filter2 = '';
    for (var i =0; i < filter1Parts.length; i++) {
        var rawPart = filter1Parts[i];
        if (/\d+=/g.exec(rawPart)) {
            filter2 += '\n' + rawPart;
        } else {
            filter2 += rawPart;
        }
    }

    var b = new Blob([filter2],{encoding:"UTF-8",type:"text/plain;charset=UTF-8"});
    var url = URL.createObjectURL(b);
    window.open(url,"_blank","");
}
