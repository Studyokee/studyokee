(function() {
  define(['backbone'], function(Backbone) {
    var SubtitlesScrollerModel;
    SubtitlesScrollerModel = Backbone.Model.extend({
      initialize: function() {
        var _this = this;
        this.on('change:currentSong', function() {
          return _this.reset();
        });
        this.on('change:vocabulary', function() {
          return _this.updateFormattedData();
        });
        this.on('change:subtitles', function() {
          return _this.updateFormattedData();
        });
        return this.on('change:songData', function() {
          return _this.parseAndUpdateSongData(_this.get('songData'));
        });
      },
      reset: function() {
        return this.set({
          translation: null,
          resolutions: null,
          subtitles: null,
          processedLines: null,
          i: 0
        });
      },
      empty: function() {
        return this.set({
          translation: [],
          resolutions: {},
          subtitles: [],
          processedLines: [],
          i: 0
        });
      },
      updateFormattedData: function() {
        this.updateVocabularyMaps();
        return this.set({
          formattedData: this.formatData()
        });
      },
      updateVocabularyMaps: function() {
        return this.set(this.convertVocabularyArrayToMaps());
      },
      parseAndUpdateSongData: function(songData) {
        var resolution, resolutions, resolutionsArray, translation, _i, _len;
        if (songData == null) {
          this.empty();
        }
        resolutions = {};
        if (songData.resolutions != null) {
          resolutionsArray = songData.resolutions;
          for (_i = 0, _len = resolutionsArray.length; _i < _len; _i++) {
            resolution = resolutionsArray[_i];
            resolutions[resolution.word] = resolution.resolution;
          }
        }
        translation = [];
        if (songData.translations.length > 0) {
          translation = songData.translations[0].data;
        }
        return this.set({
          subtitles: songData.subtitles,
          translation: translation,
          resolutions: resolutions,
          i: 0
        });
      },
      getLength: function() {
        var lines;
        lines = this.get('formattedData');
        if (lines) {
          return lines.length;
        } else {
          return null;
        }
      },
      formatData: function() {
        var formattedData, i, line, processedSubtitles, subtitles, subtitlesElements, translation, word, _i, _j, _len, _len1;
        processedSubtitles = this.processSubtitles();
        subtitles = this.get('subtitles');
        translation = this.get('translation');
        if (!(processedSubtitles != null ? processedSubtitles.length : void 0) > 0 || !processedSubtitles.length === subtitles.length || !processedSubtitles.length === translation.length) {
          return [];
        }
        formattedData = [];
        for (i = _i = 0, _len = processedSubtitles.length; _i < _len; i = ++_i) {
          line = processedSubtitles[i];
          subtitlesElements = '';
          for (_j = 0, _len1 = line.length; _j < _len1; _j++) {
            word = line[_j];
            if (word.word) {
              subtitlesElements += '<a href="javaScript:void(0);" class="' + word.tag + '" data-lookup="' + word.lookup + '">' + word.word + '</a>';
            } else {
              subtitlesElements += word;
            }
          }
          formattedData.push({
            original: subtitlesElements,
            translation: translation[i],
            ts: subtitles[i].ts
          });
        }
        return formattedData;
      },
      processSubtitles: function() {
        var cLoc, i, processedSubtitleLine, processedSubtitles, processedWord, rawLine, resolvedWord, subtitleWords, subtitles, vocabulary, word, wordLoc, _i, _j, _len, _ref;
        vocabulary = this.get('vocabulary');
        subtitles = this.get('subtitles');
        if (!vocabulary || !subtitles || subtitles.length === 0) {
          return;
        }
        processedSubtitles = [];
        for (i = _i = 0, _ref = subtitles.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
          cLoc = 0;
          processedSubtitleLine = [];
          rawLine = subtitles[i].text;
          subtitleWords = this.getWords(rawLine);
          if (subtitleWords) {
            for (_j = 0, _len = subtitleWords.length; _j < _len; _j++) {
              word = subtitleWords[_j];
              wordLoc = rawLine.substr(cLoc).indexOf(word);
              if (wordLoc > 0) {
                processedSubtitleLine.push(rawLine.substr(cLoc, wordLoc));
              }
              resolvedWord = this.resolveWord(word);
              processedWord = {
                word: word,
                tag: this.getTag(resolvedWord),
                lookup: resolvedWord
              };
              processedSubtitleLine.push(processedWord);
              cLoc = cLoc + wordLoc + word.length;
            }
          }
          if (cLoc < rawLine.length) {
            processedSubtitleLine.push(rawLine.substr(cLoc));
          }
          processedSubtitles.push(processedSubtitleLine);
        }
        return processedSubtitles;
      },
      resolveWord: function(word) {
        var lower, resolutions;
        resolutions = this.get('resolutions');
        lower = word.toLowerCase();
        if (resolutions[lower]) {
          word = resolutions[lower];
        }
        return word;
      },
      getWords: function(line) {
        var regex, words;
        regex = /([ÀÈÌÒÙàèìòùÁÉÍÓÚÝáéíóúýÂÊÎÔÛâêîôûÃÑÕãñõÄËÏÖÜŸäëïöüŸçÇŒœßØøÅåÆæÞþÐð\w]+)/gi;
        words = line.match(regex);
        if (!(words != null ? words.length : void 0) > 0) {
          return [line];
        }
        return words;
      },
      convertVocabularyArrayToMaps: function() {
        var known, knownStems, maps, unknown, unknownStems, vocabulary, word, _i, _len, _ref, _ref1, _ref2, _ref3;
        vocabulary = this.get('vocabulary');
        known = {};
        unknown = {};
        knownStems = {};
        unknownStems = {};
        if (vocabulary != null) {
          for (_i = 0, _len = vocabulary.length; _i < _len; _i++) {
            word = vocabulary[_i];
            if (word.known) {
              known[(_ref = word.word) != null ? _ref.toLowerCase() : void 0] = 1;
              knownStems[(_ref1 = word.stem) != null ? _ref1.toLowerCase() : void 0] = 1;
            } else {
              unknown[(_ref2 = word.word) != null ? _ref2.toLowerCase() : void 0] = 1;
              unknownStems[(_ref3 = word.stem) != null ? _ref3.toLowerCase() : void 0] = 1;
            }
          }
        }
        maps = {
          known: known,
          unknown: unknown,
          knownStems: knownStems,
          unknownStems: unknownStems
        };
        return maps;
      },
      getTag: function(word) {
        var endings, known, knownStems, start, stem, suffix, unknown, unknownStems, _i, _len;
        known = this.get('known');
        unknown = this.get('unknown');
        knownStems = this.get('knownStems');
        unknownStems = this.get('unknownStems');
        if (known[word.toLowerCase()] != null) {
          return 'known';
        } else if (unknown[word.toLowerCase()] != null) {
          return 'unknown';
        }
        endings = ['a', 'o', 'as', 'os', 'es'];
        stem = null;
        if (word.length > 2) {
          for (_i = 0, _len = endings.length; _i < _len; _i++) {
            suffix = endings[_i];
            start = word.indexOf(suffix, word.length - suffix.length);
            if (start !== -1) {
              stem = word.substr(0, start);
              break;
            }
          }
          if ((stem != null) && (knownStems[stem.toLowerCase()] != null)) {
            return 'known';
          } else if ((stem != null) && (unknownStems[stem.toLowerCase()] != null)) {
            return 'unknown';
          }
        }
        return '';
      }
    });
    return SubtitlesScrollerModel;
  });

}).call(this);

/*
//@ sourceMappingURL=subtitles-scroller-model.js.map
*/