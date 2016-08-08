'use strict';

var casper = casper || {};

casper.test.begin('Testing Classroom Page', 1, function(test) {
    casper.start('http://localhost:3000/classrooms/1', function() {
        this.fill('#login', {
            'username': 'testuser',
            'password': 'testuser'
        }, true);
        casper.waitForSelector('.classroom', function() {
            this.echo(this.getTitle());
            this.echo(this.getCurrentUrl());
        });
    });

    casper.waitForText('Camino', function() { // Wait for text from first song to show up
        var found = this.getHTML('.songSelection .dropdown-toggle .classTitle');
        var expected = 'xxx by asdf';
        test.assertEquals(found, expected, 'Test correct song is chosen when no hash.');
    });

    casper.run(function() {
        this.capture('test/screenshots/test1.png');
        test.done();
    });
});
