'use strict';

var mongoose = require('mongoose');
var Counter = require('./counter');
var q = require('q');

var Classroom;

var classroomSchema = mongoose.Schema({
    classroomId: {
        type: Number,
        unique: true,
        required: true
    },
    name: {
        type: String,
        required: true
    },
    language: {
        type: String,
        required: true
    },
    songs: [String],
    createdById: {
        type: 'String',
        required: true
    },
    type: String
});

classroomSchema.static('create', function (name, language, createdById) {
    return q.resolve().then(function () {
        return Counter.getNext('classroomId');
    }).then(function (classroomId) {
        var toSave = {
            name: name,
            language: language,
            classroomId: classroomId,
            createdById: createdById,
            isPublic: 'public'
        };
        var classroom = new Classroom(toSave);
        var saveRequest = q.defer();
        classroom.save(saveRequest.makeNodeResolver());
        return saveRequest.promise;
    });
});
    
Classroom = mongoose.model('Classroom', classroomSchema);
module.exports = Classroom;