(this.webpackJsonp=this.webpackJsonp||[]).push([[44],{"30su":function(e,t,n){"use strict";var r=n("7jeQ"),a=n.n(r),s=n("Pyw5"),o=n.n(s);function i(e){return function(e){if(Array.isArray(e))return c(e)}(e)||function(e){if("undefined"!=typeof Symbol&&Symbol.iterator in Object(e))return Array.from(e)}(e)||function(e,t){if(!e)return;if("string"==typeof e)return c(e,t);var n=Object.prototype.toString.call(e).slice(8,-1);"Object"===n&&e.constructor&&(n=e.constructor.name);if("Map"===n||"Set"===n)return Array.from(e);if("Arguments"===n||/^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n))return c(e,t)}(e)||function(){throw new TypeError("Invalid attempt to spread non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.")}()}function c(e,t){(null==t||t>e.length)&&(t=e.length);for(var n=0,r=new Array(t);n<t;n++)r[n]=e[n];return r}var l="Start".concat("}"),u="End".concat("}"),d=new RegExp("(".concat("%{","[a-z]+[\\w-]*[a-z0-9]+").concat("}",")"),"gi");const h={functional:!0,props:{message:{type:String,required:!0}},render:function(e,t){for(var n=0,r=[],s=t.scopedSlots,o=t.props.message.split(d);n<o.length;){var c=o[n];if(n+=1,d.test(c)){if(c.endsWith(l)){var h=c.slice("%{".length,-l.length),p=o.indexOf("".concat("%{").concat(h).concat(u),n);if(p>-1){var m=o.slice(n,p);if(n=p+1,!a()(s,h)){r.push.apply(r,[c].concat(i(m),[o[p]]));continue}r.push(s[h]({content:m.join("")}));continue}}var f=c.slice("%{".length,-"}".length);r.push(a()(s,f)?s[f]():c)}else r.push(c)}return r}},p=o()({},void 0,h,void 0,void 0,void 0,!1,void 0,void 0,void 0);t.a=p},"5p5H":function(e,t,n){"use strict";n.d(t,"b",(function(){return w}));n("jaBk"),n("TZoF"),n("orcL"),n("pETN");var r=n("3a3M"),a=n.n(r),s=n("IDjy"),o=n("XRO8"),i=n("ClPU"),c=n.n(i),l=n("3twG"),u=n("GuZl"),d=n("Qhxq"),h=n("/lV4");function p(e,t,n){n?(e.disable(),t.removeClass(u.c)):(e.enable(),t.addClass(u.c))}c.a.autoDiscover=!1;class m{constructor(e,t){const n=e.find(".dropzone"),r=e.find("#submit-all"),s=r.find(".js-loading-icon"),o=e.find(".dz-message");c.a.autoDiscover=!1;const i=n.dropzone({autoDiscover:!1,autoProcessQueue:!1,url:e.attr("action"),method:t,clickable:!0,uploadMultiple:!1,paramName:"file",maxFilesize:gon.max_file_size||10,parallelUploads:1,maxFiles:1,addRemoveLinks:!0,previewsContainer:".dropzone-previews",headers:d.a.headers,init(){this.on("processing",(function(){this.options.url=e.attr("action")})),this.on("addedfile",(function(){p(r,s,!1),o.addClass(u.c),a()(".dropzone-alerts").html("").hide()})),this.on("removedfile",(function(){p(r,s,!1),o.removeClass(u.c)})),this.on("success",(function(e,t){a()("#modal-upload-blob").modal("hide"),Object(l.B)(t.filePath)})),this.on("maxfilesexceeded",(function(e){o.addClass(u.c),this.removeFile(e)})),this.on("sending",(function(t,n,r){r.append("branch_name",e.find(".js-branch-name").val()),r.append("create_merge_request",e.find(".js-create-merge-request").val()),r.append("commit_message",e.find(".js-commit-message").val())}))},error(e,t){const n=a()("<div/>").html(t).text();a()(".dropzone-alerts").html(Object(h.e)(Object(h.a)("Error uploading file: %{stripped}"),{stripped:n})).show(),this.removeFile(e)}});r.on("click",(function(e){return e.preventDefault(),e.stopPropagation(),0===i[0].dropzone.getQueuedFiles().length?(alert(Object(h.a)("Please select a file")),!1):(p(r,s,!0),i[0].dropzone.processQueue(),!1)}))}}var f=n("BaXK"),g=n("NmEs"),b=n("4ZIW");const j=function(){const e=document.querySelector(".js-suggest-gitlab-ci-yml");if(e){const t=document.querySelector("#commit-changes");if(Object(f.a)(e),t){const{dismissKey:n,humanAccess:r}=e.dataset,a=new URLSearchParams(window.location.search).get("mr_path")||!0,s="suggest_gitlab_ci_yml_commit_".concat(n),o="suggest_gitlab_ci_yml_commit_changes",i="20";t.addEventListener("click",(function(){Object(g.T)(s,a),b.a.event(void 0,"click_button",{label:o,property:r,value:i})}))}}},w=function(){const e=a()(".js-upload-blob-form");if(e.length){const t=e.data("method");new m(e,t),new s.a(e),Object(g.i)(e.find(".js-commit-message"),".btn-upload-file")}};t.a=function(){const e=a()(".js-edit-blob-form"),t=a()(".js-delete-blob-form");if(e.length){const t=e.data("relativeUrlRoot"),r=e.data("assetsPrefix"),i="".concat(e.data("blobFilename")),c=a()(".js-file-title").data("currentAction"),l=e.data("project-id"),u=e.data("is-markdown"),d=a()(".js-commit-button"),h=a()(".btn.btn-cancel");Promise.all([n.e(25),n.e(120),n.e(414),n.e(33),n.e(407)]).then(n.bind(null,"DNyI")).then((function(){let{default:e}=arguments.length>0&&void 0!==arguments[0]?arguments[0]:{};new e({assetsPath:"".concat(t).concat(r),filePath:i,currentAction:c,projectId:l,isMarkdown:u}),j()})).catch((function(e){return Object(o.c)(e)})),h.on("click",(function(){window.onbeforeunload=null})),d.on("click",(function(){window.onbeforeunload=null})),new s.a(e),window.onbeforeunload=function(){return""}}w(),t.length&&new s.a(t)}},"7jeQ":function(e,t,n){var r=n("jtID"),a=n("3E1u");e.exports=function(e,t){return null!=e&&a(e,t,r)}},BaXK:function(e,t,n){"use strict";var r=n("jB52"),a=n("A7K0"),s=n("30su"),o=n("4lAS"),i=n("NmEs"),c=n("/lV4");const l=n("4ZIW").a.mixin(),u={suggest_gitlab_ci_yml:{title:Object(c.d)("suggestPipeline|1/2: Choose a template"),content:Object(c.d)("suggestPipeline|We’re adding a GitLab CI configuration file to add a pipeline to the project. You could create it manually, but we recommend that you start with a GitLab template that works out of the box."),footer:Object(c.d)("suggestPipeline|Choose %{boldStart}Code Quality%{boldEnd} to add a pipeline that tests the quality of your code.")},suggest_commit_first_project_gitlab_ci_yml:{title:Object(c.d)("suggestPipeline|2/2: Commit your changes"),content:Object(c.d)("suggestPipeline|The template is ready! You can now commit it to create your first pipeline.")}};var d={dismissTrackValue:10,clickTrackValue:"click_button",components:{GlPopover:a.a,GlSprintf:s.a,GlButton:o.a},mixins:[l],props:{target:{type:String,required:!0},trackLabel:{type:String,required:!0},dismissKey:{type:String,required:!0},humanAccess:{type:String,required:!0},mergeRequestPath:{type:String,required:!0}},data(){return{popoverDismissed:Object(i.I)(Object(i.j)("".concat(this.trackLabel,"_").concat(this.dismissKey))),tracking:{label:this.trackLabel,property:this.humanAccess}}},computed:{suggestTitle(){return u[this.trackLabel].title||""},suggestContent(){return u[this.trackLabel].content||""},suggestFooter(){return u[this.trackLabel].footer||""},emoji(){return u[this.trackLabel].emoji||""},dismissCookieName(){return"".concat(this.trackLabel,"_").concat(this.dismissKey)}},mounted(){"suggest_commit_first_project_gitlab_ci_yml"!==this.trackLabel||this.popoverDismissed||Object(i.Q)(document.querySelector(this.target)),this.trackOnShow()},methods:{onDismiss(){this.popoverDismissed=!0,Object(i.T)(this.dismissCookieName,this.popoverDismissed)},trackOnShow(){this.popoverDismissed||this.track()}}},h=n("tBpV"),p=Object(h.a)(d,(function(){var e=this,t=e.$createElement,n=e._self._c||t;return e.popoverDismissed?e._e():n("gl-popover",{attrs:{show:"",target:e.target,placement:"right",trigger:"manual",container:"viewport","css-classes":["suggest-gitlab-ci-yml","ml-4"]},scopedSlots:e._u([{key:"title",fn:function(){return[n("span",[e._v(e._s(e.suggestTitle))]),e._v(" "),n("span",{staticClass:"ml-auto"},[n("gl-button",{staticClass:"btn-blank",attrs:{"aria-label":e.__("Close"),name:"dismiss",icon:"close","data-track-property":e.humanAccess,"data-track-value":e.$options.dismissTrackValue,"data-track-event":e.$options.clickTrackValue,"data-track-label":e.trackLabel},on:{click:e.onDismiss}})],1)]},proxy:!0}],null,!1,1679289955)},[e._v(" "),n("gl-sprintf",{attrs:{message:e.suggestContent}}),e._v(" "),n("div",{staticClass:"mt-3"},[n("gl-sprintf",{attrs:{message:e.suggestFooter},scopedSlots:e._u([{key:"bold",fn:function(t){var r=t.content;return[n("strong",[e._v(" "+e._s(r)+" ")])]}}],null,!1,3035828283)})],1)],1)}),[],!1,null,null,null).exports;t.a=function(e){return new r.default({el:e,render:t=>t(p,{props:{target:e.dataset.target,trackLabel:e.dataset.trackLabel,dismissKey:e.dataset.dismissKey,mergeRequestPath:e.dataset.mergeRequestPath,humanAccess:e.dataset.humanAccess}})})}},IDjy:function(e,t,n){"use strict";n.d(t,"a",(function(){return r}));class r{constructor(e){this.form=e,this.renderDestination=this.renderDestination.bind(this),this.branchName=e.find(".js-branch-name"),this.originalBranch=e.find(".js-original-branch"),this.createMergeRequest=e.find(".js-create-merge-request"),this.createMergeRequestContainer=e.find(".js-create-merge-request-container"),this.branchName.keyup(this.renderDestination),this.renderDestination()}renderDestination(){const e=this.branchName.val()!==this.originalBranch.val();return e?(this.createMergeRequestContainer.show(),this.wasDifferent||this.createMergeRequest.prop("checked",!0)):(this.createMergeRequestContainer.hide(),this.createMergeRequest.prop("checked",!1)),this.wasDifferent=e}}},ZeWX:function(e,t,n){"use strict";n.d(t,"a",(function(){return m}));n("QifN"),n("pBsb"),n("+xeR"),n("orcL"),n("pETN");var r=n("3a3M"),a=n.n(r),s=n("06tH"),o=n.n(s),i=n("/lV4"),c=n("3twG");n("EWC9"),n("gNBD");const l=function(e){const t=new FormData(e);return function(e){return e.reduce((function(e,t){let{name:n,value:r}=t;return Object.assign(e,{[n]:r})}),{})}(Array.from(t.keys()).map((function(e){let n=t.getAll(e);return{name:e,value:1===(n=n.filter((function(e){return e}))).length?n[0]:n}})))};var u=n("2ibD"),d=n("XRO8"),h=n("k/Fq"),p=n("m/7A");class m{constructor(){!function(){const e=a()("ul.clone-options-dropdown");if(e.length){const t=a()("#clone_url"),n=a()(".js-git-clone-holder .js-clone-dropdown-label"),r=document.querySelector(".js-mobile-git-clone .js-clone-dropdown-label"),s=n.text().trim();s.length>0&&a()("a:contains('".concat(s,"')"),e).addClass("is-active"),a()("a",e).on("click",(function(n){n.preventDefault();const s=a()(n.currentTarget),o=s.attr("href"),i=s.data("cloneType");a()(".is-active",e).removeClass("is-active"),a()('a[data-clone-type="'.concat(i,'"]')).each((function(){const e=a()(this),t=e.find(".dropdown-menu-inner-title").text(),n=e.closest(".js-git-clone-holder, .js-mobile-git-clone").find(".js-clone-dropdown-label");e.toggleClass("is-active"),n.text(t)})),r?r.dataset.clipboardText=o:t.val(o),a()(".js-git-empty .js-clone").text(o)}))}}(),document.querySelector(".js-project-refs-dropdown")&&(m.initRefSwitcher(),a()(".project-refs-select").on("change",(function(){return a()(this).parents("form").trigger("submit")}))),a()(".hide-no-ssh-message").on("click",(function(e){return o.a.set("hide_no_ssh_message","false"),a()(this).parents(".no-ssh-key-message").remove(),e.preventDefault()})),a()(".hide-no-password-message").on("click",(function(e){return o.a.set("hide_no_password_message","false"),a()(this).parents(".no-password-message").remove(),e.preventDefault()})),a()(".hide-auto-devops-implicitly-enabled-banner").on("click",(function(e){const t=a()(this).data("project-id"),n="hide_auto_devops_implicitly_enabled_banner_".concat(t);return o.a.set(n,"false"),a()(this).parents(".auto-devops-implicitly-enabled-banner").remove(),e.preventDefault()})),m.projectSelectDropdown()}static projectSelectDropdown(){Object(h.a)(),a()(".project-item-select").on("click",(function(e){return m.changeProject(a()(e.currentTarget).val())}))}static changeProject(e){return window.location=e}static initRefSwitcher(){const e=document.createElement("li"),t=document.createElement("a");return t.href="#",a()(".js-project-refs-dropdown").each((function(){const n=a()(this),r=n.data("selected"),s=n.data("fieldName"),o=Boolean(n.data("visit")),h=n.closest("form"),m=h.attr("action"),f=Object(c.o)(l(h[0]),m);return Object(p.a)(n,{data(e,t){u.a.get(n.data("refsUrl"),{params:{ref:n.data("ref"),search:e}}).then((function(e){let{data:n}=e;return t(n)})).catch((function(){return Object(d.c)(Object(i.a)("An error occurred while getting projects"))}))},selectable:!0,filterable:!0,filterRemote:!0,filterByText:!0,inputFieldName:n.data("inputFieldName"),fieldName:s,renderRow(n){const a=e.cloneNode(!1),i=t.cloneNode(!1);return n===r&&(i.className="is-active"),i.textContent=n,i.dataset.ref=n,n.length>0&&o&&(i.href=Object(c.o)({[s]:n},f)),a.appendChild(i),a},id:(e,t)=>t.attr("data-ref"),toggleLabel:(e,t)=>t.text().trim(),clicked(e){const{e:t}=e;if(t.preventDefault(),o){const e=new URL(t.target.href),n=window.location.href;if(n.includes("/-/")){const t=this.fullData.Branches.concat(this.fullData.Tags).find((function(e){return n.indexOf(e)>-1}));if(t){const r=n.split(t)[1].slice(1);e.searchParams.set("path",r)}}t.metaKey?window.open(e.href,"_blank"):window.location.href=e.href}}})}))}}},gNBD:function(e,t,n){var r=n("ZfjD"),a=n("H81m"),s=n("b05b");r({target:"Object",stat:!0},{fromEntries:function(e){var t={};return a(e,(function(e,n){s(t,e,n)}),void 0,!0),t}})},gjpc:function(e,t,n){"use strict";n.r(t);var r=n("ZeWX"),a=n("CX32");new r.a,new a.a},jtID:function(e,t){var n=Object.prototype.hasOwnProperty;e.exports=function(e,t){return null!=e&&n.call(e,t)}},"k/Fq":function(e,t,n){"use strict";n("jaBk");var r=n("3a3M"),a=n.n(r),s=n("qPgm"),o=(n("pBsb"),n("n7CP")),i=n("qnJZ");class c{constructor(e){this.projectSelectInput=a()(e),this.newItemBtn=a()(".new-project-item-link"),this.resourceType=this.newItemBtn.data("type"),this.resourceLabel=this.newItemBtn.data("label"),this.formattedText=this.deriveTextVariants(),this.groupId=this.projectSelectInput.data("groupId"),this.bindEvents(),this.initLocalStorage()}bindEvents(){var e=this;this.projectSelectInput.siblings(".new-project-item-select-button").on("click",(function(t){return e.openDropdown(t)})),this.newItemBtn.on("click",(function(t){e.getProjectFromLocalStorage()||(t.preventDefault(),e.openDropdown(t))})),this.projectSelectInput.on("change",(function(){return e.selectProject()}))}initLocalStorage(){o.a.isLocalStorageAccessSafe()&&(this.localStorageKey=["group",this.groupId,this.formattedText.localStorageItemType,"recent-project"].join("-"),this.setBtnTextFromLocalStorage())}openDropdown(e){n.e(398).then(n.t.bind(null,"p9g0",7)).then((function(){Object(i.a)(gon.select2_css_path).then((function(){a()(e.currentTarget).siblings(".project-item-select").select2("open")})).catch((function(){}))})).catch((function(){}))}selectProject(){const e=JSON.parse(this.projectSelectInput.val()),t={url:"".concat(e.url,"/").concat(this.projectSelectInput.data("relativePath")),name:e.name};this.setNewItemBtnAttributes(t),this.setProjectInLocalStorage(t)}setBtnTextFromLocalStorage(){const e=this.getProjectFromLocalStorage();this.setNewItemBtnAttributes(e)}setNewItemBtnAttributes(e){e?(this.newItemBtn.attr("href",e.url),this.newItemBtn.text("".concat(this.formattedText.defaultTextPrefix," in ").concat(e.name))):this.newItemBtn.text("Select project to create ".concat(this.formattedText.presetTextSuffix))}getProjectFromLocalStorage(){const e=localStorage.getItem(this.localStorageKey);return JSON.parse(e)}setProjectInLocalStorage(e){const t=JSON.stringify(e);localStorage.setItem(this.localStorageKey,t)}deriveTextVariants(){const e=this.resourceLabel;return{localStorageItemType:"new-".concat(this.resourceType.split("_").join("-").slice(0,-1)),defaultTextPrefix:e,presetTextSuffix:this.resourceType.split("_").join(" ").slice(0,-1)}}}var l=n("/lV4");const u=function(){Object(i.a)(gon.select2_css_path).then((function(){a()(".ajax-project-select").each((function(e,t){var n=this;let r;const o=a()(t).data("simpleFilter")||!1,i=a()(t).data("select2");return this.groupId=a()(t).data("groupId"),this.userId=a()(t).data("userId"),this.includeGroups=a()(t).data("includeGroups"),this.allProjects=a()(t).data("allProjects")||!1,this.orderBy=a()(t).data("orderBy")||"id",this.withIssuesEnabled=a()(t).data("withIssuesEnabled"),this.withMergeRequestsEnabled=a()(t).data("withMergeRequestsEnabled"),this.withShared=void 0===a()(t).data("withShared")||a()(t).data("withShared"),this.includeProjectsInSubgroups=a()(t).data("includeProjectsInSubgroups")||!1,this.allowClear=a()(t).data("allowClear")||!1,r=Object(l.d)("ProjectSelect|Search for project"),this.includeGroups&&(r+=Object(l.d)("ProjectSelect| or group")),a()(t).select2({placeholder:r,minimumInputLength:0,query:function(e){let t;const r=function(t){const n={results:t};return e.callback(n)};return t=n.includeGroups?function(t){return s.a.groups(e.term,{},(function(e){const n=e.concat(t);return r(n)}))}:r,n.groupId?s.a.groupProjects(n.groupId,e.term,{with_issues_enabled:n.withIssuesEnabled,with_merge_requests_enabled:n.withMergeRequestsEnabled,with_shared:n.withShared,include_subgroups:n.includeProjectsInSubgroups,order_by:"similarity"},t):n.userId?s.a.userProjects(n.userId,e.term,{with_issues_enabled:n.withIssuesEnabled,with_merge_requests_enabled:n.withMergeRequestsEnabled,with_shared:n.withShared,include_subgroups:n.includeProjectsInSubgroups},t):s.a.projects(e.term,{order_by:n.orderBy,with_issues_enabled:n.withIssuesEnabled,with_merge_requests_enabled:n.withMergeRequestsEnabled,membership:!n.allProjects},t)},id:e=>o?e.id:JSON.stringify({name:e.name,url:e.web_url}),text:e=>e.name_with_namespace||e.name,initSelection:(e,t)=>s.a.project(e.val()).then((function(e){let{data:n}=e;return t(n)})),allowClear:this.allowClear,dropdownCssClass:"ajax-project-dropdown"}),i||o?t:new c(t)}))})).catch((function(){}))};t.a=function(){a()(".ajax-project-select").length&&n.e(398).then(n.t.bind(null,"p9g0",7)).then(u).catch((function(){}))}}}]);
//# sourceMappingURL=commons-pages.projects.blame.show-pages.projects.blob.edit-pages.projects.blob.new-pages.projects.bl-c6edf1dd.7bac1b03.chunk.js.map