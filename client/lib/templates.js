define(['handlebars'], function(Handlebars) {

this["Handlebars"] = this["Handlebars"] || {};
this["Handlebars"]["templates"] = this["Handlebars"]["templates"] || {};

this["Handlebars"]["templates"]["add-song"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  


  return "<input class=\"search\" placeholder=\"Search Rdio\"/>\n<div class=\"acContainer\" style=\"display:none;\"></div>";
  });

this["Handlebars"]["templates"]["create-classroom"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression;


  buffer += "<div class=\"container\">\n    <div class=\"row\">\n        <div class=\"createClassroom col-lg-6 col-lg-offset-3\">\n            <form>\n                <fieldset>\n                    <legend>Create Classroom</legend>\n                    <div class=\"form-horizontal\">\n                        <div class=\"form-group\">\n                            <label for=\"name\" class=\"col-lg-6\">Name</label>\n                            <div class=\"col-lg-6\">\n                                <input type=\"text\" class=\"form-control\" id=\"name\" placeholder=\"Name\">\n                            </div>\n                        </div>\n                        <div class=\"form-group\">\n                            <label for=\"language\" class=\"col-lg-6\">Language Being Taught</label>\n                            <div class=\"col-lg-6\">\n                                <input type=\"text\" class=\"form-control\" id=\"language\" value=\""
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.fromLanguage)),stack1 == null || stack1 === false ? stack1 : stack1.display)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\" readonly>\n                            </div>\n                        </div>\n                        <div class=\"form-group\">\n                            <div class=\"col-lg-6 col-lg-offset-6\">\n                                <button class=\"btn btn-default cancel\">Cancel</button> \n                                <button type=\"submit\" class=\"btn btn-primary save\">Save</button> \n                            </div>\n                        </div>\n                    </div>\n                </fieldset>\n            </form>\n        </div>\n    </div>\n</div>";
  return buffer;
  });

this["Handlebars"]["templates"]["create-song"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  


  return "<div class=\"form-horizontal\">\n    <div class=\"form-group\">\n        <label for=\"youtubeKey\" class=\"col-lg-3 control-label\">Youtube Link</label>\n        <div class=\"col-lg-9\">\n            <input type=\"text\" class=\"form-control\" id=\"youtubeKey\" placeholder=\"https://www.youtube.com/watch?v=...\" autocomplete=\"off\">\n        </div>\n    </div>\n    <div class=\"form-group\">\n        <label for=\"trackName\" class=\"col-lg-3 control-label\">Track Name</label>\n        <div class=\"col-lg-9\">\n            <input type=\"text\" class=\"form-control\" id=\"trackName\" placeholder=\"Track Name\" autocomplete=\"off\">\n        </div>\n    </div>\n    <div class=\"form-group\">\n        <label for=\"artist\" class=\"col-lg-3 control-label\">Artist</label>\n        <div class=\"col-lg-9\">\n            <input type=\"text\" class=\"form-control\" id=\"artist\" placeholder=\"Artist\" autocomplete=\"off\">\n        </div>\n    </div>\n    <button class=\"btn btn-default cancel\">Cancel</button> \n    <button type=\"submit\" class=\"btn btn-primary save\">Create and Add</button>\n</div>";
  });

this["Handlebars"]["templates"]["edit-classroom"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression;


  buffer += "<div class=\"container\">\n    <div class=\"row\">\n        <div class=\"editClassroom col-lg-8 col-lg-offset-2\">\n            <h2 class=\"\">\n                <span class=\"classroomTitle\">"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.data)),stack1 == null || stack1 === false ? stack1 : stack1.name)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "</span>\n                <input type=\"text\" id=\"name\" class=\"form-control editClassroomTitle\" placeholder=\""
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.data)),stack1 == null || stack1 === false ? stack1 : stack1.name)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\" value=\""
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.data)),stack1 == null || stack1 === false ? stack1 : stack1.name)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\" style=\"display:none;\"/>\n                <a href=\"/classrooms/"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.data)),stack1 == null || stack1 === false ? stack1 : stack1.classroomId)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\" class=\"btn btn-info btn-xs viewClassroom\">view</a>\n                <a href=\"/\" class=\"btn btn-info btn-xs deleteClassroom\">delete</a>\n            </h2>\n            <div>\n                <label class=\"\">Add Video</label>\n                <div class=\"input-group addSongSection\">\n                    <input type=\"text\" class=\"form-control\" id=\"searchSongs\" placeholder=\"Search by artist or title\" autocomplete=\"off\">\n                    <span class='separatingText'> or </span>\n                    <button class=\"btn btn-primary addNewSong\">Add New Video</button>\n                    <div class=\"songSearchListContainer\" style=\"display:none;\"></div>\n                    <div class=\"addNewSongModal\" style=\"display:none;\">\n                        <div class=\"modal fade in\">\n                            <div class=\"modal-dialog\">\n                                <div class=\"modal-content\">\n                                    <div class=\"modal-header\">\n                                        <button type=\"button\" class=\"close closeAddSongModal\" data-dismiss=\"modal\" aria-hidden=\"true\">×</button>\n                                        <h4 class=\"modal-title\">Create Video</h4>\n                                    </div>\n                                    <div class=\"modal-body addNewSongContainer\"></div>\n                                </div>\n                            </div>\n                        </div>\n                        <div class=\"modal-backdrop fade in\"></div>\n                    </div>\n                </div>\n            </div>\n            <h3>Videos <span class=\"songCount\"></span></h3>\n            <div class=\"songListContainer col-lg-8\"></div>\n        </div>\n    </div>\n</div>";
  return buffer;
  });

this["Handlebars"]["templates"]["edit-song"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, stack2, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                                <tr data-index=\"";
  if (stack1 = helpers['i']) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0['i']); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "\">\n                                    <td class=\"col-lg-6 subtitles editSubtitleLineLink\">\n                                        <span class=\"col-lg-2 control-label\">";
  if (stack1 = helpers.ts) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.ts); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + ":&nbsp;</span>\n                                        <span class=\"col-lg-10\">\n                                            <textarea type=\"text\" class=\"form-control editSubtitleLine textInput\">";
  if (stack1 = helpers.text) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.text); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "</textarea>\n                                        </span>\n                                    </td>\n                                    <td class=\"col-lg-6 editTranslationLineLink\">\n                                        <textarea type=\"text\" class=\"form-control editTranslationLine textInput\">";
  if (stack1 = helpers.translation) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.translation); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "</textarea>\n                                    </td>\n                                </tr>\n                            ";
  return buffer;
  }

  buffer += "<div class=\"container \">\n    <div class=\"row\">\n        <div class=\"editSong col-lg-12\">\n            <form>\n                <fieldset>\n                    <legend>\n                        Edit Song\n                        <a href=\"/\" class=\"btn btn-info btn-sm deleteClassroom\">delete</a>\n                    </legend>\n                    <div class=\"form-horizontal songDetails\">\n                        <div class=\"form-group\">\n                            \n                        </div>\n                        <div class=\"form-group\">\n                            <label for=\"trackName\" class=\"col-lg-3 control-label\">Track Name</label>\n                            <div class=\"col-lg-3\">\n                                <input type=\"text\" class=\"form-control\" id=\"trackName\" placeholder=\"Track Name\" value=\""
    + escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.data)),stack1 == null || stack1 === false ? stack1 : stack1.metadata)),stack1 == null || stack1 === false ? stack1 : stack1.trackName)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\">\n                            </div>\n                        </div>\n                        <div class=\"form-group\">\n                            <label for=\"artist\" class=\"col-lg-3 control-label\">Artist</label>\n                            <div class=\"col-lg-3\">\n                                <input type=\"text\" class=\"form-control\" id=\"artist\" placeholder=\"Artist\" value=\""
    + escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.data)),stack1 == null || stack1 === false ? stack1 : stack1.metadata)),stack1 == null || stack1 === false ? stack1 : stack1.artist)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\">\n                            </div>\n                        </div>\n                        <div class=\"form-group\">\n                            <label for=\"youtubeKey\" class=\"col-lg-3 control-label\">Youtube Link</label>\n                            <div class=\"col-lg-6\">\n                                <input type=\"text\" class=\"form-control\" id=\"youtubeKey\" placeholder=\"https://www.youtube.com/watch?v=...\" value=\"http://www.youtube.com/watch?v="
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.data)),stack1 == null || stack1 === false ? stack1 : stack1.youtubeKey)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\">\n                            </div>\n                        </div>\n                    </div>\n                    <div class=\"form-group col-lg-6\">\n                        <h3>\n                            Subtitles \n                            <button type=\"button\" class=\"btn btn-primary btn-sm uploadSubtitles\">upload</button>\n                            <button type=\"button\" class=\"btn btn-primary btn-sm clearSubtitles\">clear</button>\n                            <button type=\"button\" class=\"btn btn-primary btn-sm syncSubtitles\">sync</button>\n                            <div class=\"editSubtitlesModal\" style=\"display:none;\">\n                                <div class=\"modal fade in\">\n                                    <div class=\"modal-dialog\">\n                                        <div class=\"modal-content\">\n                                            <div class=\"modal-header\">\n                                                <button type=\"button\" class=\"close closeEditSubtitlesModal\" data-dismiss=\"modal\" aria-hidden=\"true\">×</button>\n                                                <h4 class=\"modal-title\">Edit Subtitles</h4>\n                                            </div>\n                                            <div class=\"modal-body\">\n                                                <textarea rows=\"8\" class=\"form-control\" id=\"subtitlesEdit\" placeholder=\"Enter subtitles...\">";
  if (stack2 = helpers.subtitlesText) { stack2 = stack2.call(depth0, {hash:{},data:data}); }
  else { stack2 = (depth0 && depth0.subtitlesText); stack2 = typeof stack2 === functionType ? stack2.call(depth0, {hash:{},data:data}) : stack2; }
  if(stack2 || stack2 === 0) { buffer += stack2; }
  buffer += "</textarea>\n                                            </div>\n                                            <div class=\"modal-footer\">\n                                                <button type=\"button\" class=\"btn btn-default closeEditSubtitlesModal\" data-dismiss=\"modal\" title=\"Cancel\">Cancel</button>\n                                                <button type=\"button\" class=\"btn btn-primary saveSubtitles\" title=\"Save changes\">Save changes</button>\n                                            </div>\n                                        </div>\n                                    </div>\n                                </div>\n                                <div class=\"modal-backdrop fade in\"></div>\n                            </div>\n                            <div class=\"syncSubtitlesModal\" style=\"display:none;\">\n                                <div class=\"modal fade in\">\n                                    <div class=\"modal-dialog modal-lg\">\n                                        <div class=\"modal-content\">\n                                            <div class=\"modal-header\">\n                                                <button type=\"button\" class=\"close closeSyncSubtitlesModal\" data-dismiss=\"modal\" aria-hidden=\"true\">×</button>\n                                                <h4 class=\"modal-title\">Sync Subtitles</h4>\n                                            </div>\n                                            <div class=\"modal-body\">\n                                                <div class=\"syncSubtitlesContainer\"></div>\n                                            </div>\n                                            <div class=\"modal-footer\">\n                                                <button type=\"button\" class=\"btn btn-default closeSyncSubtitlesModal\" data-dismiss=\"modal\" title=\"Cancel\">Cancel</button>\n                                                <button type=\"button\" class=\"btn btn-primary saveSyncSubtitles\" title=\"Save changes\">Save changes</button>\n                                            </div>\n                                        </div>\n                                    </div>\n                                </div>\n                                <div class=\"modal-backdrop fade in\"></div>\n                            </div>\n                        </h3>\n                    </div>\n                    <div class=\"form-group col-lg-6\">\n                        <h3>\n                            Translation\n                            <button type=\"button\" class=\"btn btn-primary btn-sm uploadTranslation\">upload</button>\n                            <button type=\"button\" class=\"btn btn-primary btn-sm clearTranslation\">clear</button>\n                            <div class=\"editTranslationModal\" style=\"display:none;\">\n                                <div class=\"modal fade in\">\n                                    <div class=\"modal-dialog\">\n                                        <div class=\"modal-content\">\n                                            <div class=\"modal-header\">\n                                                <button type=\"button\" class=\"close closeTranslationModal\" data-dismiss=\"modal\" aria-hidden=\"true\">×</button>\n                                                <h4 class=\"modal-title\">Upload Translation</h4>\n                                            </div>\n                                            <div class=\"modal-body\">\n                                                <textarea rows=\"8\" class=\"form-control\" id=\"translationEdit\" placeholder=\"Enter translation...\"></textarea>\n                                            </div>\n                                            <div class=\"modal-footer\">\n                                                <button type=\"button\" class=\"btn btn-default closeTranslationModal\" data-dismiss=\"modal\" title=\"Cancel\">Cancel</button>\n                                                <button type=\"button\" class=\"btn btn-primary saveTranslation\" title=\"Save changes\">Save changes</button>\n                                            </div>\n                                        </div>\n                                    </div>\n                                </div>\n                                <div class=\"modal-backdrop fade in\"></div>\n                            </div>\n                        </h3>\n                    </div>\n                    <div class=\"col-lg-12 lyricsGrid\">\n                        <table class=\"col-lg-12 songText table table-striped\">\n                            <tbody>\n                            ";
  stack2 = helpers.each.call(depth0, (depth0 && depth0.lyrics), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack2 || stack2 === 0) { buffer += stack2; }
  buffer += "\n                            </tbody>\n                        </table>\n                    </div>\n                </fieldset>\n            </form>\n        </div>\n        <div class=\"modal addResolution\" style=\"display:none\">\n          <div class=\"modal-dialog\">\n            <div class=\"modal-content\">\n              <div class=\"modal-header\">\n                <button type=\"button\" class=\"close closeModal\" data-dismiss=\"modal\" aria-hidden=\"true\">x</button>\n                <h4 class=\"modal-title\">Resolve Word</h4>\n              </div>\n              <div class=\"modal-body\">\n                <div class=\"form-group\">\n                  <label class=\"control-label\" for=\"resolution\">Resolve '<span class=\"resolveWord\"></span>' to:</label>\n                  <input class=\"form-control\" id=\"resolution\" type=\"text\" value=\"\">\n                </div>\n              </div>\n              <div class=\"modal-footer\">\n                <button type=\"button\" class=\"btn btn-default closeModal\" data-dismiss=\"modal\">Close</button>\n                <button type=\"button\" class=\"btn btn-primary addDefinition\">Define</button>\n                <button type=\"button\" class=\"btn btn-primary saveResolution\">Save</button>\n              </div>\n            </div>\n          </div>\n        </div>\n    </div>\n</div>";
  return buffer;
  });

this["Handlebars"]["templates"]["edit-songs"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1, stack2;
  buffer += "\n                    <tr>\n                        <td>\n                            <button class=\"open btn btn-primary btn-xs\" data-index=\""
    + escapeExpression(((stack1 = ((stack1 = data),stack1 == null || stack1 === false ? stack1 : stack1.index)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\">Open</button>\n                        </td>\n                        <td>\n                            <button class=\"remove btn btn-primary btn-xs\" data-index=\""
    + escapeExpression(((stack1 = ((stack1 = data),stack1 == null || stack1 === false ? stack1 : stack1.index)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\">Remove</button>\n                        </td>\n                        <td>\n                            "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.metadata)),stack1 == null || stack1 === false ? stack1 : stack1.trackName)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                        </td>\n                        <td>\n                            "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.metadata)),stack1 == null || stack1 === false ? stack1 : stack1.artist)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                        </td>\n                        <td>\n                            ";
  if (stack2 = helpers.youtubeKey) { stack2 = stack2.call(depth0, {hash:{},data:data}); }
  else { stack2 = (depth0 && depth0.youtubeKey); stack2 = typeof stack2 === functionType ? stack2.call(depth0, {hash:{},data:data}) : stack2; }
  buffer += escapeExpression(stack2)
    + "\n                        </td>\n                        <td>\n                            "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.metadata)),stack1 == null || stack1 === false ? stack1 : stack1.language)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                        </td>\n                        <td>\n                            "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.translations)),stack1 == null || stack1 === false ? stack1 : stack1.length)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                        </td>\n                        <td>\n                            ";
  if (stack2 = helpers._id) { stack2 = stack2.call(depth0, {hash:{},data:data}); }
  else { stack2 = (depth0 && depth0._id); stack2 = typeof stack2 === functionType ? stack2.call(depth0, {hash:{},data:data}) : stack2; }
  buffer += escapeExpression(stack2)
    + "\n                        </td>\n                    </tr>\n                ";
  return buffer;
  }

  buffer += "<div class=\"col-lg-12 panel panel-default\">\n    <div class=\"panel-body\">\n        <div class=\"table-responsive\">\n            <table class=\"table table-striped table-bordered table-hover\">\n                <thead>\n                    <tr>\n                        <td>\n                            Open\n                        </td>\n                        <td>\n                            Remove\n                        </td>\n                        <td>\n                            Track Name\n                        </td>\n                        <td>\n                            Artist\n                        </td>\n                        <td>\n                            Youtube Key\n                        </td>\n                        <td>\n                            Language\n                        </td>\n                        <td>\n                            # Translations\n                        </td>\n                        <td>\n                            _id\n                        </td>\n                    </tr>\n                </thead>\n                <tbody>\n                ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.data), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                </tbody>\n            </table>\n        </div>\n    </div>\n</div>";
  return buffer;
  });

this["Handlebars"]["templates"]["youtube-sync-subtitles"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, self=this, functionType="function", escapeExpression=this.escapeExpression;

function program1(depth0,data) {
  
  var buffer = "", stack1, stack2;
  buffer += "\n        ";
  stack2 = helpers['if'].call(depth0, ((stack1 = data),stack1 == null || stack1 === false ? stack1 : stack1.first), {hash:{},inverse:self.noop,fn:self.program(2, program2, data),data:data});
  if(stack2 || stack2 === 0) { buffer += stack2; }
  buffer += "\n        <li class=\"subtitle list-group-item\" data-index=\""
    + escapeExpression(((stack1 = ((stack1 = data),stack1 == null || stack1 === false ? stack1 : stack1.index)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\">\n            <span class=\"subtitle-timestamp label label-default\">";
  if (stack2 = helpers.ts) { stack2 = stack2.call(depth0, {hash:{},data:data}); }
  else { stack2 = (depth0 && depth0.ts); stack2 = typeof stack2 === functionType ? stack2.call(depth0, {hash:{},data:data}) : stack2; }
  buffer += escapeExpression(stack2)
    + "</span>\n            <div class=\"original-subtitle\">\n                <span class=\"subtitle-text\">";
  if (stack2 = helpers.text) { stack2 = stack2.call(depth0, {hash:{},data:data}); }
  else { stack2 = (depth0 && depth0.text); stack2 = typeof stack2 === functionType ? stack2.call(depth0, {hash:{},data:data}) : stack2; }
  if(stack2 || stack2 === 0) { buffer += stack2; }
  buffer += "</span>\n            </div>\n            <div class=\"input-group updateLine\" style=\"display:none;\">\n                <input type=\"text\" class=\"form-control toAdd\" placeholder=\"Line to insert...\" autocomplete=\"off\">\n                <span class=\"input-group-btn\">\n                    <button class=\"btn btn-primary addLine\" type=\"button\">\n                        Save\n                    </button>\n                </span>\n            </div>\n            <button type=\"button\" class=\"edit action btn btn-primary btn-sm\" title=\"Edit Line\">edit</button>\n            <button type=\"button\" class=\"remove action close\" title=\"Remove Line\">×</button>\n        </li>\n        ";
  stack2 = helpers['if'].call(depth0, ((stack1 = data),stack1 == null || stack1 === false ? stack1 : stack1.first), {hash:{},inverse:self.noop,fn:self.program(4, program4, data),data:data});
  if(stack2 || stack2 === 0) { buffer += stack2; }
  buffer += "\n    ";
  return buffer;
  }
function program2(depth0,data) {
  
  
  return "\n        <div class=\"insertBefore text-center\">\n            <button type=\"button\" class=\"openInsert btn btn-primary\" title=\"Insert line before\">\n                Insert line&nbsp;<span class=\"glyphicon glyphicon-chevron-down\"></span>\n            </button>\n            <div class=\"input-group insertLine\" style=\"display:none;\">\n                <input type=\"text\" class=\"form-control toAdd\" placeholder=\"Line to insert...\" autocomplete=\"off\">\n                <span class=\"input-group-btn\">\n                    <button class=\"btn btn-info addLine\" type=\"button\">\n                        <span class=\"glyphicon glyphicon-plus\"></span>\n                    </button>\n                </span>\n            </div>\n        </div>\n        ";
  }

function program4(depth0,data) {
  
  
  return "\n        <div class=\"insertAfter text-center\">\n            <button type=\"button\" class=\"openInsert btn btn-primary\" title=\"Insert line after\">\n                Insert line&nbsp;<span class=\"glyphicon glyphicon-chevron-up\"></span>\n            </button>\n            <div class=\"input-group insertLine\" style=\"display:none;\">\n                <input type=\"text\" class=\"form-control toAdd\" placeholder=\"Line to insert...\" autocomplete=\"off\">\n                <span class=\"input-group-btn\">\n                    <button class=\"btn btn-info addLine\" type=\"button\">\n                        <span class=\"glyphicon glyphicon-plus\"></span>\n                    </button>\n                </span>\n            </div>\n        </div>\n        ";
  }

  buffer += "<ul class='subtitles list-group col-md-12'>\n    ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.subtitles), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n</ul>";
  return buffer;
  });

this["Handlebars"]["templates"]["youtube-sync"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  


  return "<div class=\"video-player-container\">\n    <div class=\"video-container\" id=\"ytPlayerSync\"></div>\n    <div class=\"controls-container\"></div>\n</div>\n<button type=\"button\" class=\"toggleSync btn\" ></button>\n<div class=\"subtitles-container\"></div>";
  });

this["Handlebars"]["templates"]["classroom"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression;


  buffer += "<div class=\"classroom\">\n    <div class=\"container menu\">\n        <div class=\"col-md-12 menuContent\">\n            <div class=\"titleContainer text-center col-md-6\">\n                <h2>\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.classroom)),stack1 == null || stack1 === false ? stack1 : stack1.name)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                    <a href=\"/classrooms/"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.classroom)),stack1 == null || stack1 === false ? stack1 : stack1.classroomId)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "/edit\" class=\"btn btn-info btn-xs editClassroomButton\" style=\"display:none;\">edit</a>\n                </h2>\n            </div>\n            <div class=\"text-right col-md-6\">\n                <div class=\"dropdown songSelection\">\n                    <button class=\"btn btn-info dropdown-toggle\" type=\"button\" data-toggle=\"dropdown\" aria-haspopup=\"true\" aria-expanded=\"true\">\n                        <span class=\"classTitle\">"
    + escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.currentSong)),stack1 == null || stack1 === false ? stack1 : stack1.metadata)),stack1 == null || stack1 === false ? stack1 : stack1.trackName)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + " by "
    + escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.currentSong)),stack1 == null || stack1 === false ? stack1 : stack1.metadata)),stack1 == null || stack1 === false ? stack1 : stack1.artist)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "</span>&nbsp;<span class=\"caret\"></span>\n                    </button>\n                    <div class=\"mediaItemListContainer dropdown-menu dropdown-menu-right\"></div>\n                </div>\n            </div>\n        </div>\n    </div>\n    <div class=\"center container\">\n        <div class=\"col-md-8\">\n            <div class=\"controls-container\"></div>\n            <div class=\"player-container\"></div>\n        </div>\n        <div class=\"col-md-4\">\n            <div class=\"video-player-container hidden-xs\"></div>\n            <div class=\"dictionaryContainerWrapper\">\n                <button type=\"button\" class=\"close visible-xs-block\" aria-label=\"Close\">\n                  <span aria-hidden=\"true\">&times;</span>\n                </button>\n                <div class=\"dictionaryContainer\"></div>\n            </div>\n            <img src=\"../../../img/pencils.png\" class=\"pencilIllustration hidden-xs\">\n            <span class=\"visible-xs-block bg-warning\">Studyokee uses Youtube videos to play songs and will consume data accordingly.</span>\n        </div>\n    </div>\n</div>";
  return buffer;
  });

this["Handlebars"]["templates"]["dictionary"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n        <div class=\"deVersion\">\n        ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.lookup), {hash:{},inverse:self.program(4, program4, data),fn:self.program(2, program2, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n        </div>\n    ";
  return buffer;
  }
function program2(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n            <p>\n                <a href=\"#\" class=\"lookupEmbed\">\"";
  if (stack1 = helpers.lookup) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.lookup); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "\"</a>\n            </p>\n            <div class=\"lookup\"><span class=\"glyphicon glyphicon-refresh glyphicon-spin\"></span></div>\n            <div class=\"embeddedLookup\"><iframe sandbox=\"allow-same-origin allow-popups allow-forms\" src=\"http://dict.tu-chemnitz.de/?mini=1&query=";
  if (stack1 = helpers.lookup) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.lookup); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "\" width=\"100%\" height=\"400\" frameborder=\"0\" id=\"dictionaryIframe\"></iframe></div>\n        ";
  return buffer;
  }

function program4(depth0,data) {
  
  
  return "\n            <span class=\"text-muted explanation\">Click on a word to lookup its definition</span>\n        ";
  }

function program6(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n        <div class=\"lookup\">\n            ";
  stack1 = helpers['with'].call(depth0, (depth0 && depth0.dictionaryResult), {hash:{},inverse:self.noop,fn:self.program(7, program7, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n        </div>\n    ";
  return buffer;
  }
function program7(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                <p><b>\"";
  if (stack1 = helpers.word) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.word); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "\"</b></p>\n                <div>\n                    <p>\n                        <b>";
  if (stack1 = helpers.def) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.def); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "</b>";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.part), {hash:{},inverse:self.noop,fn:self.program(8, program8, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                    </p>\n                    ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.example), {hash:{},inverse:self.noop,fn:self.program(10, program10, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                </div>\n            ";
  return buffer;
  }
function program8(depth0,data) {
  
  var buffer = "", stack1;
  buffer += ",&nbsp;<i class=\"wordType\">";
  if (stack1 = helpers.part) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.part); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "</i>";
  return buffer;
  }

function program10(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "<p><b>ex.</b> ";
  if (stack1 = helpers.example) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.example); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "</p>";
  return buffer;
  }

  buffer += "<div class=\"panel-heading\">\n    <h4>\n        <button type=\"button\" class=\"makeCard btn btn-primary\" title=\"Make a New Vocabulary Card\">Make Card</button>\n        <div class=\"modal fade\" id=\"makeCardModal\" tabindex=\"-1\" role=\"dialog\">\n          <div class=\"modal-dialog\" role=\"document\">\n            <div class=\"modal-content\">\n              <div class=\"modal-header\">\n                <button type=\"button\" class=\"close\" data-dismiss=\"modal\" aria-label=\"Close\"><span aria-hidden=\"true\">&times;</span></button>\n                <h4 class=\"modal-title\">Make a Card</h4>\n              </div>\n              <div class=\"modal-body\">\n                <p><input class=\"cardWord\" value=\"";
  if (stack1 = helpers.lookup) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.lookup); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "\"/></p>\n                <textarea class=\"cardDef\" placeholder=\"Enter in the text for this card\"></textarea>\n              </div>\n              <div class=\"modal-footer\">\n                <button type=\"button\" class=\"btn btn-default\" data-dismiss=\"modal\">Close</button>\n                <button type=\"button\" class=\"btn btn-primary saveCard\">Save changes</button>\n              </div>\n            </div><!-- /.modal-content -->\n          </div><!-- /.modal-dialog -->\n        </div><!-- /.modal -->\n        Dictionary\n    </h4>\n</div>\n<div class=\"panel-body\">\n    ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.isDE), {hash:{},inverse:self.program(6, program6, data),fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n</div>";
  return buffer;
  });

this["Handlebars"]["templates"]["subtitles-controls"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, self=this;

function program1(depth0,data) {
  
  
  return "glyphicon-pause";
  }

function program3(depth0,data) {
  
  
  return "glyphicon-play";
  }

  buffer += "<div class=\"step-buttons text-center\">\n    <button type=\"button\" class=\"prev btn btn-info\" title=\"Previous Line\">\n        <span class=\"glyphicon glyphicon-step-backward\"></span>\n        <span class=\"buttonText hidden-xs\">PREV LINE</span>\n    </button>\n    <button type=\"button\" class=\"toggle-play btn btn-primary\" title=\"Toggle Play\">\n        <span class=\"glyphicon glyphicon-refresh ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.playing), {hash:{},inverse:self.program(3, program3, data),fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\"></span>\n    </button>\n    <button type=\"button\" class=\"next btn btn-info\" title=\"Next Line\">\n        <span class=\"buttonText hidden-xs\">NEXT LINE</span>\n        <span class=\"glyphicon glyphicon-step-forward\"></span>\n    </button>\n    <a tabindex=\"0\" class=\"btn btn-link infoBubble hidden-xs\" role=\"button\" data-toggle=\"popover\" data-trigger=\"focus\" title=\"Keyboard Controls\" data-html=\"true\" data-content=\"<div>Play/Pause:&nbsp;&nbsp;<kbd>space</kbd></div><div>Prev Line:&nbsp;&nbsp;<kbd>←</kbd></div><div>Next Line:&nbsp;&nbsp;<kbd>→</kbd></div>\"><span class=\"glyphicon glyphicon-info-sign\"></span></a>\n    <button class=\"btn btn-info toggle-translation hidden-xs\" title=\"Toggle Translation\">Hide English</button>\n    <button class=\"btn btn-info toggle-translation visible-xs-inline-block uk flag\" title=\"Toggle Translation\">\n    </button>\n</div>";
  return buffer;
  });

this["Handlebars"]["templates"]["subtitles-scroller"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n        <li class=\"subtitle list-group-item\">\n            <div class=\"original-subtitle\">\n                ";
  if (stack1 = helpers.original) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.original); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            </div>\n            <div class=\"translated-subtitle text-muted\">\n                ";
  if (stack1 = helpers.translation) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.translation); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            </div>\n        </li>\n    ";
  return buffer;
  }

  buffer += "<ul class=\"subtitles list-group\">\n    ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.data), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n</ul>";
  return buffer;
  });

this["Handlebars"]["templates"]["youtube-player"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  


  return "<div class=\"embed-responsive embed-responsive-16by9\">\n  <div class=\"video-container embed-responsive-item\" id=\"ytPlayer\">\n  </div>\n</div>";
  });

this["Handlebars"]["templates"]["classroom-preview"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression;


  buffer += "<div class=\"panel panel-default panel-link\" href=\"/classrooms/"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.classroom)),stack1 == null || stack1 === false ? stack1 : stack1.classroomId)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\">\n    <div class=\"classroomLink\" href=\"/classrooms/"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.classroom)),stack1 == null || stack1 === false ? stack1 : stack1.classroomId)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\">\n        <h3 class=\"panel-heading\">\n            "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.classroom)),stack1 == null || stack1 === false ? stack1 : stack1.name)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n        </h3>\n        <div class=\"songListContainer panel-body\"></div>\n    </div>\n</div>";
  return buffer;
  });

this["Handlebars"]["templates"]["classrooms"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  


  return "<div class=\"classrooms container\">\n    <h2 class=\"text-center\">Select a classroom...</h2>\n    <div class=\"previewContainer\">\n        <div class=\"classroomPreviewViews\"></div>\n    </div>\n    <div class=\"paginationContainer paginationContainerBottom\"></div>\n</div>\n<div style=\"clear: both;\"></div>";
  });

this["Handlebars"]["templates"]["footer"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  


  return "<div class=\"footer container\">\n    <p>Created by Erik Ulberg. 2016.</p>\n    <p>ulberge@gmail.com</p>\n    <script>\n      (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){\n      (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),\n      m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)\n      })(window,document,'script','//www.google-analytics.com/analytics.js','ga');\n\n      ga('create', 'UA-63331069-1', 'auto');\n      ga('send', 'pageview');\n\n    </script>\n</div>";
  });

this["Handlebars"]["templates"]["header"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, stack2, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n            <ul class=\"nav navbar-nav navbar-left\">\n                <li class=\"dropdown selectLanguage\">\n                    <a href=\"/\" class=\"dropdown-toggle\" data-toggle=\"dropdown\">Classrooms <b class=\"caret\"></b></a>\n                    <ul class=\"dropdown-menu\">\n                        ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.classrooms), {hash:{},inverse:self.noop,fn:self.program(2, program2, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                    </ul>\n                </li>\n                <li class=\"vocabulary-link\"><a href=\"/vocabulary/";
  if (stack1 = helpers.fromLanguage) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.fromLanguage); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "/";
  if (stack1 = helpers.toLanguage) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.toLanguage); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "\" class=\"vocabulary\">Vocabulary <span class=\"badge\" ";
  stack1 = helpers.unless.call(depth0, (depth0 && depth0.vocabularyCount), {hash:{},inverse:self.noop,fn:self.program(4, program4, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">";
  if (stack1 = helpers.vocabularyCount) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.vocabularyCount); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "</span></a></li>\n            </ul>\n            ";
  return buffer;
  }
function program2(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                            <li><a href=\"/classrooms/";
  if (stack1 = helpers.classroomId) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.classroomId); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "\">";
  if (stack1 = helpers.name) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.name); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "</a></li>\n                        ";
  return buffer;
  }

function program4(depth0,data) {
  
  
  return "style=\"display:none;\"";
  }

function program6(depth0,data) {
  
  var buffer = "", stack1, stack2;
  buffer += "\n                <li class=\"hidden-xs\">\n                    <a tabindex=\"0\" class=\"btn btn-link userInfoDrawer\" role=\"button\" data-toggle=\"popover\" data-placement=\"bottom\" data-html=\"true\" data-content=\"<div class='form-group'><label for='displayName'>Name</label><input type='text' class='form-control' id='displayName' value='"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.user)),stack1 == null || stack1 === false ? stack1 : stack1.displayName)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "'></div><div class='form-group'><label for='username'>User Name</label><input type='text' class='form-control' id='username' value='"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.user)),stack1 == null || stack1 === false ? stack1 : stack1.username)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "'></div><div class='form-group'><label for='password'>Change Password</label><input type='text' class='form-control' id='password' placeholder='New password' autocomplete='off'></div><button type='button' class='updateUser'>Update</button><button type='button' class='closeUpdateUser'>Close</button>\">Hello, ";
  stack2 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.user)),stack1 == null || stack1 === false ? stack1 : stack1.displayName), {hash:{},inverse:self.program(9, program9, data),fn:self.program(7, program7, data),data:data});
  if(stack2 || stack2 === 0) { buffer += stack2; }
  buffer += "</a>\n                </li>\n                <li>\n                    <a href=\"/logout\" class=\"logout\">Log Out</a>\n                </li>\n                ";
  return buffer;
  }
function program7(depth0,data) {
  
  var stack1;
  return escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.user)),stack1 == null || stack1 === false ? stack1 : stack1.displayName)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1));
  }

function program9(depth0,data) {
  
  var stack1;
  return escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.user)),stack1 == null || stack1 === false ? stack1 : stack1.username)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1));
  }

function program11(depth0,data) {
  
  
  return "\n                <li>\n                    <a href=\"/login\" class=\"login link\">Login</a>\n                </li>\n                ";
  }

  buffer += "<div class=\"navbar navbar-default\">\n    <div class=\"container-fluid\">\n        <div class=\"navbar-header\">\n            <button type=\"button\" class=\"navbar-toggle collapsed\" data-toggle=\"collapse\" data-target=\".navbar-responsive-collapse\">\n                <span class=\"icon-bar\"></span>\n                <span class=\"icon-bar\"></span>\n                <span class=\"icon-bar\"></span>\n            </button>\n            <a href=\"/\" class=\"navbar-brand\"><span class=\"icon\"></span><span class=\"brandName\">Studyokee</span></a>\n        </div>\n        <div class=\"navbar-collapse collapse navbar-responsive-collapse\">\n            ";
  stack2 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.user)),stack1 == null || stack1 === false ? stack1 : stack1.id), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack2 || stack2 === 0) { buffer += stack2; }
  buffer += "\n            <ul class=\"nav navbar-nav navbar-right\">\n                ";
  stack2 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.user)),stack1 == null || stack1 === false ? stack1 : stack1.id), {hash:{},inverse:self.program(11, program11, data),fn:self.program(6, program6, data),data:data});
  if(stack2 || stack2 === 0) { buffer += stack2; }
  buffer += "\n            </ul>\n        </div>\n    </div>\n    <div class=\"headerBottom\"></div>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["home"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, stack2, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                <a href=\"/classrooms/language/"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.fromLanguage)),stack1 == null || stack1 === false ? stack1 : stack1.language)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "/en\" class=\"signup btn callToAction btn-primary enter\" role=\"button\">Enter <i class=\"glyphicon glyphicon-arrow-right\" aria-hidden=\"true\"></i></a>\n                ";
  return buffer;
  }

function program3(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                <div class=\"selectLanguage\">\n                    \n                    <a href=\"/try_"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.fromLanguage)),stack1 == null || stack1 === false ? stack1 : stack1.language)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\" class=\"signup try btn callToAction btn-primary\" role=\"button\">Try It Out!</a>\n                </div>\n                <!--<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;or</span>\n                <a href=\"/signup\" class=\"signup btn callToAction btn-link\">Create Account</a>-->\n                ";
  return buffer;
  }

  buffer += "<div class=\"home container\">\n    <div class=\"callout\">\n        <div class=\"row\">\n            <div class=\"col-md-2\"><div class=\"headerIllustration\"></div></div>\n            <div class=\"col-md-8\">\n                <h2>Learn Spanish Through Song</h2>\n                ";
  stack2 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.user)),stack1 == null || stack1 === false ? stack1 : stack1.id), {hash:{},inverse:self.program(3, program3, data),fn:self.program(1, program1, data),data:data});
  if(stack2 || stack2 === 0) { buffer += stack2; }
  buffer += "\n            </div>\n            <div class=\"col-md-2\"><div class=\"headerIllustration\"></div></div>\n        </div>\n    </div>\n    <div class=\"row highlights\">\n        <div class=\"col-md-4\">\n            <div class=\"illustrationContainer hidden-xs\">\n                <span class=\"illustration musicVideo\"></span>\n            </div>\n            <h3>Music videos with scrolling lyrics</h3>\n        </div>\n        <div class=\"col-md-4\">\n\n            <div class=\"illustrationContainer hidden-xs\">\n                <span class=\"illustration vocabBuilder\"></span>\n            </div>\n            <h3>Add words to vocabulary builder</h3>\n        </div>\n        <div class=\"col-md-4\">\n\n            <div class=\"illustrationContainer hidden-xs\">\n                <span class=\"illustration metrics\"></span>\n            </div>\n            <h3>Track learning with metrics</h3>\n        </div>\n    </div>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["login"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  


  return "<div class=\"login\">\n    <div class=\"col-md-6 col-md-offset-3 panel panel-default\">\n        <div class=\"panel-body\">\n            <form class=\"form-horizontal\" id=\"login\">\n              <fieldset>\n                <legend>Login</legend>\n                <div class=\"form-group\">\n                  <label for=\"username\" class=\"col-lg-3\">User Name</label>\n                  <div class=\"col-lg-9\">\n                    <input type=\"text\" class=\"form-control\" id=\"username\" placeholder=\"User Name\" name=\"username\">\n                  </div>\n                </div>\n                <div class=\"form-group\">\n                  <label for=\"password\" class=\"col-lg-3\">Password</label>\n                  <div class=\"col-lg-9\">\n                    <input type=\"password\" class=\"form-control\" id=\"password\" placeholder=\"Password\" name=\"password\">\n                  </div>\n                </div>\n                <div class=\"form-group\">\n                  <div class=\"col-lg-9 col-lg-offset-3\">\n                    <button type=\"submit\" class=\"btn btn-primary\" id=\"submit\">Submit</button>\n                  </div>\n                </div>\n              </fieldset>\n            </form>\n            <a href=\"/signup\" class=\"open-signup\">Register New User</a>\n        </div>\n    </div>\n    <div class=\"col-md-3\"></div>\n    <div class=\"mask\" style=\"display:none;\">\n    Logging In...\n    </div>\n    <div style=\"clear: both;\"></div>\n</div>\n";
  });

this["Handlebars"]["templates"]["media-item-list-readonly"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n        <li data-index=\""
    + escapeExpression(((stack1 = ((stack1 = data),stack1 == null || stack1 === false ? stack1 : stack1.index)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\">\n            <span class=\"mediaItemLink\"></span>\n        </li>\n    ";
  return buffer;
  }

function program3(depth0,data) {
  
  
  return "\n        <li class=\"hasMoreItems\">...</li>\n    ";
  }

  buffer += "<ul class=\"readonlyMediaItemList\">\n    ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.mediaItems), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.hasMoreItems), {hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n</ul>";
  return buffer;
  });

this["Handlebars"]["templates"]["media-item-list"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n        <li data-index=\""
    + escapeExpression(((stack1 = ((stack1 = data),stack1 == null || stack1 === false ? stack1 : stack1.index)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\" data-id=\""
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.song)),stack1 == null || stack1 === false ? stack1 : stack1._id)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\">\n            <a class=\"mediaItemLink\"></a>\n            <button type=\"button\" class=\"view action btn btn-primary btn-xs\" title=\"Edit Song\">edit</button>\n            <button type=\"button\" class=\"remove action close\" title=\"Remove Song\">×</button>\n        </li>\n    ";
  return buffer;
  }

function program3(depth0,data) {
  
  
  return "\n        <li class=\"hasMoreItems\">...</li>\n    ";
  }

  buffer += "<ul class=\"nav nav-pills nav-stacked\">\n    ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.mediaItems), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.hasMoreItems), {hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n</ul>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["no-items"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  


  return "<div class=\"noItems\">No Results</div>";
  });

this["Handlebars"]["templates"]["media-item"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression;


  buffer += "<div class=\"center-cropped icon\">\n    <img src=\""
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.data)),stack1 == null || stack1 === false ? stack1 : stack1.icon)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\"/>\n</div>\n<div class=\"content\">\n    <div class=\"title\">\n        "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.data)),stack1 == null || stack1 === false ? stack1 : stack1.title)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n    </div>\n    <div class=\"description text-muted\">\n        <em>"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.data)),stack1 == null || stack1 === false ? stack1 : stack1.description)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "</em>\n    </div>\n</div>";
  return buffer;
  });

this["Handlebars"]["templates"]["pagination"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  


  return "<li class=\"prevPage\"><a href=\"#\">«</a></li>\n<li class=\"nextPage\"><a href=\"#\">»</a></li>\n";
  });

this["Handlebars"]["templates"]["signup"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  


  return "<div class=\"signup col-md-6 col-md-offset-3\">\n  <div class=\"panel panel-default\">\n    <div class=\"panel-body\">\n      <div class=\"registerWarning\"></div>\n      <form class=\"form-horizontal\" id=\"signup\">\n        <fieldset>\n          <legend>Signup</legend>\n          <div class=\"form-group\">\n            <label for=\"username\" class=\"col-lg-3\">User Name</label>\n            <div class=\"col-lg-9\">\n              <input type=\"text\" class=\"form-control\" id=\"username\" placeholder=\"User Name\">\n            </div>\n          </div>\n          <div class=\"form-group\">\n            <label for=\"password\" class=\"col-lg-3\">Password</label>\n            <div class=\"col-lg-9\">\n              <input type=\"password\" class=\"form-control\" id=\"password\" placeholder=\"Password\">\n            </div>\n          </div>\n          <div class=\"form-group\">\n            <div class=\"col-lg-9 col-lg-offset-3\">\n              <button type=\"submit\" class=\"btn btn-primary\" id=\"submit\">Submit</button>\n            </div>\n          </div>\n        </fieldset>\n      </form>\n      Already have an account? <a href=\"/login\" class=\"open-login\">Login</a>\n    </div>\n    <div class=\"mask\" style=\"display:none;\">\n      Loading...\n    </div>\n  </div>\n</div>\n<div style=\"clear: both;\"></div>";
  });

this["Handlebars"]["templates"]["spinner"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  


  return "<div class='spinnerContainer'>\n    <div class='spinner'></div>\n</div>";
  });

this["Handlebars"]["templates"]["vocabulary-list"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n        <a href=\"#";
  if (stack1 = helpers.link) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.link); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "\" class=\"btn btn-primary\" title=\"Study\">\n            <span class=\"buttonText\">Study</span>\n        </a>\n        ";
  return buffer;
  }

function program3(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n            <span class=\"wordListWord\">";
  if (stack1 = helpers.word) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.word); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "</span>\n        ";
  return buffer;
  }

function program5(depth0,data) {
  
  
  return "\n            No words in this list.\n        ";
  }

  buffer += "<div class=\"panel col-lg-12\">\n    <div class=\"panel-heading\">\n        <h4>";
  if (stack1 = helpers.title) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.title); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "</h4>\n        ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.link), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    </div>\n    <div class=\"panel-body\">\n        ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.words), {hash:{},inverse:self.program(5, program5, data),fn:self.program(3, program3, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    </div>\n</div>";
  return buffer;
  });

this["Handlebars"]["templates"]["vocabulary-metrics"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression;


  buffer += "<div class=\"progressSection\">\n    <h5>Level: "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.currentLevel)),stack1 == null || stack1 === false ? stack1 : stack1.label)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "</h5>\n    Next Level: "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.nextLevel)),stack1 == null || stack1 === false ? stack1 : stack1.label)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "<br>\n    <b>"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.known)),stack1 == null || stack1 === false ? stack1 : stack1.length)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "/"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.nextLevel)),stack1 == null || stack1 === false ? stack1 : stack1.count)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + " words</b>\n    <div class=\"progress\">\n      <a href=\"#known\" title=\"Words Learned\"><div class=\"progress-bar knownProgress\"></div></a>\n      <a href=\"#unknown\" class=\"progress-striped\" title=\"Words to Study\"><div class=\"progress-bar progress-bar-success unknownProgress\"></div></a>\n      <div class=\"progress-bar remainingProgress\" style=\"width: 0%;\"></div>\n    </div>\n</div>\n<ul class=\"nav nav-pills nav-stacked\">\n    <li><a href=\"#unknown\" title=\"Words to Study\" class=\"wordListLink\"><span class=\"badge\">"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.unknown)),stack1 == null || stack1 === false ? stack1 : stack1.length)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "</span>&nbsp;&nbsp;WORDS TO STUDY</a></li>\n    <li><a href=\"#known\" title=\"Words Learned\" class=\"wordListLink\"><span class=\"badge learned\">"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.known)),stack1 == null || stack1 === false ? stack1 : stack1.length)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "</span>&nbsp;&nbsp;WORDS LEARNED</a></li>\n</ul>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["vocabulary-slider"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n            <li class=\"card flipper\">\n                <div class=\"front panel panel-link\">\n                    <div class=\"flipBody panel-body\">\n                        <div class=\"wordOrPhrase\">";
  if (stack1 = helpers.word) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.word); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "</div>\n                    </div>\n                </div>\n                <div class=\"back panel panel-link\">\n                    <div class=\"flipBody panel-body\">\n                        <div class=\"wordOrPhrase\">";
  if (stack1 = helpers.word) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.word); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "</div>\n                        <div class=\"definitions\">\n                            <p>\n                                <b>";
  if (stack1 = helpers.def) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.def); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "</b>";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.part), {hash:{},inverse:self.noop,fn:self.program(2, program2, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                            </p>\n                            ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.example), {hash:{},inverse:self.noop,fn:self.program(4, program4, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                        </div>\n                    </div>\n                </div>\n            </li>\n        ";
  return buffer;
  }
function program2(depth0,data) {
  
  var buffer = "", stack1;
  buffer += ",&nbsp;<i class=\"wordType\">";
  if (stack1 = helpers.part) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.part); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "</i>";
  return buffer;
  }

function program4(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                                <p><b>ex.</b> ";
  if (stack1 = helpers.example) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.example); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "</p>\n                            ";
  return buffer;
  }

  buffer += "<div class=\"step-buttons\">\n    <button type=\"button\" class=\"editCard btn btn-primary\" data-toggle=\"modal\" data-target=\"#editCardModal\">Edit</button>\n    <div class=\"modal fade\" id=\"editCardModal\" tabindex=\"-1\" role=\"dialog\">\n      <div class=\"modal-dialog\" role=\"document\">\n        <div class=\"modal-content\">\n          <div class=\"modal-header\">\n            <button type=\"button\" class=\"close\" data-dismiss=\"modal\" aria-label=\"Close\"><span aria-hidden=\"true\">&times;</span></button>\n            <h4 class=\"modal-title\">Edit Card</h4>\n          </div>\n          <div class=\"modal-body\">\n            <p class=\"cardWord\">";
  if (stack1 = helpers.lookup) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.lookup); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "</p>\n            <textarea class=\"cardDef\" placeholder=\"Enter in the text for this card\"></textarea>\n          </div>\n          <div class=\"modal-footer\">\n            <button type=\"button\" class=\"btn btn-default\" data-dismiss=\"modal\">Close</button>\n            <button type=\"button\" class=\"btn btn-primary saveCard\">Save changes</button>\n          </div>\n        </div><!-- /.modal-content -->\n      </div><!-- /.modal-dialog -->\n    </div><!-- /.modal -->\n    <button type=\"button\" class=\"remove btn btn-primary\" title=\"I know this!\">\n        <span class=\"buttonText\">I know this!</span>\n    </button>\n    <button type=\"button\" class=\"next btn btn-info\" title=\"Next\">\n        <span class=\"buttonText\">NEXT</span>\n    </button>\n    <a tabindex=\"0\" class=\"btn btn-link hidden-xs\" role=\"button\" data-toggle=\"popover\" data-trigger=\"focus\" title=\"Keyboard Controls\" data-html=\"true\" data-content=\"<div>I KNOW THIS!:&nbsp;&nbsp;<kbd>space</kbd></div><div>NEXT:&nbsp;&nbsp;<kbd>→</kbd></div>\"><span class=\"glyphicon glyphicon-info-sign\"></span></a>\n</div>\n\n<div class=\"toStudy\">\n    <ul class=\"cards flip-container\">\n        ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.words), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    </ul>\n</div>";
  return buffer;
  });

this["Handlebars"]["templates"]["vocabulary"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression;


  buffer += "<div class=\"vocabulary-page container\">\n    <button class=\"btn btn-info visible-xs-block collapseStatsBtn\" type=\"button\" data-toggle=\"collapse\" data-target=\"#collapseStats\" aria-expanded=\"false\" aria-controls=\"collapseStats\">\n      Stats\n    </button>\n    <h4 class=\"visible-xs-block\">\n        <button type=\"button\" class=\"makeCard btn btn-primary\" data-toggle=\"modal\" data-target=\"#makeCardModal\" title=\"Make a New Vocabulary Card\">Make Card</button>\n        Vocabulary\n    </h4>\n    <div class=\"vocabularyStats panel collapse\" id=\"collapseStats\">\n        <div class=\"panel-body\">\n            <div class=\"vocabularyMetricsContainer\"></div>\n        </div>\n    </div>\n    <div class=\"col-md-4 vocabularyStats panel hidden-xs\">\n        <div class=\"panel-heading\">\n            <h4>\n                <button type=\"button\" class=\"makeCard btn btn-primary\" data-toggle=\"modal\" data-target=\"#makeCardModal\" title=\"Make a New Vocabulary Card\">Make Card</button>\n                Vocabulary\n            </h4> \n        </div>\n        <div class=\"panel-body\">\n            <div class=\"vocabularyMetricsContainer\"></div>\n        </div>\n    </div>\n    <div class=\"modal fade\" id=\"makeCardModal\" tabindex=\"-1\" role=\"dialog\">\n      <div class=\"modal-dialog\" role=\"document\">\n        <div class=\"modal-content\">\n          <div class=\"modal-header\">\n            <button type=\"button\" class=\"close\" data-dismiss=\"modal\" aria-label=\"Close\"><span aria-hidden=\"true\">&times;</span></button>\n            <h4 class=\"modal-title\">Make a Card</h4>\n          </div>\n          <div class=\"modal-body\">\n            <p><input class=\"cardWord\" value=\"";
  if (stack1 = helpers.lookup) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.lookup); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "\"/></p>\n            <textarea class=\"cardDef\" placeholder=\"Enter in the text for this card\"></textarea>\n          </div>\n          <div class=\"modal-footer\">\n            <button type=\"button\" class=\"btn btn-default\" data-dismiss=\"modal\">Close</button>\n            <button type=\"button\" class=\"btn btn-primary saveCard\">Save changes</button>\n          </div>\n        </div><!-- /.modal-content -->\n      </div><!-- /.modal-dialog -->\n    </div><!-- /.modal -->\n    <div class=\"col-md-8 vocabularyContentContainer\"></div>\n</div>";
  return buffer;
  });

return this["Handlebars"]["templates"];

});