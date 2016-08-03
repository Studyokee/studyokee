'use strict';

var casper = casper || {};

casper.test.begin('Testing Classroom page', 1, function(test) {
    casper.start('http://localhost:3000/classrooms/1', function() {
        this.fill('form', {
            'username': 'testuser',
            'password': 'testuser'
        }, true);
    });

    casper.then(function() {
        test.assertTitle('Studyokee', 'Classroom page didn\'t have expected title');
    });

    casper.run(function() {
        test.done();
    });
});