'use strict';

var casper = casper || {};

casper.test.begin('Testing Classroom Page', 4, function(test) {
    casper.start('http://localhost:3000/classrooms/1', function() {
        this.fill('#login', {
            'username': 'testuser',
            'password': 'testuser'
        }, true);
        
        casper.waitForSelector('.classroom', function() {
            this.echo(this.getTitle());
            this.echo(this.getCurrentUrl());
        
            // Clear user data
            this.evaluate(function() {
                return __utils__.sendAJAX('http://localhost:3000/api/vocabulary/es/en', 'DELETE');
            });
            this.reload();
        });
    });

    casper.waitForText('Camino', function() { // Wait for text from first song to show up
        var found = this.getHTML('.songSelection .dropdown-toggle .classTitle');
        var expected = 'xxx by asdf';
        test.assertEquals(found, expected, 'Test correct song is chosen when no hash.');
    });

    casper.waitForText('Click on a word to lookup its definition', function() {
        this.click('a[data-lookup="por"]');
        casper.waitForText('by, for, through', function() {
            test.assertExists('.dictionaryContainer .wordType', 'Test dictionary updates with definition on click word.');
        });
    });

    casper.waitForSelector('a[data-lookup="sitio"]', function() {
        test.assertDoesntExist('a.unknown[data-lookup="sitio"]', 'Test word not marked as unknown on test start.');
        this.click('a[data-lookup="sitio"]');
        casper.waitForSelector('a.unknown[data-lookup="sitio"]', function() {
            test.assertExists('a.unknown[data-lookup="sitio"]', 'Test subtitle marked as unknown after lookup.');
        });
    });

    casper.run(function() {
        this.capture('test/screenshots/test1.png');
        test.done();
    });
});
